USE PMO_DB;
GO




IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Employee_DepartmentID' AND object_id = OBJECT_ID('dbo.Employee'))
BEGIN
    CREATE INDEX IX_Employee_DepartmentID ON dbo.Employee(DepartmentID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Employee_ResourceID' AND object_id = OBJECT_ID('dbo.Employee'))
BEGIN
    CREATE INDEX IX_Employee_ResourceID ON dbo.Employee(ResourceID);
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Department_ManagerEmpID' AND object_id = OBJECT_ID('dbo.Department'))
BEGIN
    CREATE INDEX IX_Department_ManagerEmpID ON dbo.Department(ManagerEmpID);
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Project_DepartmentID' AND object_id = OBJECT_ID('dbo.Project'))
BEGIN
    CREATE INDEX IX_Project_DepartmentID ON dbo.Project(DepartmentID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Project_ProjectManagerID' AND object_id = OBJECT_ID('dbo.Project'))
BEGIN
    CREATE INDEX IX_Project_ProjectManagerID ON dbo.Project(ProjectManagerID);
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ResourceAssignment_ProjectID' AND object_id = OBJECT_ID('dbo.ResourceAssignment'))
BEGIN
    CREATE INDEX IX_ResourceAssignment_ProjectID ON dbo.ResourceAssignment(ProjectID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ResourceAssignment_EmployeeID' AND object_id = OBJECT_ID('dbo.ResourceAssignment'))
BEGIN
    CREATE INDEX IX_ResourceAssignment_EmployeeID ON dbo.ResourceAssignment(EmployeeID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_ResourceAssignment_EquipmentID' AND object_id = OBJECT_ID('dbo.ResourceAssignment'))
BEGIN
    CREATE INDEX IX_ResourceAssignment_EquipmentID ON dbo.ResourceAssignment(EquipmentID);
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Task_ProjectID' AND object_id = OBJECT_ID('dbo.Task'))
BEGIN
    CREATE INDEX IX_Task_ProjectID ON dbo.Task(ProjectID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Task_AssignmentID' AND object_id = OBJECT_ID('dbo.Task'))
BEGIN
    CREATE INDEX IX_Task_AssignmentID ON dbo.Task(AssignmentID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Task_ParentTaskID' AND object_id = OBJECT_ID('dbo.Task'))
BEGIN
    CREATE INDEX IX_Task_ParentTaskID ON dbo.Task(ParentTaskID);
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TimeEntry_TaskID' AND object_id = OBJECT_ID('dbo.TimeEntry'))
BEGIN
    CREATE INDEX IX_TimeEntry_TaskID ON dbo.TimeEntry(TaskID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TimeEntry_EmployeeID' AND object_id = OBJECT_ID('dbo.TimeEntry'))
BEGIN
    CREATE INDEX IX_TimeEntry_EmployeeID ON dbo.TimeEntry(EmployeeID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TimeEntry_ProjectID' AND object_id = OBJECT_ID('dbo.TimeEntry'))
BEGIN
    CREATE INDEX IX_TimeEntry_ProjectID ON dbo.TimeEntry(ProjectID);
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Risk_ProjectID' AND object_id = OBJECT_ID('dbo.Risk'))
BEGIN
    CREATE INDEX IX_Risk_ProjectID ON dbo.Risk(ProjectID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Risk_OwnerEmployeeID' AND object_id = OBJECT_ID('dbo.Risk'))
BEGIN
    CREATE INDEX IX_Risk_OwnerEmployeeID ON dbo.Risk(OwnerEmployeeID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Risk_CategoryID' AND object_id = OBJECT_ID('dbo.Risk'))
BEGIN
    CREATE INDEX IX_Risk_CategoryID ON dbo.Risk(CategoryID);
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Issue_ProjectID' AND object_id = OBJECT_ID('dbo.Issue'))
BEGIN
    CREATE INDEX IX_Issue_ProjectID ON dbo.Issue(ProjectID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Issue_TaskID' AND object_id = OBJECT_ID('dbo.Issue'))
BEGIN
    CREATE INDEX IX_Issue_TaskID ON dbo.Issue(TaskID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Issue_ReportedByEmpID' AND object_id = OBJECT_ID('dbo.Issue'))
BEGIN
    CREATE INDEX IX_Issue_ReportedByEmpID ON dbo.Issue(ReportedByEmpID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Issue_AssignedToEmpID' AND object_id = OBJECT_ID('dbo.Issue'))
BEGIN
    CREATE INDEX IX_Issue_AssignedToEmpID ON dbo.Issue(AssignedToEmpID);
END


IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Budget_ProjectID' AND object_id = OBJECT_ID('dbo.Budget'))
BEGIN
    CREATE INDEX IX_Budget_ProjectID ON dbo.Budget(ProjectID);
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Budget_CostCategoryID' AND object_id = OBJECT_ID('dbo.Budget'))
BEGIN
    CREATE INDEX IX_Budget_CostCategoryID ON dbo.Budget(CostCategoryID);
END

GO
