USE PMO_DB;
GO




DELETE FROM dbo.Budget;
DELETE FROM dbo.Issue;
DELETE FROM dbo.Risk;
DELETE FROM dbo.TimeEntry;
DELETE FROM dbo.Milestone;
DELETE FROM dbo.Task;
DELETE FROM dbo.ResourceAssignment;
DELETE FROM dbo.Project;


UPDATE dbo.Department SET ManagerEmpID = NULL;


DELETE FROM dbo.Employee;
DELETE FROM dbo.Equipment;
DELETE FROM dbo.Resource;
DELETE FROM dbo.Department;
DELETE FROM dbo.CostCategory;
DELETE FROM dbo.RiskCategory;

PRINT 'All tables cleared successfully!';
GO


DBCC CHECKIDENT ('dbo.Department', RESEED, 0);
DBCC CHECKIDENT ('dbo.Resource', RESEED, 0);
DBCC CHECKIDENT ('dbo.Employee', RESEED, 0);
DBCC CHECKIDENT ('dbo.Equipment', RESEED, 0);
DBCC CHECKIDENT ('dbo.CostCategory', RESEED, 0);
DBCC CHECKIDENT ('dbo.RiskCategory', RESEED, 0);
DBCC CHECKIDENT ('dbo.Project', RESEED, 0);
DBCC CHECKIDENT ('dbo.ResourceAssignment', RESEED, 0);
DBCC CHECKIDENT ('dbo.Task', RESEED, 0);
DBCC CHECKIDENT ('dbo.Milestone', RESEED, 0);
DBCC CHECKIDENT ('dbo.TimeEntry', RESEED, 0);
DBCC CHECKIDENT ('dbo.Risk', RESEED, 0);
DBCC CHECKIDENT ('dbo.Issue', RESEED, 0);
DBCC CHECKIDENT ('dbo.Budget', RESEED, 0);

PRINT 'All identity seeds reset successfully!';
GO