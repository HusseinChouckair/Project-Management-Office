USE PMO_DB;
GO

SET NOCOUNT ON;
GO

PRINT '=====================================================';
PRINT 'TESTING ALL FUNCTIONS';
PRINT 'Test Date: ' + CONVERT(VARCHAR(50), GETDATE(), 120);
PRINT '=====================================================';
PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 1: fn_GetProjectBudgetUtilization (Scalar)';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';

DECLARE @Result1 DECIMAL(5,2);


SELECT @Result1 = dbo.fn_GetProjectBudgetUtilization(1);
PRINT '  Project ID 1:   ' + CAST(@Result1 AS VARCHAR(10)) + '%';


SELECT @Result1 = dbo.fn_GetProjectBudgetUtilization(2);
PRINT '  Project ID 2:   ' + CAST(@Result1 AS VARCHAR(10)) + '%';


SELECT @Result1 = dbo.fn_GetProjectBudgetUtilization(999);
PRINT '  Project ID 999: ' + CAST(@Result1 AS VARCHAR(10)) + '% (non-existent)';

PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 2: fn_GetEmployeeFullName (Scalar)';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';

DECLARE @Name VARCHAR(150);


SELECT @Name = dbo.fn_GetEmployeeFullName(1);
PRINT '  Employee ID 1:   ' + @Name;


SELECT @Name = dbo.fn_GetEmployeeFullName(2);
PRINT '  Employee ID 2:   ' + @Name;


SELECT @Name = dbo.fn_GetEmployeeFullName(3);
PRINT '  Employee ID 3:   ' + @Name;


SELECT @Name = dbo.fn_GetEmployeeFullName(999);
PRINT '  Employee ID 999: ' + @Name + ' (non-existent)';

PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 3: fn_GetProjectCompletionPercent (Scalar)';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';

DECLARE @CompPct DECIMAL(5,2);


SELECT @CompPct = dbo.fn_GetProjectCompletionPercent(1);
PRINT '  Project ID 1:   ' + CAST(@CompPct AS VARCHAR(10)) + '%';


SELECT @CompPct = dbo.fn_GetProjectCompletionPercent(2);
PRINT '  Project ID 2:   ' + CAST(@CompPct AS VARCHAR(10)) + '%';


SELECT @CompPct = dbo.fn_GetProjectCompletionPercent(999);
PRINT '  Project ID 999: ' + CAST(@CompPct AS VARCHAR(10)) + '% (non-existent)';

PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 4: fn_GetProjectTasks (Table-Valued Function)';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';
PRINT 'Tasks for Project ID 1:';
PRINT '';

SELECT 
    TaskID,
    TaskName,
    TaskStatus,
    Priority,
    PercentComplete,
    EstimatedHours,
    ActualHours,
    RemainingHours,
    AssignedEmployee,
    AssignedEmployeeEmail,
    ProjectName,
    ProjectCode
FROM dbo.fn_GetProjectTasks(1);

PRINT '';
PRINT 'Tasks for Project ID 2:';
PRINT '';

SELECT 
    TaskID,
    TaskName,
    TaskStatus,
    Priority,
    PercentComplete,
    EstimatedHours,
    ActualHours,
    RemainingHours,
    AssignedEmployee,
    AssignedEmployeeEmail,
    ProjectName,
    ProjectCode
FROM dbo.fn_GetProjectTasks(2);

PRINT '';
PRINT 'Tasks for Project ID 999 (non-existent):';
PRINT '';

SELECT 
    TaskID,
    TaskName,
    TaskStatus,
    Priority,
    PercentComplete,
    EstimatedHours,
    ActualHours,
    RemainingHours,
    AssignedEmployee,
    AssignedEmployeeEmail,
    ProjectName,
    ProjectCode
FROM dbo.fn_GetProjectTasks(999);

PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'COMPREHENSIVE SUMMARY: All Functions for Project 1';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';

SELECT 
    p.ProjectID,
    p.ProjectCode,
    p.ProjectName,
    p.[Status] AS ProjectStatus,
    p.Priority,
    p.TotalBudget,
    p.ActualCost,
    dbo.fn_GetProjectBudgetUtilization(p.ProjectID) AS BudgetUtilization_Pct,
    dbo.fn_GetProjectCompletionPercent(p.ProjectID) AS TaskCompletion_Pct,
    dbo.fn_GetEmployeeFullName(p.ProjectManagerID) AS ProjectManager
FROM dbo.Project p
WHERE p.ProjectID = 1;

PRINT '';
PRINT 'Detailed Task List for Project 1:';
PRINT '';

SELECT 
    TaskID,
    TaskName,
    TaskStatus,
    Priority,
    PercentComplete,
    EstimatedHours,
    ActualHours,
    RemainingHours,
    AssignedEmployee
FROM dbo.fn_GetProjectTasks(1)
ORDER BY TaskID;

PRINT '';
PRINT '=====================================================';
PRINT 'ALL TESTS COMPLETED SUCCESSFULLY';
PRINT '=====================================================';

SET NOCOUNT OFF;
GO