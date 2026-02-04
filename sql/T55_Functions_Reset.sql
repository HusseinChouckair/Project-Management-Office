USE PMO_DB;
GO


IF OBJECT_ID('dbo.fn_GetProjectBudgetUtilization', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_GetProjectBudgetUtilization;
GO

IF OBJECT_ID('dbo.fn_GetEmployeeFullName', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_GetEmployeeFullName;
GO

IF OBJECT_ID('dbo.fn_GetProjectCompletionPercent', 'FN') IS NOT NULL
    DROP FUNCTION dbo.fn_GetProjectCompletionPercent;
GO


IF OBJECT_ID('dbo.fn_GetProjectTasks', 'IF') IS NOT NULL
    DROP FUNCTION dbo.fn_GetProjectTasks;
GO

PRINT 'All functions dropped successfully!';
