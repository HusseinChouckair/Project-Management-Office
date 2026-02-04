USE PMO_DB;
GO

PRINT '====================================================';
PRINT 'DELETING ALL TRIGGERS';
PRINT '====================================================';


IF OBJECT_ID('dbo.tr_ProjectStatus_Update', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER dbo.tr_ProjectStatus_Update;
    PRINT 'Dropped trigger: tr_ProjectStatus_Update';
END


IF OBJECT_ID('dbo.tr_ResourceAssignment_Insert', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER dbo.tr_ResourceAssignment_Insert;
    PRINT 'Dropped trigger: tr_ResourceAssignment_Insert';
END


IF OBJECT_ID('dbo.tr_Budget_Update', 'TR') IS NOT NULL
BEGIN
    DROP TRIGGER dbo.tr_Budget_Update;
    PRINT 'Dropped trigger: tr_Budget_Update';
END

PRINT '====================================================';
PRINT 'ALL TRIGGERS DELETED SUCCESSFULLY';
PRINT '====================================================';
GO
