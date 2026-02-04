USE PMO_DB;
GO


IF OBJECT_ID('dbo.vw_EmployeeDetails', 'V') IS NOT NULL 
    DROP VIEW dbo.vw_EmployeeDetails;
GO

CREATE VIEW dbo.vw_EmployeeDetails
AS
SELECT
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Email,
    e.Phone,
    e.JobTitle,
    e.HourlyRate,
    e.HireDate,
    d.DepartmentID,
    d.DepartmentName,
    d.DepartmentCode,
    e.ResourceID,
    e.IsActive
FROM dbo.Employee e
INNER JOIN dbo.Department d
    ON e.DepartmentID = d.DepartmentID;
GO


IF OBJECT_ID('dbo.vw_ProjectOverview', 'V') IS NOT NULL 
    DROP VIEW dbo.vw_ProjectOverview;
GO

CREATE VIEW dbo.vw_ProjectOverview
AS
SELECT
    p.ProjectID,
    p.ProjectCode,
    p.ProjectName,
    p.[Description] AS ProjectDescription,
    p.Methodology,
    p.[Status],
    p.Priority,
    d.DepartmentID,
    d.DepartmentName,
    pm.EmployeeID AS ProjectManagerID,
    pm.FirstName + ' ' + pm.LastName AS ProjectManager,
    ISNULL(sp.FirstName + ' ' + sp.LastName, 'No Sponsor') AS Sponsor,
    p.StartDate,
    p.PlannedEndDate,
    p.ActualEndDate,
    p.TotalBudget,
    ISNULL(p.ActualCost, 0.00) AS ActualCost,
    p.TotalBudget - ISNULL(p.ActualCost, 0.00) AS RemainingBudget,
    CASE 
        WHEN p.TotalBudget > 0 THEN 
            ROUND((ISNULL(p.ActualCost, 0.00) / p.TotalBudget) * 100, 2)
        ELSE 0 
    END AS BudgetUtilizationPercent,
    p.CreatedDate
FROM dbo.Project p
INNER JOIN dbo.Department d
    ON p.DepartmentID = d.DepartmentID
INNER JOIN dbo.Employee pm
    ON p.ProjectManagerID = pm.EmployeeID
LEFT JOIN dbo.Employee sp
    ON p.SponsorID = sp.EmployeeID;
GO


IF OBJECT_ID('dbo.vw_ResourceAssignments', 'V') IS NOT NULL 
    DROP VIEW dbo.vw_ResourceAssignments;
GO

CREATE VIEW dbo.vw_ResourceAssignments
AS
SELECT
    ra.AssignmentID,
    ra.ProjectID,
    p.ProjectCode,
    p.ProjectName,
    p.[Status] AS ProjectStatus,
    ra.ResourceType,
    ra.EmployeeID,
    CASE 
        WHEN ra.ResourceType = 'Employee' THEN e.FirstName + ' ' + e.LastName 
        ELSE NULL 
    END AS EmployeeName,
    CASE 
        WHEN ra.ResourceType = 'Employee' THEN e.JobTitle 
        ELSE NULL 
    END AS EmployeeJobTitle,
    ra.EquipmentID,
    CASE 
        WHEN ra.ResourceType = 'Equipment' THEN eq.EquipmentName 
        ELSE NULL 
    END AS EquipmentName,
    CASE 
        WHEN ra.ResourceType = 'Equipment' THEN eq.[Type] 
        ELSE NULL 
    END AS EquipmentType,
    ra.AllocationPercent,
    ra.[Role],
    ra.StartDate,
    ra.EndDate,
    ra.AssignedDate,
    DATEDIFF(DAY, ra.StartDate, ISNULL(ra.EndDate, GETDATE())) AS AssignmentDurationDays
FROM dbo.ResourceAssignment ra
INNER JOIN dbo.Project p
    ON ra.ProjectID = p.ProjectID
LEFT JOIN dbo.Employee e
    ON ra.EmployeeID = e.EmployeeID AND ra.ResourceType = 'Employee'
LEFT JOIN dbo.Equipment eq
    ON ra.EquipmentID = eq.EquipmentID AND ra.ResourceType = 'Equipment';
GO


IF OBJECT_ID('dbo.vw_TaskTracking', 'V') IS NOT NULL 
    DROP VIEW dbo.vw_TaskTracking;
GO

CREATE VIEW dbo.vw_TaskTracking
AS
SELECT
    t.TaskID,
    t.TaskName,
    t.[Description] AS TaskDescription,
    t.[Status],
    t.Priority,
    t.PercentComplete,
    t.EstimatedHours,
    t.ActualHours,
    t.RemainingHours,
    CASE 
        WHEN t.EstimatedHours > 0 THEN 
            ROUND((ISNULL(t.ActualHours, 0) / t.EstimatedHours) * 100, 2)
        ELSE 0 
    END AS HoursUtilizationPercent,
    t.PlannedStartDate,
    t.PlannedEndDate,
    p.ProjectID,
    p.ProjectCode,
    p.ProjectName,
    p.[Status] AS ProjectStatus,
    t.ParentTaskID,
    pt.TaskName AS ParentTaskName,
    t.AssignmentID,
    ra.ResourceType,
    CASE 
        WHEN ra.ResourceType = 'Employee' THEN e.FirstName + ' ' + e.LastName 
        ELSE NULL 
    END AS AssignedEmployee,
    CASE 
        WHEN ra.ResourceType = 'Employee' THEN e.Email 
        ELSE NULL 
    END AS AssignedEmployeeEmail
FROM dbo.Task t
INNER JOIN dbo.Project p
    ON t.ProjectID = p.ProjectID
LEFT JOIN dbo.Task pt
    ON t.ParentTaskID = pt.TaskID
LEFT JOIN dbo.ResourceAssignment ra
    ON t.AssignmentID = ra.AssignmentID
LEFT JOIN dbo.Employee e
    ON ra.EmployeeID = e.EmployeeID;
GO


IF OBJECT_ID('dbo.vw_ProjectBudgetSummary', 'V') IS NOT NULL 
    DROP VIEW dbo.vw_ProjectBudgetSummary;
GO

CREATE VIEW dbo.vw_ProjectBudgetSummary
AS
SELECT
    p.ProjectID,
    p.ProjectCode,
    p.ProjectName,
    p.[Status] AS ProjectStatus,
    cc.CategoryID AS CostCategoryID,
    cc.CategoryName,
    cc.CategoryCode,
    b.BudgetID,
    b.PlannedAmount,
    ISNULL(b.ActualAmount, 0.00) AS ActualAmount,
    ISNULL(b.CommittedAmount, 0.00) AS CommittedAmount,
    b.VarianceAmount,
    b.PlannedAmount - ISNULL(b.ActualAmount, 0.00) AS RemainingBudget,
    CASE 
        WHEN b.PlannedAmount > 0 THEN 
            ROUND((ISNULL(b.ActualAmount, 0.00) / b.PlannedAmount) * 100, 2)
        ELSE 0 
    END AS BudgetUtilizationPercent,
    CASE 
        WHEN ISNULL(b.ActualAmount, 0.00) > b.PlannedAmount THEN 'Over Budget'
        WHEN ISNULL(b.ActualAmount, 0.00) >= (b.PlannedAmount * 0.9) THEN 'Near Limit'
        ELSE 'Within Budget'
    END AS BudgetStatus,
    b.FiscalYear,
    b.FiscalName,
    b.LastUpdatedDate
FROM dbo.Budget b
INNER JOIN dbo.Project p
    ON b.ProjectID = p.ProjectID
INNER JOIN dbo.CostCategory cc
    ON b.CostCategoryID = cc.CategoryID;
GO


IF OBJECT_ID('dbo.vw_RiskIssueOverview', 'V') IS NOT NULL 
    DROP VIEW dbo.vw_RiskIssueOverview;
GO

CREATE VIEW dbo.vw_RiskIssueOverview
AS
SELECT
    'Risk' AS ItemType,
    r.RiskID AS ItemID,
    p.ProjectID,
    p.ProjectCode,
    p.ProjectName,
    p.[Status] AS ProjectStatus,
    rc.CategoryName AS Category,
    r.RiskDescription AS [Description],
    NULL AS Severity,
    r.Probability,
    r.Impact,
    r.RiskScore AS Score,
    r.[Status] AS ItemStatus,
    e.EmployeeID AS OwnerID,
    e.FirstName + ' ' + e.LastName AS Owner,
    e.Email AS OwnerEmail,
    r.IdentifiedDate AS RaisedDate,
    NULL AS ResolvedDate,
    r.MitigationStrategy AS ActionPlan,
    NULL AS Resolution
FROM dbo.Risk r
INNER JOIN dbo.Project p
    ON r.ProjectID = p.ProjectID
INNER JOIN dbo.RiskCategory rc
    ON r.CategoryID = rc.CategoryID
INNER JOIN dbo.Employee e
    ON r.OwnerEmployeeID = e.EmployeeID

UNION ALL

SELECT
    'Issue' AS ItemType,
    i.IssueID AS ItemID,
    p.ProjectID,
    p.ProjectCode,
    p.ProjectName,
    p.[Status] AS ProjectStatus,
    'Issue' AS Category,
    i.IssueDescription AS [Description],
    i.Severity,
    NULL AS Probability,
    NULL AS Impact,
    CASE 
        WHEN i.Severity = 'Critical' THEN 5
        WHEN i.Severity = 'High' THEN 4
        WHEN i.Severity = 'Medium' THEN 3
        ELSE 2
    END AS Score,
    i.[Status] AS ItemStatus,
    rep.EmployeeID AS OwnerID,
    rep.FirstName + ' ' + rep.LastName AS Owner,
    rep.Email AS OwnerEmail,
    i.RaisedDate,
    i.ResolvedDate,
    NULL AS ActionPlan,
    i.Resolution
FROM dbo.Issue i
INNER JOIN dbo.Project p
    ON i.ProjectID = p.ProjectID
INNER JOIN dbo.Employee rep
    ON i.ReportedByEmpID = rep.EmployeeID;
GO


IF OBJECT_ID('dbo.vw_TimeEntrySummary', 'V') IS NOT NULL 
    DROP VIEW dbo.vw_TimeEntrySummary;
GO

CREATE VIEW dbo.vw_TimeEntrySummary
AS
SELECT
    te.TimeEntryID,
    te.WorkDate,
    te.HoursWorked,
    te.[Description] AS WorkDescription,
    te.ApprovalStatus,
    te.IsBillable,
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    e.Email AS EmployeeEmail,
    e.JobTitle,
    e.HourlyRate,
    te.HoursWorked * ISNULL(e.HourlyRate, 0) AS LaborCost,
    p.ProjectID,
    p.ProjectCode,
    p.ProjectName,
    t.TaskID,
    t.TaskName,
    t.[Status] AS TaskStatus
FROM dbo.TimeEntry te
INNER JOIN dbo.Employee e
    ON te.EmployeeID = e.EmployeeID
INNER JOIN dbo.Project p
    ON te.ProjectID = p.ProjectID
INNER JOIN dbo.Task t
    ON te.TaskID = t.TaskID;
GO


IF OBJECT_ID('dbo.vw_MilestoneTracking', 'V') IS NOT NULL 
    DROP VIEW dbo.vw_MilestoneTracking;
GO

CREATE VIEW dbo.vw_MilestoneTracking
AS
SELECT
    m.MilestoneID,
    m.MilestoneName,
    m.[Description] AS MilestoneDescription,
    m.PlannedDate,
    m.ActualDate,
    m.[Status],
    m.IsPhaseGate,
    CASE 
        WHEN m.ActualDate IS NOT NULL THEN 
            DATEDIFF(DAY, m.PlannedDate, m.ActualDate)
        WHEN GETDATE() > m.PlannedDate AND m.ActualDate IS NULL THEN
            DATEDIFF(DAY, m.PlannedDate, GETDATE())
        ELSE 0
    END AS DaysVariance,
    CASE 
        WHEN m.ActualDate IS NOT NULL AND m.ActualDate <= m.PlannedDate THEN 'On Time'
        WHEN m.ActualDate IS NOT NULL AND m.ActualDate > m.PlannedDate THEN 'Late'
        WHEN GETDATE() > m.PlannedDate AND m.ActualDate IS NULL THEN 'Overdue'
        ELSE 'On Track'
    END AS MilestoneHealth,
    p.ProjectID,
    p.ProjectCode,
    p.ProjectName,
    p.[Status] AS ProjectStatus
FROM dbo.Milestone m
INNER JOIN dbo.Project p
    ON m.ProjectID = p.ProjectID;
GO


PRINT '';
PRINT '========================================================================';
PRINT 'VIEWS CREATED SUCCESSFULLY!';
PRINT '========================================================================';
PRINT '';
PRINT 'Testing all views with sample queries...';
PRINT '';


PRINT 'VIEW 1: Employee Details';
SELECT TOP 3 EmployeeID, FirstName, LastName, DepartmentName, JobTitle 
FROM dbo.vw_EmployeeDetails;
PRINT '';


PRINT 'VIEW 2: Project Overview';
SELECT TOP 3 ProjectCode, ProjectName, ProjectManager, BudgetUtilizationPercent 
FROM dbo.vw_ProjectOverview;
PRINT '';


PRINT 'VIEW 3: Resource Assignments';
SELECT TOP 3 ProjectName, ResourceType, EmployeeName, EquipmentName, AllocationPercent 
FROM dbo.vw_ResourceAssignments;
PRINT '';


PRINT 'VIEW 4: Task Tracking';
SELECT TOP 3 ProjectName, TaskName, [Status], PercentComplete, AssignedEmployee 
FROM dbo.vw_TaskTracking;
PRINT '';


PRINT 'VIEW 5: Budget Summary';
SELECT TOP 3 ProjectName, CategoryName, PlannedAmount, ActualAmount, BudgetStatus 
FROM dbo.vw_ProjectBudgetSummary;
PRINT '';


PRINT 'VIEW 6: Risk & Issue Overview';
SELECT TOP 3 ItemType, ProjectName, Category, [Description], ItemStatus 
FROM dbo.vw_RiskIssueOverview;
PRINT '';


PRINT 'VIEW 7: Time Entry Summary';
SELECT TOP 3 WorkDate, EmployeeName, ProjectName, TaskName, HoursWorked, LaborCost 
FROM dbo.vw_TimeEntrySummary;
PRINT '';


PRINT 'VIEW 8: Milestone Tracking';
SELECT TOP 3 ProjectName, MilestoneName, PlannedDate, MilestoneHealth 
FROM dbo.vw_MilestoneTracking;
PRINT '';

PRINT '========================================================================';
PRINT 'ALL VIEWS TESTED SUCCESSFULLY!';
PRINT '========================================================================';
GO