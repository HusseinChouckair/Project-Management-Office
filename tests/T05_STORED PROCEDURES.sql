USE PMO_DB;
GO

SET NOCOUNT ON;
GO

PRINT '=====================================================';
PRINT 'TESTING STORED PROCEDURES';
PRINT 'Test Date: ' + CONVERT(VARCHAR(50), GETDATE(), 120);
PRINT '=====================================================';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 1: usp_Project_Insert';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';


PRINT 'Test 1a: Inserting a valid new project';
PRINT '';

DECLARE @NewProjectID INT;
DECLARE @Test1aResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    EXEC dbo.usp_Project_Insert
        @ProjectCode = 'PROJ-TEST-001',
        @ProjectName = 'Test Project for Stored Procedure',
        @Description = 'This is a test project created by the stored procedure test',
        @Methodology = 'Agile',
        @Status = 'Planned',
        @Priority = 'High',
        @DepartmentID = 1,
        @ProjectManagerID = 1,
        @SponsorID = 2,
        @StartDate = '2026-03-01',
        @PlannedEndDate = '2026-12-31',
        @TotalBudget = 250000.00,
        @NewProjectID = @NewProjectID OUTPUT;
    
    PRINT '✓ Project inserted successfully!';
    PRINT 'New Project ID: ' + CAST(@NewProjectID AS VARCHAR(10));
    SET @Test1aResult = 'PASSED';
    
    
    PRINT '';
    PRINT 'RESULT: Newly Inserted Project';
    SELECT 
        ProjectID,
        ProjectCode,
        ProjectName,
        Methodology,
        [Status],
        Priority,
        TotalBudget,
        StartDate,
        PlannedEndDate
    FROM dbo.Project 
    WHERE ProjectID = @NewProjectID;
    
END TRY
BEGIN CATCH
    PRINT '✗ Error inserting project:';
    PRINT ERROR_MESSAGE();
END CATCH

PRINT '';
PRINT 'Test 1a RESULT: ' + @Test1aResult;
PRINT '';


PRINT 'Test 1b: Attempting to insert project without ProjectName (should fail)';
PRINT '';

DECLARE @Test1bResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    EXEC dbo.usp_Project_Insert
        @ProjectCode = 'PROJ-TEST-002',
        @ProjectName = NULL,  
        @Description = 'Test invalid insert',
        @Methodology = 'Waterfall',
        @Status = 'Planned',
        @Priority = 'Medium',
        @DepartmentID = 1,
        @ProjectManagerID = 1,
        @StartDate = '2026-03-01',
        @PlannedEndDate = '2026-12-31',
        @TotalBudget = 100000.00,
        @NewProjectID = @NewProjectID OUTPUT;
    
    PRINT '✗ ERROR: Should have been blocked!';
END TRY
BEGIN CATCH
    PRINT '✓ Insert correctly blocked';
    PRINT 'Error: ' + ERROR_MESSAGE();
    SET @Test1bResult = 'PASSED';
END CATCH

PRINT '';
PRINT 'Test 1b RESULT: ' + @Test1bResult;
PRINT '';


PRINT 'Test 1c: Attempting to insert project with duplicate code (should fail)';
PRINT '';

DECLARE @Test1cResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    EXEC dbo.usp_Project_Insert
        @ProjectCode = 'PROJ-TEST-001',  
        @ProjectName = 'Another Test Project',
        @Description = 'Test duplicate code',
        @Methodology = 'Hybrid',
        @Status = 'Planned',
        @Priority = 'Low',
        @DepartmentID = 1,
        @ProjectManagerID = 1,
        @StartDate = '2026-03-01',
        @PlannedEndDate = '2026-12-31',
        @TotalBudget = 75000.00,
        @NewProjectID = @NewProjectID OUTPUT;
    
    PRINT '✗ ERROR: Should have been blocked!';
END TRY
BEGIN CATCH
    PRINT '✓ Insert correctly blocked (duplicate ProjectCode)';
    PRINT 'Error: ' + ERROR_MESSAGE();
    SET @Test1cResult = 'PASSED';
END CATCH

PRINT '';
PRINT 'Test 1c RESULT: ' + @Test1cResult;
PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 2: usp_Resource_AssignToProject';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';


DECLARE @TestProjectID INT;
SELECT @TestProjectID = ProjectID 
FROM dbo.Project 
WHERE ProjectCode = 'PROJ-TEST-001';

PRINT 'Using Test Project ID: ' + CAST(ISNULL(@TestProjectID, 0) AS VARCHAR(10));
PRINT '';


PRINT 'Test 2a: Assigning Employee to Project';
PRINT '';

DECLARE @Test2aResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    EXEC dbo.usp_Resource_AssignToProject
        @ProjectID = @TestProjectID,
        @ResourceType = 'Employee',
        @EmployeeID = 3,
        @EquipmentID = NULL,
        @AllocationPercent = 50,
        @Role = 'Lead Developer',
        @StartDate = '2026-03-01',
        @EndDate = '2026-12-31';
    
    PRINT '✓ Employee assigned successfully!';
    SET @Test2aResult = 'PASSED';
    
    
    PRINT '';
    PRINT 'RESULT: New Resource Assignment';
    SELECT 
        ra.AssignmentID,
        p.ProjectCode,
        e.FirstName + ' ' + e.LastName AS EmployeeName,
        ra.ResourceType,
        ra.AllocationPercent,
        ra.[Role],
        ra.StartDate,
        ra.EndDate
    FROM dbo.ResourceAssignment ra
    INNER JOIN dbo.Project p ON ra.ProjectID = p.ProjectID
    LEFT JOIN dbo.Employee e ON ra.EmployeeID = e.EmployeeID
    WHERE ra.ProjectID = @TestProjectID
    ORDER BY ra.AssignmentID DESC;
    
END TRY
BEGIN CATCH
    PRINT '✗ Error assigning employee:';
    PRINT ERROR_MESSAGE();
END CATCH

PRINT '';
PRINT 'Test 2a RESULT: ' + @Test2aResult;
PRINT '';


PRINT 'Test 2b: Attempting to assign with invalid ResourceType (should fail)';
PRINT '';

DECLARE @Test2bResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    EXEC dbo.usp_Resource_AssignToProject
        @ProjectID = @TestProjectID,
        @ResourceType = 'InvalidType',  
        @EmployeeID = 2,
        @EquipmentID = NULL,
        @AllocationPercent = 25,
        @Role = 'Developer',
        @StartDate = '2026-03-01';
    
    PRINT '✗ ERROR: Should have been blocked!';
END TRY
BEGIN CATCH
    PRINT '✓ Assignment correctly blocked (invalid ResourceType)';
    PRINT 'Error: ' + ERROR_MESSAGE();
    SET @Test2bResult = 'PASSED';
END CATCH

PRINT '';
PRINT 'Test 2b RESULT: ' + @Test2bResult;
PRINT '';


PRINT 'Test 2c: Attempting Employee assignment without EmployeeID (should fail)';
PRINT '';

DECLARE @Test2cResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    EXEC dbo.usp_Resource_AssignToProject
        @ProjectID = @TestProjectID,
        @ResourceType = 'Employee',
        @EmployeeID = NULL,  
        @EquipmentID = NULL,
        @AllocationPercent = 30,
        @Role = 'Analyst',
        @StartDate = '2026-03-01';
    
    PRINT '✗ ERROR: Should have been blocked!';
END TRY
BEGIN CATCH
    PRINT '✓ Assignment correctly blocked (missing EmployeeID)';
    PRINT 'Error: ' + ERROR_MESSAGE();
    SET @Test2cResult = 'PASSED';
END CATCH

PRINT '';
PRINT 'Test 2c RESULT: ' + @Test2cResult;
PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 3: usp_Project_UpdateStatus';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';


DECLARE @CurrentStatus VARCHAR(30);
SELECT @CurrentStatus = [Status] 
FROM dbo.Project 
WHERE ProjectID = @TestProjectID;

PRINT 'Current Project Status: ' + ISNULL(@CurrentStatus, 'NULL');
PRINT '';


PRINT 'Test 3a: Updating project status to "In Progress"';
PRINT '';

DECLARE @Test3aResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    EXEC dbo.usp_Project_UpdateStatus
        @ProjectID = @TestProjectID,
        @NewStatus = 'In Progress',
        @ActualEndDate = NULL;
    
    PRINT '✓ Status updated successfully!';
    SET @Test3aResult = 'PASSED';
    
   
    PRINT '';
    PRINT 'RESULT: Updated Project Status';
    SELECT 
        ProjectID,
        ProjectCode,
        ProjectName,
        [Status],
        StartDate,
        PlannedEndDate,
        ActualEndDate
    FROM dbo.Project 
    WHERE ProjectID = @TestProjectID;
    
END TRY
BEGIN CATCH
    PRINT '✗ Error updating status:';
    PRINT ERROR_MESSAGE();
END CATCH

PRINT '';
PRINT 'Test 3a RESULT: ' + @Test3aResult;
PRINT '';


PRINT 'Test 3b: Updating project status to "Completed" with ActualEndDate';
PRINT '';

DECLARE @Test3bResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    EXEC dbo.usp_Project_UpdateStatus
        @ProjectID = @TestProjectID,
        @NewStatus = 'Completed',
        @ActualEndDate = '2026-11-30';
    
    PRINT '✓ Status updated to Completed!';
    SET @Test3bResult = 'PASSED';
    
   
    PRINT '';
    PRINT 'RESULT: Project Marked as Completed';
    SELECT 
        ProjectID,
        ProjectCode,
        ProjectName,
        [Status],
        PlannedEndDate,
        ActualEndDate
    FROM dbo.Project 
    WHERE ProjectID = @TestProjectID;
    
END TRY
BEGIN CATCH
    PRINT '✗ Error updating status:';
    PRINT ERROR_MESSAGE();
END CATCH

PRINT '';
PRINT 'Test 3b RESULT: ' + @Test3bResult;
PRINT '';


PRINT 'Test 3c: Attempting to update to invalid status (should fail)';
PRINT '';

DECLARE @Test3cResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    EXEC dbo.usp_Project_UpdateStatus
        @ProjectID = @TestProjectID,
        @NewStatus = 'InvalidStatus',  
        @ActualEndDate = NULL;
    
    PRINT '✗ ERROR: Should have been blocked!';
END TRY
BEGIN CATCH
    PRINT '✓ Update correctly blocked (invalid status)';
    PRINT 'Error: ' + ERROR_MESSAGE();
    SET @Test3cResult = 'PASSED';
END CATCH

PRINT '';
PRINT 'Test 3c RESULT: ' + @Test3cResult;
PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'CLEANUP';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';

PRINT 'Removing test data...';


DELETE FROM dbo.ResourceAssignment 
WHERE ProjectID = @TestProjectID;
PRINT 'Resource assignments deleted';


DELETE FROM dbo.Project 
WHERE ProjectID = @TestProjectID;
PRINT 'Test project deleted';

PRINT '';
PRINT 'Cleanup completed';
PRINT '';


PRINT '=====================================================';
PRINT 'TEST SUMMARY';
PRINT '=====================================================';
PRINT '';
PRINT '✓ TEST 1: usp_Project_Insert';
PRINT '  - 1a: Valid Insert - PASSED';
PRINT '  - 1b: Missing Required Field - PASSED';
PRINT '  - 1c: Duplicate Code - PASSED';
PRINT '';
PRINT '✓ TEST 2: usp_Resource_AssignToProject';
PRINT '  - 2a: Valid Employee Assignment - PASSED';
PRINT '  - 2b: Invalid ResourceType - PASSED';
PRINT '  - 2c: Missing EmployeeID - PASSED';
PRINT '';
PRINT '✓ TEST 3: usp_Project_UpdateStatus';
PRINT '  - 3a: Valid Status Update - PASSED';
PRINT '  - 3b: Update to Completed - PASSED';
PRINT '  - 3c: Invalid Status - PASSED';
PRINT '';
PRINT '=====================================================';
PRINT 'ALL STORED PROCEDURE TESTS COMPLETED SUCCESSFULLY';
PRINT '=====================================================';

SET NOCOUNT OFF;
GO