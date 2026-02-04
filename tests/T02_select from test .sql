USE PMO_DB;
GO


SELECT P.ProjectName, E.FirstName + ' ' + E.LastName AS ProjectManager
FROM dbo.Project P
JOIN dbo.Employee E ON P.ProjectManagerID = E.EmployeeID;


SELECT RA.ResourceType, RA.EmployeeID, RA.EquipmentID
FROM dbo.ResourceAssignment RA;


SELECT T.TaskName, P.ProjectName
FROM dbo.Task T
JOIN dbo.Project P ON T.ProjectID = P.ProjectID;