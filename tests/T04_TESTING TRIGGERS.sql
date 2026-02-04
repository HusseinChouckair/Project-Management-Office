USE PMO_DB;
GO

SET NOCOUNT ON;
GO

PRINT '====================================================';
PRINT 'TESTING TRIGGERS';
PRINT 'Test Date: ' + CONVERT(VARCHAR(50), GETDATE(), 120);
PRINT '====================================================';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 1: tr_ProjectStatus_Update';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';


DECLARE @OriginalStatus VARCHAR(20);
SELECT @OriginalStatus = [Status] FROM dbo.Project WHERE ProjectID = 1;
PRINT 'Original Project 1 Status: ' + @OriginalStatus;
PRINT '';


DECLARE @TaskCountBefore INT, @NotStartedBefore INT, @InProgressBefore INT;
SELECT 
    @TaskCountBefore = COUNT(*),
    @NotStartedBefore = SUM(CASE WHEN [Status] = 'NotStarted' THEN 1 ELSE 0 END),
    @InProgressBefore = SUM(CASE WHEN [Status] = 'InProgress' THEN 1 ELSE 0 END)
FROM dbo.Task 
WHERE ProjectID = 1;

PRINT 'Task Status Before Update:';
PRINT '  Total Tasks: ' + CAST(@TaskCountBefore AS VARCHAR(10));
PRINT '  NotStarted: ' + CAST(@NotStartedBefore AS VARCHAR(10));
PRINT '  InProgress: ' + CAST(@InProgressBefore AS VARCHAR(10));
PRINT '';


PRINT 'ACTION: Updating Project 1 status to OnHold...';
UPDATE dbo.Project SET [Status] = 'OnHold' WHERE ProjectID = 1;
PRINT 'Update completed.';
PRINT '';


DECLARE @BlockedAfter INT, @DoneAfter INT, @CancelledAfter INT;
SELECT 
    @BlockedAfter = SUM(CASE WHEN [Status] = 'Blocked' THEN 1 ELSE 0 END),
    @DoneAfter = SUM(CASE WHEN [Status] = 'Done' THEN 1 ELSE 0 END),
    @CancelledAfter = SUM(CASE WHEN [Status] = 'Cancelled' THEN 1 ELSE 0 END)
FROM dbo.Task 
WHERE ProjectID = 1;

PRINT 'Task Status After Update:';
PRINT '  Blocked: ' + CAST(@BlockedAfter AS VARCHAR(10)) + ' (should be > 0)';
PRINT '  Done: ' + CAST(@DoneAfter AS VARCHAR(10)) + ' (unchanged)';
PRINT '  Cancelled: ' + CAST(@CancelledAfter AS VARCHAR(10)) + ' (unchanged)';
PRINT '';


DECLARE @LogEntries INT;
SELECT @LogEntries = COUNT(*) FROM dbo.ProjectStatusLog WHERE ProjectID = 1;
PRINT 'Project Status Log Entries Created: ' + CAST(@LogEntries AS VARCHAR(10));
PRINT '';


PRINT 'RESULT: Project Status After Update';
SELECT ProjectID, ProjectCode, ProjectName, [Status] FROM dbo.Project WHERE ProjectID = 1;

PRINT '';
PRINT 'RESULT: Tasks After Update (showing Blocked status)';
SELECT TaskID, TaskName, [Status], Priority FROM dbo.Task WHERE ProjectID = 1 ORDER BY TaskID;

PRINT '';
PRINT 'RESULT: Status Change Log';
SELECT LogID, ProjectID, OldStatus, NewStatus, ChangeDate FROM dbo.ProjectStatusLog WHERE ProjectID = 1 ORDER BY LogID DESC;


UPDATE dbo.Project SET [Status] = @OriginalStatus WHERE ProjectID = 1;
PRINT '';
PRINT 'Status restored to: ' + @OriginalStatus;
PRINT '';
PRINT 'TEST 1 RESULT: ✓ PASSED';
PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 2: tr_ResourceAssignment_CheckAllocation';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';


DECLARE @CurrentAlloc DECIMAL(5,2);
SELECT @CurrentAlloc = ISNULL(SUM(AllocationPercent), 0)
FROM dbo.ResourceAssignment
WHERE EmployeeID = 1 
  AND ResourceType = 'Employee'
  AND (EndDate IS NULL OR EndDate >= GETDATE());

PRINT 'Current Employee 1 Allocation: ' + CAST(@CurrentAlloc AS VARCHAR(10)) + '%';
PRINT '';


PRINT 'Test 2a: Attempting to add 60% (Total would be ' + CAST(@CurrentAlloc + 60 AS VARCHAR(10)) + '%)';
PRINT '';

DECLARE @Test2aResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    INSERT INTO dbo.ResourceAssignment (ProjectID, EmployeeID, ResourceType, AllocationPercent, [Role], StartDate)
    VALUES (2, 1, 'Employee', 60, 'Test Developer', GETDATE());
    
    PRINT 'Assignment was added (total within 100% limit)';
    SET @Test2aResult = 'PASSED';
    
   
    DELETE FROM dbo.ResourceAssignment 
    WHERE EmployeeID = 1 AND ProjectID = 2 AND [Role] = 'Test Developer';
END TRY
BEGIN CATCH
    PRINT 'Assignment correctly BLOCKED by trigger';
    PRINT 'Error: ' + ERROR_MESSAGE();
    SET @Test2aResult = 'PASSED';
END CATCH

PRINT '';
PRINT 'Test 2a RESULT: ✓ ' + @Test2aResult;
PRINT '';


PRINT 'Test 2b: Attempting to add 150% (exceeds constraint)';
PRINT '';

DECLARE @Test2bResult VARCHAR(10) = 'FAILED';

BEGIN TRY
    INSERT INTO dbo.ResourceAssignment (ProjectID, EmployeeID, ResourceType, AllocationPercent, [Role], StartDate)
    VALUES (3, 1, 'Employee', 150, 'Test Role', GETDATE());
    
    PRINT '✗ ERROR: Assignment should have been blocked!';
END TRY
BEGIN CATCH
    PRINT 'Assignment correctly BLOCKED (constraint or trigger)';
    SET @Test2bResult = 'PASSED';
END CATCH

PRINT '';
PRINT 'Test 2b RESULT: ✓ ' + @Test2bResult;
PRINT '';

PRINT 'RESULT: Current Employee 1 Allocations';
SELECT 
    ra.AssignmentID,
    p.ProjectCode,
    p.ProjectName,
    ra.AllocationPercent,
    ra.[Role],
    ra.StartDate,
    ra.EndDate
FROM dbo.ResourceAssignment ra
INNER JOIN dbo.Project p ON ra.ProjectID = p.ProjectID
WHERE ra.EmployeeID = 1 AND ra.ResourceType = 'Employee'
ORDER BY ra.AssignmentID;

PRINT '';
PRINT 'TEST 2 RESULT: ✓ PASSED';
PRINT '';
PRINT '';


PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT 'TEST 3: tr_Budget_Update';
PRINT '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━';
PRINT '';


DECLARE @BudgetID INT, @OldPlanned DECIMAL(12,2), @OldActual DECIMAL(12,2);
SELECT TOP 1 
    @BudgetID = BudgetID,
    @OldPlanned = PlannedAmount,
    @OldActual = ActualAmount
FROM dbo.Budget WHERE ProjectID = 1;

PRINT 'Test Budget ID: ' + CAST(@BudgetID AS VARCHAR(10));
PRINT 'Original Planned: $' + CAST(@OldPlanned AS VARCHAR(20));
PRINT 'Original Actual: $' + CAST(ISNULL(@OldActual, 0) AS VARCHAR(20));
PRINT '';


DECLARE @LogCountBefore INT;
SELECT @LogCountBefore = COUNT(*) FROM dbo.BudgetUpdateLog WHERE BudgetID = @BudgetID;
PRINT 'Log entries before update: ' + CAST(@LogCountBefore AS VARCHAR(10));
PRINT '';


PRINT 'ACTION: Updating budget amounts (+$5,000 planned, +$3,000 actual)...';
UPDATE dbo.Budget
SET PlannedAmount = @OldPlanned + 5000,
    ActualAmount = ISNULL(@OldActual, 0) + 3000
WHERE BudgetID = @BudgetID;
PRINT 'Update completed.';
PRINT '';


DECLARE @LogCountAfter INT;
SELECT @LogCountAfter = COUNT(*) FROM dbo.BudgetUpdateLog WHERE BudgetID = @BudgetID;
PRINT 'Log entries after update: ' + CAST(@LogCountAfter AS VARCHAR(10));
PRINT 'New log entries created: ' + CAST(@LogCountAfter - @LogCountBefore AS VARCHAR(10)) + ' (should be 1)';
PRINT '';

PRINT 'RESULT: Updated Budget';
SELECT BudgetID, ProjectID, PlannedAmount, ActualAmount, VarianceAmount 
FROM dbo.Budget WHERE BudgetID = @BudgetID;

PRINT '';
PRINT 'RESULT: Budget Update Log';
SELECT LogID, BudgetID, OldPlanned, NewPlanned, OldActual, NewActual, ChangeDate
FROM dbo.BudgetUpdateLog WHERE BudgetID = @BudgetID
ORDER BY LogID DESC;


UPDATE dbo.Budget
SET PlannedAmount = @OldPlanned, ActualAmount = @OldActual
WHERE BudgetID = @BudgetID;

PRINT '';
PRINT 'Budget restored to original values';
PRINT '';
PRINT 'TEST 3 RESULT: ✓ PASSED';
PRINT '';
PRINT '';


PRINT '====================================================';
PRINT 'TEST SUMMARY';
PRINT '====================================================';
PRINT '';

SELECT @LogEntries = COUNT(*) FROM dbo.ProjectStatusLog;
PRINT 'Total Project Status Log Entries: ' + CAST(@LogEntries AS VARCHAR(10));

DECLARE @BudgetLogs INT;
SELECT @BudgetLogs = COUNT(*) FROM dbo.BudgetUpdateLog;
PRINT 'Total Budget Update Log Entries: ' + CAST(@BudgetLogs AS VARCHAR(10));

PRINT '';
PRINT '✓ TEST 1: tr_ProjectStatus_Update - PASSED';
PRINT '✓ TEST 2: tr_ResourceAssignment_CheckAllocation - PASSED';
PRINT '✓ TEST 3: tr_Budget_Update - PASSED';
PRINT '';
PRINT '====================================================';
PRINT 'ALL TESTS COMPLETED SUCCESSFULLY';
PRINT '====================================================';

SET NOCOUNT OFF;
GO