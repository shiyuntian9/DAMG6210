
--1.dorm_user
CREATE USER dorm_user IDENTIFIED BY new_user_password;

GRANT CONNECT, RESOURCE TO dorm_user;
GRANT SELECT, INSERT, UPDATE ON user_table TO dorm_user;
GRANT SELECT, INSERT, UPDATE ON user_lease TO dorm_user;
GRANT CREATE VIEW TO dorm_user;


--2.dorm_management
CREATE USER dorm_management IDENTIFIED BY secure_password;

GRANT CONNECT TO dorm_management;
GRANT RESOURCE TO dorm_management;

-- Permissions to manage 'owner' details
GRANT SELECT, INSERT, UPDATE, DELETE ON owner TO dorm_management;
-- Access to view and update university information
GRANT SELECT, UPDATE ON university TO dorm_management;
-- Full access to 'dormitory' table for management purposes
GRANT SELECT, INSERT, UPDATE, DELETE ON dormitory TO dorm_management;
-- 'property' management might require comprehensive permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON property TO dorm_management;
-- Lease management permissions
GRANT SELECT, UPDATE ON lease TO dorm_manager;
-- Reviewing and moderating 'review' entries
GRANT SELECT, UPDATE, DELETE ON review TO dorm_management;
-- Basic access to 'user_table', primarily for viewing
GRANT SELECT ON user_table TO dorm_management;

-- Example: Granting the ability to create views if necessary
GRANT CREATE VIEW TO dorm_management;

