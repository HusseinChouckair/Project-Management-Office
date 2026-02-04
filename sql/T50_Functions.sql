USE PMO_DB;
GO



CREATE OR ALTER FUNCTION dbo.fn_GetProjectBudgetUtilization
(
    @ProjectID INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Utilization DECIMAL(5,2);
    DECLARE @TotalPlanned DECIMAL(12,2);
    DECLARE @TotalActual DECIMAL(12,2);

    
    SELECT 
        @TotalPlanned = SUM(PlannedAmount),
        @TotalActual = SUM(ISNULL(ActualAmount, 0))
    FROM dbo.Budget
    WHERE ProjectID = @ProjectID;

    
    IF @TotalPlanned > 0
        SET @Utilization = ROUND((@TotalActual / @TotalPlanned) * 100, 2);
    ELSE
        SET @Utilization = 0;

    RETURN ISNULL(@Utilization, 0);
END;
GO


CREATE OR ALTER FUNCTION dbo.fn_GetEmployeeFullName
(
    @EmployeeID INT
)
RETURNS VARCHAR(150)
AS
BEGIN
    DECLARE @FullName VARCHAR(150);

    SELECT @FullName = FirstName + ' ' + LastName
    FROM dbo.Employee
    WHERE EmployeeID = @EmployeeID;

    RETURN ISNULL(@FullName, 'Unknown Employee');
END;
GO


CREATE OR ALTER FUNCTION dbo.fn_GetProjectCompletionPercent
(
    @ProjectID INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Completion DECIMAL(5,2);
    DECLARE @TaskCount INT;
    DECLARE @TotalCompletion DECIMAL(12,2);

   
    SELECT 
        @TaskCount = COUNT(*),
        @TotalCompletion = SUM(ISNULL(PercentComplete, 0))
    FROM dbo.Task
    WHERE ProjectID = @ProjectID;

    
    IF @TaskCount > 0
        SET @Completion = ROUND(@TotalCompletion / @TaskCount, 2);
    ELSE
        SET @Completion = 0;

    RETURN ISNULL(@Completion, 0);
END;
GO


CREATE OR ALTER FUNCTION dbo.fn_GetProjectTasks
(
    @ProjectID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        t.TaskID,
        t.TaskName,
        t.[Status] AS TaskStatus,
        t.Priority,
        t.PercentComplete,
        t.EstimatedHours,
        t.ActualHours,
        t.RemainingHours,
        ISNULL(e.FirstName + ' ' + e.LastName, 'Unassigned') AS AssignedEmployee,
        e.Email AS AssignedEmployeeEmail,
        p.ProjectName,
        p.ProjectCode
    FROM dbo.Task t
    INNER JOIN dbo.Project p ON t.ProjectID = p.ProjectID
    LEFT JOIN dbo.ResourceAssignment ra ON t.AssignmentID = ra.AssignmentID
    LEFT JOIN dbo.Employee e ON ra.EmployeeID = e.EmployeeID AND ra.ResourceType = 'Employee'
    WHERE t.ProjectID = @ProjectID
);
GO

PRINT '=====================================================';
PRINT 'ALL FUNCTIONS CREATED SUCCESSFULLY!';
PRINT '=====================================================';
PRINT '';
PRINT 'Scalar Functions (return single values):';
PRINT '  1. fn_GetProjectBudgetUtilization';
PRINT '  2. fn_GetEmployeeFullName';
PRINT '  3. fn_GetProjectCompletionPercent';
PRINT '';
PRINT 'Table-Valued Function (returns table):';
PRINT '  4. fn_GetProjectTasks';
PRINT '';
PRINT '=====================================================';
GO