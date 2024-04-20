CREATE OR REPLACE PACKAGE user_registration_pkg IS
    -- Function to check if the email already exists
    FUNCTION email_exists(p_email IN VARCHAR2) RETURN BOOLEAN;

    -- Procedure to register a new user
    PROCEDURE register_user(
        p_nickname         IN VARCHAR2,
        p_email            IN VARCHAR2,
        p_password         IN VARCHAR2,
        p_payment_method   IN VARCHAR2,
        p_balance          IN FLOAT,
        p_grade            IN VARCHAR2,
        p_avatar           IN BLOB,
        p_register_time    IN DATE,
        p_status           IN NUMBER
    );
END user_registration_pkg;
/

CREATE OR REPLACE PACKAGE BODY user_registration_pkg IS

    -- Function to check if the email already exists
    FUNCTION email_exists(p_email IN VARCHAR2) RETURN BOOLEAN IS
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM user_table
        WHERE user_email = p_email;

        RETURN (v_count > 0);
    END email_exists;

    -- Procedure to register a new user
    PROCEDURE register_user(
        p_nickname         IN VARCHAR2,
        p_email            IN VARCHAR2,
        p_password         IN VARCHAR2,
        p_payment_method   IN VARCHAR2,
        p_balance          IN FLOAT,
        p_grade            IN VARCHAR2,
        p_avatar           IN BLOB,
        p_register_time    IN DATE,
        p_status           IN NUMBER
    ) IS
    BEGIN
        -- Check if the email already exists
        IF email_exists(p_email) THEN
            RAISE_APPLICATION_ERROR(-20001, 'Email already registered.');
        END IF;

        -- Insert the new user into the database
        INSERT INTO user_table (
            user_id,
            nickname,
            user_email,
            password,
            payment_method,
            balance,
            grade,
            avatar,
            register_time,
            status
        ) VALUES (
            user_seq.NEXTVAL, -- we have a sequence for user IDs
            p_nickname,
            p_email,
            p_password,
            p_payment_method,
            p_balance,
            p_grade,
            p_avatar,
            p_register_time,
            p_status
        );
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END register_user;

END user_registration_pkg;
/


CREATE OR REPLACE PROCEDURE reset_user_sequence AS
    v_max_id NUMBER;
BEGIN
    -- Get the maximum user_id used so far
    SELECT COALESCE(MAX(user_id), 0) INTO v_max_id FROM user_table;

    -- Drop the existing sequence
    EXECUTE IMMEDIATE 'DROP SEQUENCE user_seq';

    -- Create a new sequence starting with the next higher value than the maximum ID found
    EXECUTE IMMEDIATE 'CREATE SEQUENCE user_seq START WITH ' || v_max_id;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error resetting sequence: ' || SQLERRM);
END reset_user_sequence;
/




SET SERVEROUTPUT ON;

DECLARE
    CURSOR user_cursor IS SELECT * FROM user_table;
    rec user_table%ROWTYPE;
BEGIN
    OPEN user_cursor;
    LOOP
        FETCH user_cursor INTO rec;
        EXIT WHEN user_cursor%NOTFOUND;
        -- Assuming some columns for demonstration, like user_id and user_email
        DBMS_OUTPUT.PUT_LINE('User ID: ' || rec.user_id || ', Email: ' || rec.user_email);
    END LOOP;
    CLOSE user_cursor;
END;
/


BEGIN
    reset_user_sequence;
    user_registration_pkg.register_user(
        p_nickname         => 'testuser',
        p_email            => 'testuser@example.com',
        p_password         => 'securePassword!23',
        p_payment_method   => 'Credit Card',
        p_balance          => 150.0,
        p_grade            => 'Sophomore',
        p_avatar           => NULL, -- Assuming no avatar is set
        p_register_time    => SYSDATE,
        p_status           => 1
    );
    DBMS_OUTPUT.PUT_LINE('User registered successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error registering user: ' || SQLERRM);
END;
/


BEGIN
    user_registration_pkg.register_user(
        p_nickname         => 'newuser',
        p_email            => 'existingemail@example.com',
        p_password         => 'password123',
        p_payment_method   => 'Credit Card',
        p_balance          => 100.0,
        p_grade            => 'Junior',
        p_avatar           => NULL,
        p_register_time    => SYSDATE,
        p_status           => 1
    );
    DBMS_OUTPUT.PUT_LINE('User registered successfully.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -20003 THEN
            DBMS_OUTPUT.PUT_LINE('Error registering user: Email has already been registered.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Error registering user: ' || SQLERRM);
        END IF;
END;
/


select * from user_table;