USE PMO_DB;
GO


IF OBJECT_ID('dbo.tr_Budget_UpdateCost', 'TR') IS NOT NULL DROP TRIGGER dbo.tr_Budget_UpdateCost;
IF OBJECT_ID('dbo.tr_TimeEntry_Approved', 'TR') IS NOT NULL DROP TRIGGER dbo.tr_TimeEntry_Approved;
IF OBJECT_ID('dbo.tr_Project_Audit', 'TR') IS NOT NULL DROP TRIGGER dbo.tr_Project_Audit;
GO


IF OBJECT_ID('dbo.vw_ProjectBudgetSignals', 'V') IS NOT NULL DROP VIEW dbo.vw_ProjectBudgetSignals;
IF OBJECT_ID('dbo.vw_EmployeeAllocation', 'V') IS NOT NULL DROP VIEW dbo.vw_EmployeeAllocation;
IF OBJECT_ID('dbo.vw_CriticalRisks', 'V') IS NOT NULL DROP VIEW dbo.vw_CriticalRisks;
IF OBJECT_ID('dbo.vw_AI_ProjectInput', 'V') IS NOT NULL DROP VIEW dbo.vw_AI_ProjectInput;
GO


DECLARE @procName NVARCHAR(128)
DECLARE procs CURSOR FOR
SELECT name FROM sys.objects WHERE type='P' AND name LIKE 'sp_%'
OPEN procs
FETCH NEXT FROM procs INTO @procName
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('DROP PROCEDURE ' + @procName)
    FETCH NEXT FROM procs INTO @procName
END
CLOSE procs
DEALLOCATE procs
GO


DECLARE @sql NVARCHAR(MAX) = ''

SELECT @sql = @sql + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) 
            + '.' + QUOTENAME(OBJECT_NAME(fk.parent_object_id)) 
            + ' DROP CONSTRAINT ' + QUOTENAME(fk.name) + ';' + CHAR(13)
FROM sys.foreign_keys fk

EXEC(@sql)
GO


DECLARE @tbl NVARCHAR(128)
DECLARE tbls CURSOR FOR
SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE='BASE TABLE'
ORDER BY TABLE_NAME DESC  
OPEN tbls
FETCH NEXT FROM tbls INTO @tbl
WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC('DROP TABLE [' + @tbl + ']')
    FETCH NEXT FROM tbls INTO @tbl
END
CLOSE tbls
DEALLOCATE tbls
GO


IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'PMO_Admin') DROP ROLE PMO_Admin;
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Project_Manager') DROP ROLE Project_Manager;
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Team_Member') DROP ROLE Team_Member;
IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'AI_Service') DROP ROLE AI_Service;
GO
