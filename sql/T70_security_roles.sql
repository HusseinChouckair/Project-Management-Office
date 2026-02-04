USE PMO_DB;
GO

PRINT '=====================================================';
PRINT 'CREATING SECURITY ROLES AND PERMISSIONS';
PRINT '=====================================================';
PRINT '';


PRINT 'Step 1: Creating Database Roles';
PRINT '-----------------------------------------------------';

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'PMO_Admin' AND type = 'R')
    CREATE ROLE PMO_Admin;
PRINT 'Role created: PMO_Admin';

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Project_Manager' AND type = 'R')
    CREATE ROLE Project_Manager;
PRINT 'Role created: Project_Manager';

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Team_Member' AND type = 'R')
    CREATE ROLE Team_Member;
PRINT 'Role created: Team_Member';

PRINT '';
PRINT 'All roles created successfully!';
PRINT '';


PRINT 'Step 2: Granting Permissions';
PRINT '-----------------------------------------------------';


PRINT 'Granting permissions to PMO_Admin (Full Access)...';
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Project TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Employee TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Task TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Budget TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.ResourceAssignment TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Equipment TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Department TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Risk TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Issue TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.TimeEntry TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Milestone TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.CostCategory TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.RiskCategory TO PMO_Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON dbo.Resource TO PMO_Admin;
PRINT '  ✓ PMO_Admin permissions granted';


PRINT 'Granting permissions to Project_Manager (Read Access)...';
GRANT SELECT ON dbo.Project TO Project_Manager;
GRANT SELECT ON dbo.Employee TO Project_Manager;
GRANT SELECT ON dbo.Task TO Project_Manager;
GRANT SELECT ON dbo.Budget TO Project_Manager;
GRANT SELECT ON dbo.ResourceAssignment TO Project_Manager;
GRANT SELECT ON dbo.Equipment TO Project_Manager;
GRANT SELECT ON dbo.Department TO Project_Manager;
GRANT SELECT ON dbo.Risk TO Project_Manager;
GRANT SELECT ON dbo.Issue TO Project_Manager;
GRANT SELECT ON dbo.TimeEntry TO Project_Manager;
GRANT SELECT ON dbo.Milestone TO Project_Manager;
PRINT '  ✓ Project_Manager permissions granted';


PRINT 'Granting permissions to Team_Member (Limited Read)...';
GRANT SELECT ON dbo.Project TO Team_Member;
GRANT SELECT ON dbo.Task TO Team_Member;
GRANT SELECT ON dbo.ResourceAssignment TO Team_Member;
GRANT SELECT ON dbo.TimeEntry TO Team_Member;
GRANT SELECT ON dbo.Employee TO Team_Member;
PRINT '  ✓ Team_Member permissions granted';

PRINT '';
PRINT 'All permissions granted successfully!';
PRINT '';


PRINT 'Step 3: Creating Audit Table';
PRINT '-----------------------------------------------------';

IF OBJECT_ID('dbo.AuditLog', 'U') IS NOT NULL
BEGIN
    DROP TABLE dbo.AuditLog;
    PRINT 'Existing AuditLog table dropped';
END
GO

CREATE TABLE dbo.AuditLog
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    TableName NVARCHAR(100) NOT NULL,
    Action NVARCHAR(10) NOT NULL, 
    RecordID INT NOT NULL,
    OldValue NVARCHAR(MAX) NULL,
    NewValue NVARCHAR(MAX) NULL,
    PerformedBy NVARCHAR(100) NOT NULL DEFAULT SUSER_SNAME(),
    PerformedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_AuditLog_Action CHECK (Action IN ('INSERT', 'UPDATE', 'DELETE'))
);
GO


GRANT SELECT, INSERT ON dbo.AuditLog TO PMO_Admin;
GRANT SELECT ON dbo.AuditLog TO Project_Manager;

PRINT 'AuditLog table created successfully!';
PRINT '';


PRINT 'Step 4: Creating Audit Trigger';
PRINT '-----------------------------------------------------';

IF OBJECT_ID('dbo.tr_Project_Audit', 'TR') IS NOT NULL
    DROP TRIGGER dbo.tr_Project_Audit;
GO

CREATE TRIGGER dbo.tr_Project_Audit
ON dbo.Project
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dbo.AuditLog (TableName, Action, RecordID, OldValue, NewValue, PerformedBy)
    SELECT 
        'Project',
        'UPDATE',
        i.ProjectID,
        CONCAT(
            'Status=', d.[Status], 
            ', Budget=', d.TotalBudget,
            ', ActualCost=', ISNULL(CAST(d.ActualCost AS VARCHAR(20)), 'NULL'),
            ', EndDate=', ISNULL(CAST(d.ActualEndDate AS VARCHAR(10)), 'NULL')
        ),
        CONCAT(
            'Status=', i.[Status], 
            ', Budget=', i.TotalBudget,
            ', ActualCost=', ISNULL(CAST(i.ActualCost AS VARCHAR(20)), 'NULL'),
            ', EndDate=', ISNULL(CAST(i.ActualEndDate AS VARCHAR(10)), 'NULL')
        ),
        SUSER_SNAME()
    FROM inserted i
    INNER JOIN deleted d ON i.ProjectID = d.ProjectID
    WHERE d.[Status] <> i.[Status]
       OR d.TotalBudget <> i.TotalBudget
       OR ISNULL(d.ActualCost, 0) <> ISNULL(i.ActualCost, 0)
       OR ISNULL(d.ActualEndDate, '1900-01-01') <> ISNULL(i.ActualEndDate, '1900-01-01');
END;
GO

PRINT 'Audit trigger tr_Project_Audit created successfully!';
PRINT '';


PRINT 'Step 5: Granting EXECUTE Permissions on Stored Procedures';
PRINT '-----------------------------------------------------';


GRANT EXECUTE ON dbo.usp_Project_Insert TO PMO_Admin;
GRANT EXECUTE ON dbo.usp_Resource_AssignToProject TO PMO_Admin;
GRANT EXECUTE ON dbo.usp_Project_UpdateStatus TO PMO_Admin;
PRINT '  ✓ PMO_Admin granted EXECUTE on all procedures';


GRANT EXECUTE ON dbo.usp_Project_Insert TO Project_Manager;
GRANT EXECUTE ON dbo.usp_Resource_AssignToProject TO Project_Manager;
GRANT EXECUTE ON dbo.usp_Project_UpdateStatus TO Project_Manager;
PRINT '  ✓ Project_Manager granted EXECUTE on all procedures';


PRINT '  ✓ Team_Member has no EXECUTE permissions (read-only)';

PRINT '';
PRINT 'All stored procedure permissions granted successfully!';
PRINT '';

PRINT '=====================================================';
PRINT 'SECURITY SETUP COMPLETED SUCCESSFULLY';
PRINT '=====================================================';
PRINT '';
PRINT 'Summary:';
PRINT '  ✓ 3 Database Roles Created';
PRINT '  ✓ Table Permissions Granted';
PRINT '  ✓ Stored Procedure EXECUTE Permissions Granted';
PRINT '  ✓ AuditLog Table Created';
PRINT '  ✓ Project Audit Trigger Created';
PRINT '';
GO