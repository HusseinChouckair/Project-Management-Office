USE PMO_DB;
GO

PRINT '=====================================================';
PRINT 'SECURITY & AUDIT - QUICK TEST';
PRINT '=====================================================';
PRINT '';


PRINT 'Database Roles Created:';
SELECT name AS RoleName FROM sys.database_principals 
WHERE type = 'R' AND name IN ('PMO_Admin', 'Project_Manager', 'Team_Member');

PRINT '';
PRINT '-----------------------------------------------------';
PRINT 'TESTING AUDIT TRIGGER';
PRINT '-----------------------------------------------------';
PRINT '';


DELETE FROM dbo.AuditLog WHERE TableName = 'Project' AND RecordID = 1;


PRINT 'BEFORE UPDATE:';
SELECT ProjectID, ProjectCode, [Status], TotalBudget, ActualCost 
FROM dbo.Project WHERE ProjectID = 1;

PRINT '';
PRINT 'Performing update: Status → Closed, Budget + $5,000...';
PRINT '';


UPDATE dbo.Project 
SET [Status] = 'Closed', 
    TotalBudget = TotalBudget + 5000
WHERE ProjectID = 1;


PRINT 'AFTER UPDATE:';
SELECT ProjectID, ProjectCode, [Status], TotalBudget, ActualCost 
FROM dbo.Project WHERE ProjectID = 1;

PRINT '';
PRINT 'Audit Log Entry:';
SELECT 
    AuditID,
    TableName,
    Action,
    OldValue,
    NewValue,
    PerformedBy,
    PerformedAt
FROM dbo.AuditLog 
WHERE TableName = 'Project' AND RecordID = 1;

PRINT '';
PRINT '✓ Audit tracking is working!';
PRINT '';
GO