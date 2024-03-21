BEGIN
   FOR c IN (SELECT username FROM dba_users WHERE username = 'DORM_USER') LOOP
      EXECUTE IMMEDIATE 'DROP USER DORM_USER CASCADE';
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      -- ignore if user does not exist
      NULL;
END;
/

BEGIN
   FOR c IN (SELECT username FROM dba_users WHERE username = 'DORM_MANAGEMENT') LOOP
      EXECUTE IMMEDIATE 'DROP USER DORM_MANAGEMENT CASCADE';
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      -- ignore if user does not exist
      NULL;
END;
/


--1.dorm_user
CREATE USER dorm_user IDENTIFIED BY User2023password#;

GRANT CONNECT, RESOURCE TO dorm_user;
GRANT SELECT, INSERT, UPDATE ON user_table TO dorm_user;
GRANT SELECT, INSERT, UPDATE ON user_lease TO dorm_user;
GRANT CREATE VIEW TO dorm_user;


--2.dorm_management
CREATE USER dorm_management IDENTIFIED BY Admin2023password#;

GRANT CONNECT TO dorm_management;
-- Consider granting specific privileges instead of RESOURCE, or ensure RESOURCE is acceptable in your context.
GRANT CREATE SESSION, CREATE TABLE, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TRIGGER TO dorm_management;

-- Permissions to manage 'owner' details
GRANT SELECT, INSERT, UPDATE, DELETE ON owner TO dorm_management;
-- Access to view and update university information
GRANT SELECT, UPDATE ON university TO dorm_management;
-- Full access to 'dormitory' table for management purposes
GRANT SELECT, INSERT, UPDATE, DELETE ON dormitory TO dorm_management;
-- 'property' management might require comprehensive permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON property TO dorm_management;
-- Lease management permissions corrected to match user name
GRANT SELECT, UPDATE ON lease TO dorm_management;
-- Reviewing and moderating 'review' entries
GRANT SELECT, UPDATE, DELETE ON review TO dorm_management;
-- Basic access to 'user_table', primarily for viewing
GRANT SELECT ON user_table TO dorm_management;

-- Example: Granting the ability to create views if necessary
GRANT CREATE VIEW TO dorm_management;
