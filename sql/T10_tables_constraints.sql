USE PMO_DB;
GO


IF OBJECT_ID('dbo.Budget','U') IS NOT NULL DROP TABLE dbo.Budget;
IF OBJECT_ID('dbo.Issue','U') IS NOT NULL DROP TABLE dbo.Issue;
IF OBJECT_ID('dbo.Risk','U') IS NOT NULL DROP TABLE dbo.Risk;
IF OBJECT_ID('dbo.TimeEntry','U') IS NOT NULL DROP TABLE dbo.TimeEntry;
IF OBJECT_ID('dbo.Milestone','U') IS NOT NULL DROP TABLE dbo.Milestone;
IF OBJECT_ID('dbo.Task','U') IS NOT NULL DROP TABLE dbo.Task;
IF OBJECT_ID('dbo.ResourceAssignment','U') IS NOT NULL DROP TABLE dbo.ResourceAssignment;
IF OBJECT_ID('dbo.Project','U') IS NOT NULL DROP TABLE dbo.Project;
IF OBJECT_ID('dbo.RiskCategory','U') IS NOT NULL DROP TABLE dbo.RiskCategory;
IF OBJECT_ID('dbo.CostCategory','U') IS NOT NULL DROP TABLE dbo.CostCategory;
IF OBJECT_ID('dbo.Equipment','U') IS NOT NULL DROP TABLE dbo.Equipment;
IF OBJECT_ID('dbo.Employee','U') IS NOT NULL DROP TABLE dbo.Employee;
IF OBJECT_ID('dbo.Resource','U') IS NOT NULL DROP TABLE dbo.Resource;
IF OBJECT_ID('dbo.Department','U') IS NOT NULL DROP TABLE dbo.Department;
GO



CREATE TABLE dbo.Department (
  DepartmentID INT IDENTITY(1,1) PRIMARY KEY,
  DepartmentName VARCHAR(120) NOT NULL,
  DepartmentCode VARCHAR(20) NOT NULL,
  ManagerEmpID INT NULL,
  Budget DECIMAL(12,2) NULL,
  IsActive BIT NOT NULL DEFAULT 1,
  CONSTRAINT UQ_Department_Code UNIQUE (DepartmentCode),
  CONSTRAINT UQ_Department_Name UNIQUE (DepartmentName)
);


CREATE TABLE dbo.Resource (
  ResourceID INT IDENTITY(1,1) PRIMARY KEY,
  ResourceType VARCHAR(20) NOT NULL CHECK (ResourceType IN ('Employee','Equipment')),
  IsActive BIT NOT NULL DEFAULT 1
);


CREATE TABLE dbo.Employee (
  EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
  DepartmentID INT NOT NULL,
  FirstName VARCHAR(60) NOT NULL,
  LastName VARCHAR(60) NOT NULL,
  Email VARCHAR(200) NOT NULL,
  Phone VARCHAR(30) NULL,
  JobTitle VARCHAR(80) NOT NULL,
  HourlyRate DECIMAL(12,2) NULL,
  HireDate DATE NULL,
  IsActive BIT NOT NULL DEFAULT 1,
  ResourceID INT UNIQUE,
  CONSTRAINT UQ_Employee_Email UNIQUE (Email)
);


CREATE TABLE dbo.Equipment (
  EquipmentID INT IDENTITY(1,1) PRIMARY KEY,
  EquipmentName VARCHAR(120) NOT NULL,
  [Type] VARCHAR(50) NOT NULL,
  SerialNumber VARCHAR(80) NULL,
  DailyCost DECIMAL(12,2) NULL,
  [Status] VARCHAR(30) NOT NULL,
  PurchaseDate DATE NULL,
  [Location] VARCHAR(120) NULL,
  IsActive BIT NOT NULL DEFAULT 1,
  ResourceID INT UNIQUE
);


CREATE TABLE dbo.CostCategory (
  CategoryID INT IDENTITY(1,1) PRIMARY KEY,
  CategoryName VARCHAR(120) NOT NULL,
  CategoryCode VARCHAR(30) NOT NULL,
  [Description] VARCHAR(300) NULL,
  IsActive BIT NOT NULL DEFAULT 1,
  CONSTRAINT UQ_CostCategory_Code UNIQUE (CategoryCode)
);


CREATE TABLE dbo.RiskCategory (
  CategoryID INT IDENTITY(1,1) PRIMARY KEY,
  CategoryName VARCHAR(120) NOT NULL,
  [Description] VARCHAR(300) NULL,
  IsActive BIT NOT NULL DEFAULT 1,
  CONSTRAINT UQ_RiskCategory_Name UNIQUE (CategoryName)
);


CREATE TABLE dbo.Project (
  ProjectID INT IDENTITY(1,1) PRIMARY KEY,
  DepartmentID INT NOT NULL,
  ProjectManagerID INT NOT NULL,
  SponsorID INT NULL,
  ProjectCode VARCHAR(30) NOT NULL,
  ProjectName VARCHAR(200) NOT NULL,
  [Description] VARCHAR(1000) NULL,
  Methodology VARCHAR(20) NOT NULL CHECK (Methodology IN ('Waterfall','Agile','Hybrid')),
  [Status] VARCHAR(20) NOT NULL CHECK ([Status] IN ('Planned','Active','OnHold','Closed','Cancelled')),
  Priority VARCHAR(20) NULL,
  StartDate DATE NOT NULL,
  PlannedEndDate DATE NULL,
  ActualEndDate DATE NULL,
  TotalBudget DECIMAL(12,2) NOT NULL CHECK (TotalBudget > 0),
  ActualCost DECIMAL(12,2) NULL,
  CreatedDate DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME(),
  AIMetadata NVARCHAR(MAX) NULL CHECK (ISJSON(AIMetadata) = 1),
  CONSTRAINT UQ_Project_Code UNIQUE (ProjectCode),
  CONSTRAINT UQ_Project_Name UNIQUE (ProjectName)
);


CREATE TABLE dbo.ResourceAssignment (
  AssignmentID INT IDENTITY(1,1) PRIMARY KEY,
  ProjectID INT NOT NULL,
  EmployeeID INT NULL,
  EquipmentID INT NULL,
  ResourceType VARCHAR(20) NOT NULL CHECK (ResourceType IN ('Employee','Equipment')),
  AllocationPercent DECIMAL(5,2) NULL CHECK (AllocationPercent BETWEEN 0 AND 100),
  [Role] VARCHAR(80) NULL,
  StartDate DATE NOT NULL,
  EndDate DATE NULL,
  AssignedDate DATE NOT NULL DEFAULT CONVERT(date,SYSUTCDATETIME()),
  CONSTRAINT CK_Assign_ExactlyOneResource CHECK
  (
    (EmployeeID IS NOT NULL AND EquipmentID IS NULL AND ResourceType='Employee') OR
    (EmployeeID IS NULL AND EquipmentID IS NOT NULL AND ResourceType='Equipment')
  )
);


CREATE TABLE dbo.Task (
  TaskID INT IDENTITY(1,1) PRIMARY KEY,
  ProjectID INT NOT NULL,
  AssignmentID INT NULL,
  ParentTaskID INT NULL,
  TaskName VARCHAR(200) NOT NULL,
  [Description] VARCHAR(1000) NULL,
  EstimatedHours DECIMAL(10,2) NULL,
  ActualHours DECIMAL(10,2) NULL,
  RemainingHours DECIMAL(10,2) NULL,
  PercentComplete DECIMAL(5,2) NULL CHECK (PercentComplete BETWEEN 0 AND 100),
  [Status] VARCHAR(20) NOT NULL CHECK ([Status] IN ('NotStarted','InProgress','Blocked','Done','Cancelled')),
  PlannedStartDate DATE NULL,
  PlannedEndDate DATE NULL,
  Priority VARCHAR(20) NULL
);


CREATE TABLE dbo.Milestone (
  MilestoneID INT IDENTITY(1,1) PRIMARY KEY,
  ProjectID INT NOT NULL,
  MilestoneName VARCHAR(200) NOT NULL,
  [Description] VARCHAR(500) NULL,
  PlannedDate DATE NOT NULL,
  ActualDate DATE NULL,
  [Status] VARCHAR(20) NOT NULL,
  IsPhaseGate BIT NOT NULL DEFAULT 0
);

CREATE TABLE dbo.TimeEntry (
  TimeEntryID INT IDENTITY(1,1) PRIMARY KEY,
  TaskID INT NOT NULL,
  EmployeeID INT NOT NULL,
  ProjectID INT NOT NULL,
  WorkDate DATE NOT NULL,
  HoursWorked DECIMAL(6,2) NOT NULL CHECK (HoursWorked > 0 AND HoursWorked <= 24),
  [Description] VARCHAR(500) NULL,
  ApprovalStatus VARCHAR(20) NOT NULL DEFAULT 'Submitted' CHECK (ApprovalStatus IN ('Submitted','Approved','Rejected')),
  IsBillable BIT NOT NULL DEFAULT 0
);


CREATE TABLE dbo.Risk (
  RiskID INT IDENTITY(1,1) PRIMARY KEY,
  ProjectID INT NOT NULL,
  OwnerEmployeeID INT NOT NULL,
  CategoryID INT NOT NULL,
  RiskDescription VARCHAR(1000) NOT NULL,
  Probability TINYINT NOT NULL CHECK (Probability BETWEEN 1 AND 5),
  Impact TINYINT NOT NULL CHECK (Impact BETWEEN 1 AND 5),
  RiskScore AS (Probability*Impact) PERSISTED,
  MitigationStrategy VARCHAR(1000) NULL,
  ContingencyPlan VARCHAR(1000) NULL,
  [Status] VARCHAR(20) NOT NULL CHECK ([Status] IN ('Open','Mitigating','Accepted','Closed')),
  IdentifiedDate DATE NOT NULL DEFAULT CONVERT(date,SYSUTCDATETIME())
);

CREATE TABLE dbo.Issue (
  IssueID INT IDENTITY(1,1) PRIMARY KEY,
  ProjectID INT NOT NULL,
  TaskID INT NULL,
  ReportedByEmpID INT NOT NULL,
  AssignedToEmpID INT NULL,
  IssueDescription VARCHAR(1000) NOT NULL,
  Severity VARCHAR(20) NOT NULL CHECK (Severity IN ('Low','Medium','High','Critical')),
  Priority VARCHAR(20) NULL,
  [Status] VARCHAR(20) NOT NULL CHECK ([Status] IN ('Open','InProgress','Resolved','Closed')),
  RaisedDate DATE NOT NULL DEFAULT CONVERT(date,SYSUTCDATETIME()),
  ResolvedDate DATE NULL,
  Resolution VARCHAR(1000) NULL
);


CREATE TABLE dbo.Budget (
  BudgetID INT IDENTITY(1,1) PRIMARY KEY,
  ProjectID INT NOT NULL,
  CostCategoryID INT NOT NULL,
  PlannedAmount DECIMAL(12,2) NOT NULL CHECK (PlannedAmount > 0),
  ActualAmount DECIMAL(12,2) NULL CHECK (ActualAmount >=0),
  CommittedAmount DECIMAL(12,2) NULL,
  VarianceAmount AS (COALESCE(ActualAmount,0)-PlannedAmount) PERSISTED,
  FiscalYear INT NULL,
  FiscalName VARCHAR(50) NULL,
  LastUpdatedDate DATETIME2(3) NOT NULL DEFAULT SYSUTCDATETIME()
);



ALTER TABLE dbo.Employee
ADD CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentID) REFERENCES dbo.Department(DepartmentID);

ALTER TABLE dbo.Department
ADD CONSTRAINT FK_Department_Manager FOREIGN KEY (ManagerEmpID) REFERENCES dbo.Employee(EmployeeID);

ALTER TABLE dbo.Project
ADD CONSTRAINT FK_Project_Department FOREIGN KEY (DepartmentID) REFERENCES dbo.Department(DepartmentID),
    CONSTRAINT FK_Project_Manager FOREIGN KEY (ProjectManagerID) REFERENCES dbo.Employee(EmployeeID),
    CONSTRAINT FK_Project_Sponsor FOREIGN KEY (SponsorID) REFERENCES dbo.Employee(EmployeeID);

ALTER TABLE dbo.ResourceAssignment
ADD CONSTRAINT FK_Assign_Project FOREIGN KEY (ProjectID) REFERENCES dbo.Project(ProjectID),
    CONSTRAINT FK_Assign_Employee FOREIGN KEY (EmployeeID) REFERENCES dbo.Employee(EmployeeID),
    CONSTRAINT FK_Assign_Equipment FOREIGN KEY (EquipmentID) REFERENCES dbo.Equipment(EquipmentID);

ALTER TABLE dbo.Task
ADD CONSTRAINT FK_Task_Project FOREIGN KEY (ProjectID) REFERENCES dbo.Project(ProjectID),
    CONSTRAINT FK_Task_Assignment FOREIGN KEY (AssignmentID) REFERENCES dbo.ResourceAssignment(AssignmentID),
    CONSTRAINT FK_Task_Parent FOREIGN KEY (ParentTaskID) REFERENCES dbo.Task(TaskID);

ALTER TABLE dbo.Milestone
ADD CONSTRAINT FK_Milestone_Project FOREIGN KEY (ProjectID) REFERENCES dbo.Project(ProjectID);

ALTER TABLE dbo.TimeEntry
ADD CONSTRAINT FK_TimeEntry_Task FOREIGN KEY (TaskID) REFERENCES dbo.Task(TaskID),
    CONSTRAINT FK_TimeEntry_Employee FOREIGN KEY (EmployeeID) REFERENCES dbo.Employee(EmployeeID),
    CONSTRAINT FK_TimeEntry_Project FOREIGN KEY (ProjectID) REFERENCES dbo.Project(ProjectID);

ALTER TABLE dbo.Risk
ADD CONSTRAINT FK_Risk_Project FOREIGN KEY (ProjectID) REFERENCES dbo.Project(ProjectID),
    CONSTRAINT FK_Risk_Owner FOREIGN KEY (OwnerEmployeeID) REFERENCES dbo.Employee(EmployeeID),
    CONSTRAINT FK_Risk_Category FOREIGN KEY (CategoryID) REFERENCES dbo.RiskCategory(CategoryID);

ALTER TABLE dbo.Issue
ADD CONSTRAINT FK_Issue_Project FOREIGN KEY (ProjectID) REFERENCES dbo.Project(ProjectID),
    CONSTRAINT FK_Issue_Task FOREIGN KEY (TaskID) REFERENCES dbo.Task(TaskID),
    CONSTRAINT FK_Issue_ReportedBy FOREIGN KEY (ReportedByEmpID) REFERENCES dbo.Employee(EmployeeID),
    CONSTRAINT FK_Issue_AssignedTo FOREIGN KEY (AssignedToEmpID) REFERENCES dbo.Employee(EmployeeID);

ALTER TABLE dbo.Budget
ADD CONSTRAINT FK_Budget_Project FOREIGN KEY (ProjectID) REFERENCES dbo.Project(ProjectID),
    CONSTRAINT FK_Budget_CostCategory FOREIGN KEY (CostCategoryID) REFERENCES dbo.CostCategory(CategoryID);

ALTER TABLE dbo.Employee
ADD CONSTRAINT FK_Employee_Resource FOREIGN KEY (ResourceID) REFERENCES dbo.Resource(ResourceID);

ALTER TABLE dbo.Equipment
ADD CONSTRAINT FK_Equipment_Resource FOREIGN KEY (ResourceID) REFERENCES dbo.Resource(ResourceID);

GO
