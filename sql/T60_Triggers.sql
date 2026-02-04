USE PMO_DB;
GO


IF OBJECT_ID('dbo.ProjectStatusLog', 'U') IS NOT NULL
    DROP TABLE dbo.ProjectStatusLog;
GO

IF OBJECT_ID('dbo.BudgetUpdateLog', 'U') IS NOT NULL
    DROP TABLE dbo.BudgetUpdateLog;
GO

PRINT '====================================================';
PRINT 'CREATING LOGGING TABLES';
PRINT '====================================================';


CREATE TABLE dbo.ProjectStatusLog
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ProjectID INT NOT NULL,
    OldStatus VARCHAR(50),
    NewStatus VARCHAR(50),
    ChangeDate DATETIME NOT NULL DEFAULT GETDATE(),
    ChangedBy VARCHAR(100) DEFAULT SYSTEM_USER
);

PRINT 'Created table: ProjectStatusLog';


CREATE TABLE dbo.BudgetUpdateLog
(
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    BudgetID INT NOT NULL,
    ProjectID INT NOT NULL,
    OldPlanned DECIMAL(12,2),
    NewPlanned DECIMAL(12,2),
    OldActual DECIMAL(12,2),
    NewActual DECIMAL(12,2),
    ChangeDate DATETIME NOT NULL DEFAULT GETDATE(),
    ChangedBy VARCHAR(100) DEFAULT SYSTEM_USER
);

PRINT 'Created table: BudgetUpdateLog';
PRINT '';

GO

PRINT '====================================================';
PRINT 'CREATING TRIGGERS';
PRINT '====================================================';


IF OBJECT_ID('dbo.tr_ProjectStatus_Update', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tr_ProjectStatus_Update;
GO

CREATE TRIGGER dbo.tr_ProjectStatus_Update
ON dbo.Project
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    
    IF UPDATE([Status])
    BEGIN
        
        UPDATE t
        SET t.[Status] = 'Blocked'
        FROM dbo.Task t
        INNER JOIN inserted i ON t.ProjectID = i.ProjectID
        WHERE i.[Status] = 'OnHold'
          AND t.[Status] NOT IN ('Done', 'Cancelled');

        
        UPDATE t
        SET t.[Status] = 'Cancelled'
        FROM dbo.Task t
        INNER JOIN inserted i ON t.ProjectID = i.ProjectID
        WHERE i.[Status] = 'Cancelled'
          AND t.[Status] NOT IN ('Done', 'Cancelled');

        
        INSERT INTO dbo.ProjectStatusLog (ProjectID, OldStatus, NewStatus, ChangeDate)
        SELECT 
            i.ProjectID, 
            d.[Status], 
            i.[Status], 
            GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.ProjectID = d.ProjectID
        WHERE d.[Status] <> i.[Status];
    END
END;
GO

PRINT 'Created trigger: tr_ProjectStatus_Update';


IF OBJECT_ID('dbo.tr_ResourceAssignment_CheckAllocation', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tr_ResourceAssignment_CheckAllocation;
GO

CREATE TRIGGER dbo.tr_ResourceAssignment_CheckAllocation
ON dbo.ResourceAssignment
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    
    IF EXISTS (SELECT 1 FROM inserted WHERE ResourceType = 'Employee' AND EmployeeID IS NOT NULL)
    BEGIN
        DECLARE @OverAllocated TABLE (EmployeeID INT, TotalAllocation DECIMAL(5,2));

        
        INSERT INTO @OverAllocated (EmployeeID, TotalAllocation)
        SELECT 
            ra.EmployeeID,
            SUM(ra.AllocationPercent) AS TotalAllocation
        FROM dbo.ResourceAssignment ra
        INNER JOIN inserted i ON ra.EmployeeID = i.EmployeeID
        WHERE ra.ResourceType = 'Employee'
          AND ra.EmployeeID IS NOT NULL
          AND ra.EndDate IS NULL OR ra.EndDate >= GETDATE()  
        GROUP BY ra.EmployeeID
        HAVING SUM(ra.AllocationPercent) > 100;

        
        IF EXISTS (SELECT 1 FROM @OverAllocated)
        BEGIN
            DECLARE @EmpID INT, @Total DECIMAL(5,2), @EmpName VARCHAR(150);
            
            SELECT TOP 1 
                @EmpID = oa.EmployeeID, 
                @Total = oa.TotalAllocation,
                @EmpName = e.FirstName + ' ' + e.LastName
            FROM @OverAllocated oa
            INNER JOIN dbo.Employee e ON oa.EmployeeID = e.EmployeeID;

            DECLARE @ErrorMsg VARCHAR(500);
            SET @ErrorMsg = 'Employee over-allocation detected: ' + @EmpName + 
                          ' (ID: ' + CAST(@EmpID AS VARCHAR(10)) + ') would be allocated ' + 
                          CAST(@Total AS VARCHAR(10)) + '%. Maximum allowed is 100%.';
            
            THROW 50001, @ErrorMsg, 1;
        END
    END
END;
GO

PRINT 'Created trigger: tr_ResourceAssignment_CheckAllocation';


IF OBJECT_ID('dbo.tr_Budget_Update', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tr_Budget_Update;
GO

CREATE TRIGGER dbo.tr_Budget_Update
ON dbo.Budget
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    
    INSERT INTO dbo.BudgetUpdateLog (
        BudgetID, 
        ProjectID, 
        OldPlanned, 
        NewPlanned, 
        OldActual, 
        NewActual, 
        ChangeDate
    )
    SELECT 
        i.BudgetID,
        i.ProjectID, 
        d.PlannedAmount, 
        i.PlannedAmount, 
        d.ActualAmount, 
        i.ActualAmount, 
        GETDATE()
    FROM inserted i
    INNER JOIN deleted d ON i.BudgetID = d.BudgetID
    WHERE d.PlannedAmount <> i.PlannedAmount
       OR ISNULL(d.ActualAmount, 0) <> ISNULL(i.ActualAmount, 0);
END;
GO

PRINT 'Created trigger: tr_Budget_Update';
PRINT '';
PRINT '====================================================';
PRINT 'ALL TRIGGERS CREATED SUCCESSFULLY';
PRINT '====================================================';
GO