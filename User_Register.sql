-- Check Email Uniqueness
CREATE OR REPLACE FUNCTION IsEmailUnique(p_email VARCHAR2)
RETURN BOOLEAN
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM user_table
    WHERE user_email = LOWER(p_email);

    RETURN v_count = 0;
END;


-- User Registration
CREATE OR REPLACE PROCEDURE RegisterUser(
    p_nickname VARCHAR2,
    p_email VARCHAR2,
    p_password VARCHAR2,
    p_avatar BLOB
) AS
    -- Check if the email is unique
    email_unique BOOLEAN;
BEGIN
    email_unique := UserManagement.IsEmailUnique(p_email);
    IF NOT email_unique THEN
        RAISE_APPLICATION_ERROR(-20001, 'Email address already in use.');
    END IF;

    -- Insert the new user into the user_table
    INSERT INTO user_table (user_id, nickname, user_email, password, avatar, register_time, status)
    VALUES (user_seq.NEXTVAL, p_nickname, LOWER(p_email), p_password, p_avatar, SYSDATE, 1);

    -- Log the registration
    INSERT INTO registration_log (user_id, log_date)
    VALUES (user_seq.CURRVAL, SYSDATE);
END;


-- post register task
CREATE OR REPLACE TRIGGER SetUpUserPreferences
AFTER INSERT ON user_table
FOR EACH ROW
BEGIN
    INSERT INTO user_preferences (user_id, preference_setting, setting_value)
    VALUES (:NEW.user_id, 'theme', 'default');
END;


-- user management
CREATE OR REPLACE PACKAGE UserManagement IS
    FUNCTION IsEmailUnique(p_email VARCHAR2) RETURN BOOLEAN;
    PROCEDURE RegisterUser(p_nickname VARCHAR2, p_email VARCHAR2, p_password VARCHAR2, p_avatar BLOB);
END UserManagement;

CREATE OR REPLACE PACKAGE BODY UserManagement IS
    FUNCTION IsEmailUnique(p_email VARCHAR2) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM user_table
        WHERE user_email = LOWER(p_email);

        RETURN v_count = 0;
    END IsEmailUnique;

    PROCEDURE RegisterUser(
        p_nickname VARCHAR2,
        p_email VARCHAR2,
        p_password VARCHAR2,
        p_avatar BLOB
    ) AS
        email_unique BOOLEAN;
    BEGIN
        email_unique := IsEmailUnique(p_email);
        IF NOT email_unique THEN
            RAISE_APPLICATION_ERROR(-20001, 'Email address already in use.');
        END IF;

        INSERT INTO user_table (user_id, nickname, user_email, password, avatar, register_time, status)
        VALUES (user_seq.NEXTVAL, p_nickname, LOWER(p_email), p_password, p_avatar, SYSDATE, 1);

        -- Log the registration
        INSERT INTO registration_log (user_id, log_date)
        VALUES (user_seq.CURRVAL, SYSDATE);
    END RegisterUser;
END UserManagement;


-- simulate by executing the stored procedure 
-- Sample data for a new user registration
DECLARE
    v_nickname VARCHAR2(255) := 'JohnDoe';
    v_email VARCHAR2(255) := 'johndoe@example.com';
    v_password VARCHAR2(255) := 'securePassword123';
    v_avatar BLOB := NULL;  -- Assuming no avatar data for simplicity
BEGIN
    UserManagement.RegisterUser(v_nickname, v_email, v_password, v_avatar);
    COMMIT;
END;
