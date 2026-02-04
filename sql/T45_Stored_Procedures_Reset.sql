USE PMO_DB;
GO


IF OBJECT_ID('dbo.usp_Project_Insert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Project_Insert;
GO

IF OBJECT_ID('dbo.usp_Project_UpdateStatus', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Project_UpdateStatus;
GO

IF OBJECT_ID('dbo.usp_ResourceAssignment_Insert', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_ResourceAssignment_Insert;
GO

IF OBJECT_ID('dbo.usp_Resource_AssignToProject', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_Resource_AssignToProject;
GO

PRINT 'All 3 stored procedures have been deleted. You can now recreate them.';


