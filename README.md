# Project Management Office (PMO) Database

## Overview

This project implements a complete **Project Management Office (PMO) relational database** using **Microsoft SQL Server**. It is designed to model, manage, secure, and audit real-world project management operations, including projects, employees, tasks, budgets, risks, resources, and reporting.

The database follows **industry best practices** in schema design, data integrity, security, auditing, and testing. It is suitable for academic submission, portfolio demonstration, or real-world PMO-style systems.

---

## Technologies Used

* Microsoft SQL Server (T-SQL)
* SQL Server Management Studio (SSMS)

---

## Project Structure & Implementation Steps

### 1. Database Creation

* Created the main database: `PMO_DB`
* Established the default schema (`dbo`)

### 2. Schema Design & ERD Logic

* Designed entities and relationships based on PMO business rules
* Identified master, transactional, and lookup tables

### 3. Master Tables Creation

* Department
* Employee
* Resource
* Equipment
* CostCategory
* RiskCategory

### 4. Transactional Tables Creation

* Project
* Task
* Milestone
* Budget
* Risk
* Issue
* TimeEntry
* ResourceAssignment

### 5. Primary Keys & Foreign Keys

* Implemented primary keys for all tables
* Enforced referential integrity using foreign key constraints
* Handled self-referencing relationships where required

### 6. Constraints

* CHECK constraints for valid values (status, percentages, etc.)
* UNIQUE constraints where applicable
* NOT NULL constraints to enforce mandatory fields

### 7. Indexes

* Created indexes on frequently queried columns
* Improved performance for joins, lookups, and reporting queries

### 8. Test / Seed Data Insertion

* Inserted realistic sample data across all tables
* Ensured data consistency with constraints and relationships

### 9. Clear & Reseed Scripts

* Created scripts to:

  * Safely delete data in dependency order
  * Reset identity columns using `DBCC CHECKIDENT`
* Used for clean re-testing and demonstrations

### 10. Stored Procedures

* Encapsulated business logic using stored procedures
* Examples:

  * Project insertion
  * Resource assignment
  * Project status updates

### 11. Scalar Functions

* Reusable functions returning single values
* Examples:

  * Project budget utilization percentage
  * Employee full name
  * Project completion percentage

### 12. Table-Valued Functions (TVFs)

* Functions returning result sets
* Used for structured project/task reporting

### 13. Views (Reporting / Validation Layer)

* Created views for:

  * Simplified reporting
  * Data validation
  * Business-level abstraction over base tables

### 14. Triggers (Business Rules)

* Enforced automatic behavior on data changes
* Examples:

  * Cascading task status updates based on project status
  * Resource allocation validation

### 15. Logging Tables

* Tables created to track operational changes
* Examples:

  * Project status changes
  * Budget updates

### 16. Audit Tables

* Centralized audit table (`AuditLog`)
* Stores:

  * Table name
  * Action type (INSERT / UPDATE / DELETE)
  * Old and new values
  * User and timestamp

### 17. Audit Triggers

* Triggers that write to the audit table
* Automatically capture critical project changes
* Ensures accountability and traceability

### 18. Security Roles

* Created database roles:

  * `PMO_Admin`
  * `Project_Manager`
  * `Team_Member`

### 19. Permissions

* Applied role-based access control using `GRANT`
* Defined:

  * Full access for PMO_Admin
  * Read-only access for Project_Manager
  * Limited read access for Team_Member
* Controlled execution of stored procedures

### 20. Role-Based Behavior

* Security enforced automatically by SQL Server
* Permissions evaluated based on the connected database user
* No additional logic required in application code

### 21. Testing Queries

* Validation scripts to confirm:

  * Roles and permissions
  * Trigger execution
  * Audit logging
  * Business rules enforcement
* Example tests:

  * Updating a project and verifying audit entries
  * Confirming permission-based access behavior

---

## Key Features

* Fully normalized relational design
* Strong data integrity enforcement
* Automated auditing and logging
* Role-based security model
* Modular and reusable SQL code
* Clear separation between data, logic, and reporting

---

## How to Use

1. Run scripts in order (from database creation to testing queries)
2. Connect using different database users to test role behavior
3. Execute provided test queries to validate functionality

---

