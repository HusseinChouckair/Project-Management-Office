USE PMO_DB;
GO


CREATE OR ALTER PROCEDURE dbo.usp_Project_Insert
(
    @ProjectCode        VARCHAR(20),
    @ProjectName        VARCHAR(150),
    @Description        VARCHAR(500),
    @Methodology        VARCHAR(50),
    @Status             VARCHAR(30),
    @Priority           VARCHAR(20),
    @DepartmentID       INT,
    @ProjectManagerID   INT,
    @SponsorID          INT = NULL,
    @StartDate          DATE,
    @PlannedEndDate     DATE,
    @TotalBudget        DECIMAL(12,2),
    @NewProjectID       INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        
        IF @ProjectCode IS NULL OR @ProjectName IS NULL
        BEGIN
            RAISERROR('ProjectCode and ProjectName are required.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO dbo.Project
        (
            ProjectCode,
            ProjectName,
            [Description],
            Methodology,
            [Status],
            Priority,
            DepartmentID,
            ProjectManagerID,
            SponsorID,
            StartDate,
            PlannedEndDate,
            TotalBudget,
            CreatedDate
        )
        VALUES
        (
            @ProjectCode,
            @ProjectName,
            @Description,
            @Methodology,
            @Status,
            @Priority,
            @DepartmentID,
            @ProjectManagerID,
            @SponsorID,
            @StartDate,
            @PlannedEndDate,
            @TotalBudget,
            GETDATE()
        );

        
        SET @NewProjectID = SCOPE_IDENTITY();

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO






CREATE OR ALTER PROCEDURE dbo.usp_Resource_AssignToProject
(
    @ProjectID          INT,
    @ResourceType       VARCHAR(20),   
    @EmployeeID         INT = NULL,
    @EquipmentID        INT = NULL,
    @AllocationPercent  INT,
    @Role               VARCHAR(100) = NULL,
    @StartDate          DATE,
    @EndDate            DATE = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

       
        IF @ResourceType NOT IN ('Employee', 'Equipment')
        BEGIN
            RAISERROR('Invalid ResourceType. Use Employee or Equipment.', 16, 1);
            ROLLBACK;
            RETURN;
        END

        
        IF (@ResourceType = 'Employee' AND @EmployeeID IS NULL)
           OR (@ResourceType = 'Equipment' AND @EquipmentID IS NULL)
        BEGIN
            RAISERROR('Correct Resource ID must be provided.', 16, 1);
            ROLLBACK;
            RETURN;
        END

        INSERT INTO dbo.ResourceAssignment
        (
            ProjectID,
            EmployeeID,
            EquipmentID,
            ResourceType,
            AllocationPercent,
            [Role],
            StartDate,
            EndDate,
            AssignedDate
        )
        VALUES
        (
            @ProjectID,
            @EmployeeID,
            @EquipmentID,
            @ResourceType,
            @AllocationPercent,
            @Role,
            @StartDate,
            @EndDate,
            GETDATE()
        );

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO



CREATE OR ALTER PROCEDURE dbo.usp_Project_UpdateStatus
(
    @ProjectID      INT,
    @NewStatus      VARCHAR(30),
    @ActualEndDate  DATE = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        
        IF @NewStatus NOT IN ('Planned', 'In Progress', 'Completed', 'Cancelled')
        BEGIN
            RAISERROR('Invalid project status.', 16, 1);
            ROLLBACK;
            RETURN;
        END

        UPDATE dbo.Project
        SET
            [Status] = @NewStatus,
            ActualEndDate =
                CASE 
                    WHEN @NewStatus = 'Completed' THEN ISNULL(@ActualEndDate, GETDATE())
                    ELSE ActualEndDate
                END
        WHERE ProjectID = @ProjectID;

        COMMIT;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END;
GO
