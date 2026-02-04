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
DELETE FROM dbo.Employee;
DELETE FROM dbo.Equipment;
DELETE FROM dbo.Resource;
DELETE FROM dbo.RiskCategory;
DELETE FROM dbo.CostCategory;
DELETE FROM dbo.Department;

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
GO


INSERT INTO dbo.Department (DepartmentName, DepartmentCode, ManagerEmpID, Budget, IsActive)
VALUES
('IT Department', 'D001', NULL, 500000.00, 1),
('HR Department', 'D002', NULL, 250000.00, 1),
('Finance Department', 'D003', NULL, 350000.00, 1),
('Marketing Department', 'D004', NULL, 400000.00, 1),
('Operations Department', 'D005', NULL, 450000.00, 1),
('R&D Department', 'D006', NULL, 600000.00, 1);
GO


INSERT INTO dbo.Resource (ResourceType, IsActive)
VALUES

('Employee', 1), ('Employee', 1), ('Employee', 1), ('Employee', 1), ('Employee', 1),
('Employee', 1), ('Employee', 1), ('Employee', 1), ('Employee', 1), ('Employee', 1),
('Employee', 1), ('Employee', 1), ('Employee', 1), ('Employee', 1), ('Employee', 1),

('Equipment', 1), ('Equipment', 1), ('Equipment', 1), ('Equipment', 1), ('Equipment', 1),
('Equipment', 1), ('Equipment', 1), ('Equipment', 1), ('Equipment', 1), ('Equipment', 1),
('Equipment', 1), ('Equipment', 1), ('Equipment', 1), ('Equipment', 1), ('Equipment', 1);
GO


INSERT INTO dbo.Employee 
(DepartmentID, FirstName, LastName, Email, Phone, JobTitle, HourlyRate, HireDate, IsActive, ResourceID)
VALUES

(1, 'Alice', 'Smith', 'alice.smith@company.com', '555-0101', 'IT Manager', 75.00, '2023-01-15', 1, 1),
(1, 'Charlie', 'Brown', 'charlie.brown@company.com', '555-0103', 'Senior Developer', 65.00, '2023-05-10', 1, 2),
(1, 'Diana', 'Prince', 'diana.prince@company.com', '555-0104', 'DevOps Engineer', 70.00, '2023-08-22', 1, 3),
(1, 'Ethan', 'Hunt', 'ethan.hunt@company.com', '555-0105', 'Database Administrator', 68.00, '2024-01-05', 1, 4),


(2, 'Bob', 'Johnson', 'bob.johnson@company.com', '555-0102', 'HR Manager', 65.00, '2023-03-20', 1, 5),
(2, 'Fiona', 'Green', 'fiona.green@company.com', '555-0106', 'HR Specialist', 50.00, '2023-09-15', 1, 6),
(2, 'George', 'Wilson', 'george.wilson@company.com', '555-0107', 'Recruiter', 45.00, '2024-02-01', 1, 7),


(3, 'Hannah', 'Lee', 'hannah.lee@company.com', '555-0108', 'Finance Manager', 80.00, '2023-02-10', 1, 8),
(3, 'Ian', 'Martinez', 'ian.martinez@company.com', '555-0109', 'Financial Analyst', 60.00, '2023-11-01', 1, 9),


(4, 'Julia', 'Davis', 'julia.davis@company.com', '555-0110', 'Marketing Manager', 70.00, '2023-04-12', 1, 10),
(4, 'Kevin', 'Taylor', 'kevin.taylor@company.com', '555-0111', 'Content Strategist', 55.00, '2024-01-20', 1, 11),


(5, 'Laura', 'Anderson', 'laura.anderson@company.com', '555-0112', 'Operations Manager', 72.00, '2023-06-05', 1, 12),
(5, 'Michael', 'Thomas', 'michael.thomas@company.com', '555-0113', 'Operations Coordinator', 52.00, '2024-03-10', 1, 13),


(6, 'Nina', 'Rodriguez', 'nina.rodriguez@company.com', '555-0114', 'R&D Manager', 85.00, '2023-01-20', 1, 14),
(6, 'Oliver', 'White', 'oliver.white@company.com', '555-0115', 'Research Scientist', 78.00, '2023-07-15', 1, 15);
GO


UPDATE dbo.Department SET ManagerEmpID = 1 WHERE DepartmentID = 1;  
UPDATE dbo.Department SET ManagerEmpID = 5 WHERE DepartmentID = 2;  
UPDATE dbo.Department SET ManagerEmpID = 8 WHERE DepartmentID = 3;  
UPDATE dbo.Department SET ManagerEmpID = 10 WHERE DepartmentID = 4; 
UPDATE dbo.Department SET ManagerEmpID = 12 WHERE DepartmentID = 5; 
UPDATE dbo.Department SET ManagerEmpID = 14 WHERE DepartmentID = 6; 
GO


INSERT INTO dbo.Equipment 
(EquipmentName, [Type], SerialNumber, DailyCost, [Status], PurchaseDate, [Location], IsActive, ResourceID)
VALUES
('Dell Laptop Pro 5000', 'Laptop', 'SN-LAPTOP-001', 25.00, 'Available', '2024-01-10', 'IT Storage Room', 1, 16),
('HP Server Rack 2U', 'Server', 'SN-SERVER-001', 150.00, 'InUse', '2023-06-15', 'Data Center', 1, 17),
('MacBook Pro 16"', 'Laptop', 'SN-LAPTOP-002', 30.00, 'InUse', '2024-02-05', 'Marketing Dept', 1, 18),
('Network Switch Cisco 48-Port', 'Network', 'SN-SWITCH-001', 50.00, 'InUse', '2023-09-20', 'Data Center', 1, 19),
('Canon Printer MX920', 'Printer', 'SN-PRINTER-001', 10.00, 'Available', '2023-11-10', 'Office Floor 2', 1, 20),
('Projector Epson 5050UB', 'Projector', 'SN-PROJ-001', 15.00, 'Available', '2024-01-15', 'Conference Room A', 1, 21),
('Lenovo ThinkPad X1', 'Laptop', 'SN-LAPTOP-003', 28.00, 'InUse', '2024-03-01', 'Finance Dept', 1, 22),
('iPad Pro 12.9"', 'Tablet', 'SN-TABLET-001', 12.00, 'Available', '2024-02-20', 'IT Storage Room', 1, 23),
('Dell Monitor 27" 4K', 'Monitor', 'SN-MONITOR-001', 8.00, 'InUse', '2023-12-05', 'IT Dept', 1, 24),
('HP Workstation Z8', 'Workstation', 'SN-WORK-001', 45.00, 'InUse', '2023-08-10', 'R&D Lab', 1, 25),
('Surface Pro 9', 'Tablet', 'SN-TABLET-002', 14.00, 'Available', '2024-01-25', 'HR Dept', 1, 26),
('Asus Router RT-AX88U', 'Network', 'SN-ROUTER-001', 20.00, 'InUse', '2023-10-15', 'Office Floor 3', 1, 27),
('Samsung Galaxy Tab S8', 'Tablet', 'SN-TABLET-003', 11.00, 'Available', '2024-02-28', 'Operations Dept', 1, 28),
('Dell PowerEdge Server', 'Server', 'SN-SERVER-002', 180.00, 'InUse', '2023-07-20', 'Data Center', 1, 29),
('Logitech Conference Cam', 'Camera', 'SN-CAM-001', 7.00, 'Available', '2024-03-05', 'Conference Room B', 1, 30);
GO


INSERT INTO dbo.CostCategory (CategoryName, CategoryCode, [Description], IsActive)
VALUES
('Hardware', 'CC-HW', 'Computer hardware and equipment costs', 1),
('Software', 'CC-SW', 'Software licenses and subscriptions', 1),
('Consulting', 'CC-CONS', 'External consulting and contractor fees', 1),
('Training', 'CC-TRAIN', 'Employee training and development', 1),
('Infrastructure', 'CC-INFRA', 'Infrastructure and facility costs', 1),
('Marketing', 'CC-MKTG', 'Marketing and advertising expenses', 1),
('Travel', 'CC-TRVL', 'Travel and accommodation expenses', 1),
('Miscellaneous', 'CC-MISC', 'Other miscellaneous project costs', 1);
GO


INSERT INTO dbo.RiskCategory (CategoryName, [Description], IsActive)
VALUES
('Technical Risk', 'Risks related to technology and technical implementation', 1),
('Resource Risk', 'Risks related to resource availability and allocation', 1),
('Budget Risk', 'Risks related to project budget and financial constraints', 1),
('Schedule Risk', 'Risks related to project timeline and deadlines', 1),
('External Risk', 'Risks from external factors like vendors or regulations', 1);
GO


INSERT INTO dbo.Project 
(DepartmentID, ProjectManagerID, SponsorID, ProjectCode, ProjectName, [Description], 
 Methodology, [Status], Priority, StartDate, PlannedEndDate, TotalBudget, ActualCost, CreatedDate)
VALUES

(1, 1, NULL, 'PRJ-2026-001', 'Website Redesign Project', 
 'Complete redesign of company website with modern UI/UX', 
 'Agile', 'Active', 'High', '2026-02-01', '2026-06-30', 150000.00, 25000.00, SYSUTCDATETIME()),

(2, 5, 1, 'PRJ-2026-002', 'HR System Migration', 
 'Migration from legacy HR system to cloud-based solution', 
 'Waterfall', 'Planned', 'Medium', '2026-03-01', '2026-09-30', 200000.00, 0.00, SYSUTCDATETIME()),

(3, 8, 1, 'PRJ-2026-003', 'Financial Analytics Dashboard', 
 'Build real-time financial analytics and reporting dashboard', 
 'Agile', 'Active', 'High', '2026-01-15', '2026-05-31', 180000.00, 45000.00, SYSUTCDATETIME()),

(4, 10, 8, 'PRJ-2026-004', 'Social Media Campaign 2026', 
 'Major social media marketing campaign for Q2 2026', 
 'Agile', 'Active', 'Medium', '2026-02-10', '2026-07-15', 120000.00, 30000.00, SYSUTCDATETIME()),


(5, 12, 10, 'PRJ-2026-005', 'Supply Chain Optimization', 
 'Optimize supply chain processes using AI and automation', 
 'Hybrid', 'Planned', 'High', '2026-04-01', '2026-12-31', 350000.00, 0.00, SYSUTCDATETIME()),

(6, 14, 8, 'PRJ-2026-006', 'New Product Research Initiative', 
 'Research and prototype development for new product line', 
 'Agile', 'Active', 'Critical', '2026-01-20', '2026-08-30', 500000.00, 85000.00, SYSUTCDATETIME()),


(1, 2, NULL, 'PRJ-2026-007', 'Mobile App Development', 
 'Native mobile app for iOS and Android platforms', 
 'Agile', 'OnHold', 'Low', '2026-05-01', '2026-11-30', 250000.00, 5000.00, SYSUTCDATETIME()),


(2, 6, 5, 'PRJ-2025-008', 'Employee Onboarding Portal', 
 'Self-service portal for new employee onboarding', 
 'Waterfall', 'Closed', 'Medium', '2025-10-01', '2026-01-31', 95000.00, 92000.00, SYSUTCDATETIME());
GO


INSERT INTO dbo.ResourceAssignment 
(ProjectID, EmployeeID, EquipmentID, ResourceType, AllocationPercent, [Role], StartDate, EndDate, AssignedDate)
VALUES

(1, 1, NULL, 'Employee', 80.00, 'Project Manager', '2026-02-01', '2026-06-30', '2026-01-15'),
(1, 2, NULL, 'Employee', 100.00, 'Lead Developer', '2026-02-01', '2026-06-30', '2026-01-15'),
(1, 3, NULL, 'Employee', 60.00, 'DevOps Engineer', '2026-02-15', '2026-06-30', '2026-01-20'),
(1, NULL, 1, 'Equipment', 100.00, NULL, '2026-02-01', '2026-06-30', '2026-01-15'),
(1, NULL, 3, 'Equipment', 100.00, NULL, '2026-02-01', '2026-06-30', '2026-01-16'),
(1, NULL, 9, 'Equipment', 100.00, NULL, '2026-02-01', '2026-06-30', '2026-01-17'),


(2, 5, NULL, 'Employee', 60.00, 'Project Manager', '2026-03-01', '2026-09-30', '2026-01-20'),
(2, 6, NULL, 'Employee', 80.00, 'HR Specialist', '2026-03-01', '2026-09-30', '2026-01-21'),
(2, NULL, 2, 'Equipment', 100.00, NULL, '2026-03-01', '2026-09-30', '2026-01-20'),
(2, NULL, 11, 'Equipment', 100.00, NULL, '2026-03-01', '2026-09-30', '2026-01-22'),


(3, 8, NULL, 'Employee', 70.00, 'Project Manager', '2026-01-15', '2026-05-31', '2026-01-10'),
(3, 9, NULL, 'Employee', 90.00, 'Financial Analyst', '2026-01-15', '2026-05-31', '2026-01-10'),
(3, 4, NULL, 'Employee', 50.00, 'Database Administrator', '2026-01-20', '2026-05-31', '2026-01-12'),
(3, NULL, 7, 'Equipment', 100.00, NULL, '2026-01-15', '2026-05-31', '2026-01-10'),
(3, NULL, 10, 'Equipment', 100.00, NULL, '2026-01-15', '2026-05-31', '2026-01-11'),


(4, 10, NULL, 'Employee', 75.00, 'Campaign Manager', '2026-02-10', '2026-07-15', '2026-02-01'),
(4, 11, NULL, 'Employee', 100.00, 'Content Strategist', '2026-02-10', '2026-07-15', '2026-02-01'),
(4, NULL, 8, 'Equipment', 100.00, NULL, '2026-02-10', '2026-07-15', '2026-02-02'),


(5, 12, NULL, 'Employee', 80.00, 'Project Manager', '2026-04-01', '2026-12-31', '2026-03-15'),
(5, 13, NULL, 'Employee', 90.00, 'Operations Coordinator', '2026-04-01', '2026-12-31', '2026-03-15'),


(6, 14, NULL, 'Employee', 85.00, 'Research Director', '2026-01-20', '2026-08-30', '2026-01-15'),
(6, 15, NULL, 'Employee', 100.00, 'Research Scientist', '2026-01-20', '2026-08-30', '2026-01-15'),
(6, 2, NULL, 'Employee', 40.00, 'Technical Consultant', '2026-02-01', '2026-08-30', '2026-01-18'),
(6, NULL, 10, 'Equipment', 100.00, NULL, '2026-01-20', '2026-08-30', '2026-01-15'),
(6, NULL, 14, 'Equipment', 100.00, NULL, '2026-01-20', '2026-08-30', '2026-01-16');
GO


INSERT INTO dbo.Task 
(ProjectID, AssignmentID, ParentTaskID, TaskName, [Description], 
 EstimatedHours, ActualHours, RemainingHours, PercentComplete, [Status], 
 PlannedStartDate, PlannedEndDate, Priority)
VALUES

(1, 1, NULL, 'Design Homepage Layout', 
 'Create wireframes and mockups for new homepage design', 
 40.00, 15.00, 25.00, 37.50, 'InProgress', '2026-02-01', '2026-02-15', 'High'),

(1, 2, NULL, 'Develop Frontend Framework', 
 'Set up React framework with TypeScript', 
 60.00, 60.00, 0.00, 100.00, 'Done', '2026-02-05', '2026-02-20', 'High'),

(1, 2, NULL, 'Implement User Authentication', 
 'Build login, registration, and password reset functionality', 
 80.00, 45.00, 35.00, 56.25, 'InProgress', '2026-02-15', '2026-03-10', 'High'),

(1, 3, NULL, 'Setup CI/CD Pipeline', 
 'Configure GitHub Actions for automated deployment', 
 30.00, 0.00, 30.00, 0.00, 'NotStarted', '2026-02-20', '2026-03-05', 'Medium'),

(1, 2, NULL, 'Create Product Catalog Pages', 
 'Build dynamic product listing and detail pages', 
 100.00, 20.00, 80.00, 20.00, 'InProgress', '2026-03-01', '2026-04-15', 'High'),

(1, 1, NULL, 'Perform User Acceptance Testing', 
 'Coordinate UAT sessions with stakeholders', 
 50.00, 0.00, 50.00, 0.00, 'NotStarted', '2026-05-15', '2026-06-15', 'High'),

(1, 2, NULL, 'Optimize Performance', 
 'Implement caching and lazy loading strategies', 
 40.00, 0.00, 40.00, 0.00, 'NotStarted', '2026-05-01', '2026-05-31', 'Medium'),

(1, 3, NULL, 'Deploy to Production', 
 'Final production deployment and monitoring setup', 
 20.00, 0.00, 20.00, 0.00, 'NotStarted', '2026-06-20', '2026-06-30', 'Critical'),


(2, 7, NULL, 'Document Current HR Processes', 
 'Document all existing HR workflows and processes', 
 80.00, 0.00, 80.00, 0.00, 'NotStarted', '2026-03-01', '2026-03-31', 'High'),

(2, 8, NULL, 'Evaluate Cloud HR Platforms', 
 'Research and compare top cloud HR solutions', 
 60.00, 0.00, 60.00, 0.00, 'NotStarted', '2026-03-15', '2026-04-15', 'High'),

(2, 7, NULL, 'Design Migration Strategy', 
 'Create detailed migration plan and timeline', 
 40.00, 0.00, 40.00, 0.00, 'NotStarted', '2026-04-15', '2026-05-15', 'High'),

(2, 8, NULL, 'Configure New HR System', 
 'Set up and customize selected HR platform', 
 120.00, 0.00, 120.00, 0.00, 'NotStarted', '2026-05-15', '2026-07-15', 'High'),

(2, 8, NULL, 'Migrate Employee Data', 
 'Transfer all employee records to new system', 
 100.00, 0.00, 100.00, 0.00, 'NotStarted', '2026-07-15', '2026-08-31', 'Critical'),

(2, 7, NULL, 'Train HR Staff', 
 'Conduct training sessions for HR team', 
 50.00, 0.00, 50.00, 0.00, 'NotStarted', '2026-08-15', '2026-09-15', 'Medium'),


(3, 11, NULL, 'Define Dashboard Requirements', 
 'Gather requirements from finance stakeholders', 
 30.00, 30.00, 0.00, 100.00, 'Done', '2026-01-15', '2026-01-25', 'High'),

(3, 13, NULL, 'Design Database Schema', 
 'Create data model for analytics warehouse', 
 50.00, 50.00, 0.00, 100.00, 'Done', '2026-01-20', '2026-02-05', 'High'),

(3, 13, NULL, 'Build ETL Pipelines', 
 'Develop data extraction and transformation scripts', 
 80.00, 55.00, 25.00, 68.75, 'InProgress', '2026-02-01', '2026-03-15', 'High'),

(3, 12, NULL, 'Create Dashboard Mockups', 
 'Design UI/UX for analytics dashboard', 
 40.00, 40.00, 0.00, 100.00, 'Done', '2026-02-10', '2026-02-28', 'Medium'),

(3, 11, NULL, 'Develop Dashboard Frontend', 
 'Build interactive dashboard using Power BI', 
 90.00, 30.00, 60.00, 33.33, 'InProgress', '2026-03-01', '2026-04-30', 'High'),

(3, 13, NULL, 'Implement Real-time Data Sync', 
 'Set up live data streaming to dashboard', 
 60.00, 0.00, 60.00, 0.00, 'NotStarted', '2026-04-15', '2026-05-15', 'High'),

(3, 11, NULL, 'Conduct User Training', 
 'Train finance team on dashboard usage', 
 25.00, 0.00, 25.00, 0.00, 'NotStarted', '2026-05-15', '2026-05-31', 'Medium'),


(4, 16, NULL, 'Develop Campaign Strategy', 
 'Create overall social media strategy and goals', 
 35.00, 35.00, 0.00, 100.00, 'Done', '2026-02-10', '2026-02-25', 'High'),

(4, 17, NULL, 'Create Content Calendar', 
 'Plan content schedule for all platforms', 
 20.00, 20.00, 0.00, 100.00, 'Done', '2026-02-20', '2026-03-05', 'High'),

(4, 17, NULL, 'Produce Creative Content', 
 'Design graphics, videos, and copy for posts', 
 150.00, 80.00, 70.00, 53.33, 'InProgress', '2026-03-01', '2026-06-30', 'High'),

(4, 16, NULL, 'Launch Campaign Phase 1', 
 'Begin posting and engaging on social platforms', 
 60.00, 25.00, 35.00, 41.67, 'InProgress', '2026-03-15', '2026-05-15', 'Critical'),

(4, 16, NULL, 'Analyze Campaign Performance', 
 'Review metrics and adjust strategy as needed', 
 40.00, 0.00, 40.00, 0.00, 'NotStarted', '2026-05-15', '2026-07-15', 'Medium'),


(5, 19, NULL, 'Map Current Supply Chain', 
 'Document existing supply chain processes', 
 70.00, 0.00, 70.00, 0.00, 'NotStarted', '2026-04-01', '2026-05-15', 'High'),

(5, 20, NULL, 'Identify Optimization Opportunities', 
 'Analyze inefficiencies and improvement areas', 
 50.00, 0.00, 50.00, 0.00, 'NotStarted', '2026-05-15', '2026-06-30', 'High'),

(5, 19, NULL, 'Implement AI Forecasting Models', 
 'Build predictive models for demand forecasting', 
 120.00, 0.00, 120.00, 0.00, 'NotStarted', '2026-07-01', '2026-10-31', 'High'),

(5, 20, NULL, 'Automate Order Processing', 
 'Deploy automation for purchase orders', 
 90.00, 0.00, 90.00, 0.00, 'NotStarted', '2026-09-01', '2026-12-15', 'Medium'),


(6, 21, NULL, 'Conduct Market Research', 
 'Research market trends and customer needs', 
 60.00, 60.00, 0.00, 100.00, 'Done', '2026-01-20', '2026-02-15', 'High'),

(6, 22, NULL, 'Develop Product Concepts', 
 'Create initial product concept designs', 
 80.00, 80.00, 0.00, 100.00, 'Done', '2026-02-01', '2026-03-01', 'High'),

(6, 22, NULL, 'Build Prototypes', 
 'Construct functional prototypes for testing', 
 150.00, 95.00, 55.00, 63.33, 'InProgress', '2026-03-01', '2026-05-31', 'Critical'),

(6, 21, NULL, 'Test Prototypes with Focus Groups', 
 'Gather user feedback on prototypes', 
 50.00, 15.00, 35.00, 30.00, 'InProgress', '2026-05-01', '2026-06-30', 'High'),

(6, 21, NULL, 'Finalize Product Specifications', 
 'Document final product requirements', 
 40.00, 0.00, 40.00, 0.00, 'NotStarted', '2026-07-01', '2026-08-30', 'High');
GO


INSERT INTO dbo.Milestone 
(ProjectID, MilestoneName, [Description], PlannedDate, ActualDate, [Status], IsPhaseGate)
VALUES

(1, 'Design Phase Complete', 'All design mockups approved by stakeholders', 
 '2026-02-28', NULL, 'Planned', 1),
(1, 'Development Phase 1 Complete', 'Core functionality implemented', 
 '2026-04-15', NULL, 'Planned', 1),
(1, 'UAT Complete', 'User acceptance testing finished', 
 '2026-06-15', NULL, 'Planned', 1),


(2, 'Requirements Finalized', 'HR system requirements approved', 
 '2026-03-31', NULL, 'Planned', 1),
(2, 'Platform Selection', 'Cloud HR platform selected', 
 '2026-04-30', NULL, 'Planned', 1),
(2, 'Data Migration Complete', 'All employee data migrated', 
 '2026-08-31', NULL, 'Planned', 1),


(3, 'Requirements Approved', 'Dashboard requirements signed off', 
 '2026-01-25', '2026-01-25', 'Completed', 0),
(3, 'Database Ready', 'Analytics database operational', 
 '2026-02-28', NULL, 'InProgress', 1),
(3, 'Dashboard Beta Release', 'Beta version available for testing', 
 '2026-04-30', NULL, 'Planned', 1),


(4, 'Strategy Approved', 'Campaign strategy finalized', 
 '2026-02-25', '2026-02-25', 'Completed', 1),
(4, 'Campaign Launch', 'Phase 1 campaign goes live', 
 '2026-03-15', '2026-03-15', 'Completed', 1),
(4, 'Mid-Campaign Review', 'Performance review and adjustments', 
 '2026-05-15', NULL, 'Planned', 0),


(5, 'Process Mapping Complete', 'Current processes documented', 
 '2026-05-15', NULL, 'Planned', 1),
(5, 'AI Models Deployed', 'Forecasting models in production', 
 '2026-10-31', NULL, 'Planned', 1),


(6, 'Market Research Complete', 'Research findings presented', 
 '2026-02-15', '2026-02-15', 'Completed', 1),
(6, 'Prototype Ready', 'First functional prototype complete', 
 '2026-05-31', NULL, 'InProgress', 1);
GO


INSERT INTO dbo.TimeEntry 
(TaskID, EmployeeID, ProjectID, WorkDate, HoursWorked, [Description], ApprovalStatus, IsBillable)
VALUES

(1, 1, 1, '2026-02-03', 8.00, 'Created initial wireframes for homepage', 'Approved', 1),
(1, 1, 1, '2026-02-04', 7.00, 'Refined homepage design based on feedback', 'Approved', 1),
(2, 2, 1, '2026-02-05', 8.00, 'Set up React project structure', 'Approved', 1),
(2, 2, 1, '2026-02-06', 8.00, 'Configured TypeScript and linting', 'Approved', 1),
(2, 2, 1, '2026-02-07', 8.00, 'Implemented component architecture', 'Approved', 1),
(2, 2, 1, '2026-02-08', 7.50, 'Created reusable UI components', 'Approved', 1),
(3, 2, 1, '2026-02-16', 8.00, 'Built login form and validation', 'Approved', 1),
(3, 2, 1, '2026-02-17', 7.00, 'Implemented JWT authentication', 'Approved', 1),
(3, 2, 1, '2026-02-18', 8.00, 'Added password reset functionality', 'Submitted', 1),
(5, 2, 1, '2026-03-01', 6.50, 'Started product catalog data model', 'Approved', 1),


(15, 11, 3, '2026-01-15', 8.00, 'Initial stakeholder meetings', 'Approved', 1),
(15, 11, 3, '2026-01-16', 7.00, 'Documented dashboard requirements', 'Approved', 1),
(15, 12, 3, '2026-01-17', 6.00, 'Reviewed requirements with team', 'Approved', 1),
(16, 13, 3, '2026-01-22', 8.00, 'Designed data warehouse schema', 'Approved', 1),
(16, 13, 3, '2026-01-23', 8.00, 'Created entity-relationship diagrams', 'Approved', 1),
(16, 13, 3, '2026-01-24', 7.50, 'Implemented database tables', 'Approved', 1),
(17, 13, 3, '2026-02-03', 8.00, 'Built data extraction scripts', 'Approved', 1),
(17, 13, 3, '2026-02-04', 8.00, 'Developed transformation logic', 'Approved', 1),
(17, 13, 3, '2026-02-05', 7.00, 'Tested ETL pipeline', 'Submitted', 1),
(18, 12, 3, '2026-02-12', 8.00, 'Created dashboard wireframes', 'Approved', 1),
(18, 12, 3, '2026-02-13', 8.00, 'Designed visual components', 'Approved', 1),
(19, 11, 3, '2026-03-03', 7.50, 'Started Power BI development', 'Approved', 1),


(22, 10, 4, '2026-02-10', 8.00, 'Brainstormed campaign ideas', 'Approved', 1),
(22, 10, 4, '2026-02-11', 7.00, 'Defined campaign goals and KPIs', 'Approved', 1),
(22, 11, 4, '2026-02-12', 6.50, 'Researched competitor campaigns', 'Approved', 1),
(23, 11, 4, '2026-02-22', 8.00, 'Created content calendar template', 'Approved', 1),
(23, 11, 4, '2026-02-23', 6.00, 'Scheduled posts for March', 'Approved', 1),
(24, 11, 4, '2026-03-01', 8.00, 'Designed Instagram graphics', 'Approved', 1),
(24, 11, 4, '2026-03-02', 7.50, 'Created Facebook ad copy', 'Approved', 1),
(24, 11, 4, '2026-03-03', 8.00, 'Produced promotional video', 'Submitted', 1),
(25, 10, 4, '2026-03-16', 6.00, 'Posted first campaign content', 'Approved', 1),


(27, 14, 6, '2026-01-22', 8.00, 'Analyzed market trends', 'Approved', 1),
(27, 14, 6, '2026-01-23', 7.50, 'Reviewed competitor products', 'Approved', 1),
(28, 15, 6, '2026-02-03', 8.00, 'Sketched product concepts', 'Approved', 1),
(28, 15, 6, '2026-02-04', 8.00, 'Created 3D models', 'Approved', 1),
(29, 15, 6, '2026-03-05', 8.00, 'Built first prototype', 'Approved', 1),
(29, 15, 6, '2026-03-06', 7.00, 'Tested prototype functionality', 'Submitted', 1),
(30, 14, 6, '2026-05-05', 6.50, 'Conducted focus group session', 'Approved', 1);
GO


INSERT INTO dbo.Risk 
(ProjectID, OwnerEmployeeID, CategoryID, RiskDescription, Probability, Impact, 
 MitigationStrategy, ContingencyPlan, [Status], IdentifiedDate)
VALUES

(1, 1, 1, 'Third-party API integration may face compatibility issues', 
 3, 4, 'Conduct thorough API testing early in development', 
 'Have backup API provider identified', 'Open', '2026-02-01'),
(1, 2, 2, 'Key developer may be unavailable due to illness', 
 2, 4, 'Cross-train team members on critical components', 
 'Hire contract developer if needed', 'Mitigating', '2026-02-05'),
(1, 1, 4, 'Website launch may be delayed due to UAT issues', 
 3, 3, 'Schedule UAT early with buffer time', 
 'Implement phased rollout if needed', 'Open', '2026-02-10'),


(2, 5, 2, 'HR staff unavailable during migration', 
 2, 4, 'Confirm availability early and schedule accordingly', 
 'Train backup staff on procedures', 'Mitigating', '2026-02-15'),
(2, 5, 5, 'Cloud provider may have service outage during migration', 
 1, 5, 'Schedule migration during low-usage period', 
 'Have rollback plan ready', 'Accepted', '2026-02-20'),
(2, 5, 3, 'Budget overrun due to unexpected customization needs', 
 3, 3, 'Detailed requirements gathering upfront', 
 'Secure additional budget approval', 'Open', '2026-03-01'),


(3, 8, 1, 'Data quality issues in source systems', 
 4, 3, 'Implement data validation and cleansing', 
 'Manual data correction process', 'Mitigating', '2026-01-20'),
(3, 13, 1, 'ETL pipeline performance may be too slow', 
 2, 3, 'Optimize queries and add indexing', 
 'Scale up database resources', 'Open', '2026-02-01'),
(3, 8, 4, 'Dashboard delivery delayed by requirements changes', 
 3, 2, 'Freeze requirements after approval', 
 'Defer non-critical features to phase 2', 'Closed', '2026-02-15'),


(4, 10, 5, 'Social media platform policy changes affect campaign', 
 2, 3, 'Monitor platform announcements closely', 
 'Diversify across multiple platforms', 'Open', '2026-02-12'),
(4, 10, 3, 'Content production costs exceed budget', 
 3, 2, 'Track expenses weekly and adjust scope', 
 'Use in-house resources more', 'Mitigating', '2026-02-25'),


(5, 12, 1, 'AI models may not achieve desired accuracy', 
 3, 4, 'Use proven algorithms and validate extensively', 
 'Fall back to statistical methods', 'Open', '2026-03-20'),
(5, 12, 2, 'Operations team resistance to automation', 
 2, 3, 'Involve team early and provide training', 
 'Implement gradual rollout', 'Open', '2026-03-22'),


(6, 14, 1, 'Prototype testing reveals fundamental design flaw', 
 2, 5, 'Build multiple concept prototypes', 
 'Pivot to alternative design', 'Mitigating', '2026-01-25'),
(6, 14, 3, 'Research budget insufficient for all planned tests', 
 3, 3, 'Prioritize most critical tests first', 
 'Seek additional funding or reduce scope', 'Open', '2026-02-01'),
(6, 15, 4, 'Market conditions change before product launch', 
 2, 4, 'Monitor market trends continuously', 
 'Adjust product features accordingly', 'Open', '2026-02-10'),


(7, 2, 3, 'Project on hold - budget reallocated', 
 5, 4, 'Seek budget restoration', 
 'Cancel or postpone indefinitely', 'Accepted', '2026-04-15'),


(8, 6, 4, 'Portal launch missed original deadline', 
 3, 2, 'Added resources to complete on time', 
 'Extended deadline by 2 weeks', 'Closed', '2025-12-15');
GO


INSERT INTO dbo.Issue 
(ProjectID, TaskID, ReportedByEmpID, AssignedToEmpID, IssueDescription, 
 Severity, Priority, [Status], RaisedDate, ResolvedDate, Resolution)
VALUES

(1, 1, 1, 1, 'Design tools license expired, blocking work', 
 'High', 'Critical', 'Resolved', '2026-02-02', '2026-02-02', 
 'Emergency license renewal processed'),
(1, 3, 2, 3, 'Authentication API returning intermittent errors', 
 'Medium', 'High', 'InProgress', '2026-02-17', NULL, NULL),
(1, NULL, 1, 2, 'Client requested major design changes after approval', 
 'Medium', 'High', 'Open', '2026-03-01', NULL, NULL),


(2, 9, 5, 5, 'Stakeholder feedback delayed for requirements', 
 'Medium', 'High', 'Resolved', '2026-03-05', '2026-03-08', 
 'Scheduled emergency meeting with stakeholders'),
(2, NULL, 6, 5, 'Cloud platform pricing increased unexpectedly', 
 'Low', 'Medium', 'Open', '2026-03-10', NULL, NULL),


(3, 17, 13, 13, 'ETL job failing due to source data format change', 
 'Critical', 'Critical', 'Resolved', '2026-02-06', '2026-02-07', 
 'Updated ETL logic to handle new format'),
(3, 19, 11, 11, 'Power BI license seats insufficient for team', 
 'Medium', 'Medium', 'InProgress', '2026-03-04', NULL, NULL),
(3, NULL, 8, 9, 'Finance team requested additional metrics', 
 'Low', 'Low', 'Open', '2026-03-08', NULL, NULL),


(4, 24, 11, 11, 'Video editing software crashed, lost work', 
 'High', 'High', 'Resolved', '2026-03-03', '2026-03-03', 
 'Recovered from auto-save, reinstalled software'),
(4, 25, 10, 10, 'Social media platform rejected ad for policy violation', 
 'Medium', 'High', 'Resolved', '2026-03-18', '2026-03-19', 
 'Revised ad content and resubmitted successfully'),


(6, 29, 15, 15, 'Prototype material supplier out of stock', 
 'Medium', 'Medium', 'InProgress', '2026-03-07', NULL, NULL),
(6, 30, 14, 14, 'Focus group participants cancelled last minute', 
 'Low', 'Medium', 'Open', '2026-05-06', NULL, NULL),


(7, NULL, 2, NULL, 'Project placed on hold due to budget constraints', 
 'Critical', 'Critical', 'Open', '2026-04-15', NULL, NULL),


(8, NULL, 6, 6, 'Portal performance slow with large data sets', 
 'Medium', 'Medium', 'Closed', '2026-01-10', '2026-01-20', 
 'Database indexing added, performance improved'),
(8, NULL, 6, 6, 'Mobile responsiveness issues on tablets', 
 'Low', 'Low', 'Closed', '2026-01-15', '2026-01-25', 
 'CSS media queries adjusted for tablet screens');
GO


INSERT INTO dbo.Budget 
(ProjectID, CostCategoryID, PlannedAmount, ActualAmount, CommittedAmount, FiscalYear, FiscalName, LastUpdatedDate)
VALUES

(1, 1, 80000.00, 15000.00, 20000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(1, 2, 50000.00, 8000.00, 10000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(1, 4, 10000.00, 2000.00, 3000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(1, 8, 10000.00, 0.00, 2000.00, 2026, 'FY2026', SYSUTCDATETIME()),


(2, 1, 50000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),
(2, 2, 120000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),
(2, 3, 20000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),
(2, 4, 10000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),


(3, 1, 60000.00, 25000.00, 30000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(3, 2, 90000.00, 18000.00, 25000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(3, 3, 20000.00, 2000.00, 5000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(3, 4, 10000.00, 0.00, 2000.00, 2026, 'FY2026', SYSUTCDATETIME()),


(4, 6, 80000.00, 22000.00, 30000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(4, 2, 20000.00, 5000.00, 8000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(4, 3, 15000.00, 3000.00, 5000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(4, 8, 5000.00, 0.00, 1000.00, 2026, 'FY2026', SYSUTCDATETIME()),


(5, 1, 100000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),
(5, 2, 150000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),
(5, 3, 80000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),
(5, 4, 20000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),


(6, 1, 150000.00, 35000.00, 50000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(6, 2, 80000.00, 15000.00, 20000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(6, 3, 120000.00, 20000.00, 35000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(6, 4, 50000.00, 8000.00, 15000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(6, 5, 100000.00, 7000.00, 15000.00, 2026, 'FY2026', SYSUTCDATETIME()),


(7, 1, 80000.00, 2000.00, 5000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(7, 2, 120000.00, 3000.00, 5000.00, 2026, 'FY2026', SYSUTCDATETIME()),
(7, 3, 40000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),
(7, 8, 10000.00, 0.00, 0.00, 2026, 'FY2026', SYSUTCDATETIME()),


(8, 1, 35000.00, 32000.00, 32000.00, 2025, 'FY2025', SYSUTCDATETIME()),
(8, 2, 45000.00, 43000.00, 43000.00, 2025, 'FY2025', SYSUTCDATETIME()),
(8, 3, 10000.00, 12000.00, 12000.00, 2025, 'FY2025', SYSUTCDATETIME()),
(8, 8, 5000.00, 5000.00, 5000.00, 2025, 'FY2025', SYSUTCDATETIME());
GO


PRINT '';
PRINT '=====================================================';
PRINT 'EXPANDED DATA INSERTION COMPLETED SUCCESSFULLY!';
PRINT '=====================================================';
PRINT '';
PRINT 'Record counts:';
SELECT 'Department' AS TableName, COUNT(*) AS RecordCount FROM dbo.Department
UNION ALL SELECT 'Resource', COUNT(*) FROM dbo.Resource
UNION ALL SELECT 'Employee', COUNT(*) FROM dbo.Employee
UNION ALL SELECT 'Equipment', COUNT(*) FROM dbo.Equipment
UNION ALL SELECT 'CostCategory', COUNT(*) FROM dbo.CostCategory
UNION ALL SELECT 'RiskCategory', COUNT(*) FROM dbo.RiskCategory
UNION ALL SELECT 'Project', COUNT(*) FROM dbo.Project
UNION ALL SELECT 'ResourceAssignment', COUNT(*) FROM dbo.ResourceAssignment
UNION ALL SELECT 'Task', COUNT(*) FROM dbo.Task
UNION ALL SELECT 'Milestone', COUNT(*) FROM dbo.Milestone
UNION ALL SELECT 'TimeEntry', COUNT(*) FROM dbo.TimeEntry
UNION ALL SELECT 'Risk', COUNT(*) FROM dbo.Risk
UNION ALL SELECT 'Issue', COUNT(*) FROM dbo.Issue
UNION ALL SELECT 'Budget', COUNT(*) FROM dbo.Budget
ORDER BY TableName;
GO