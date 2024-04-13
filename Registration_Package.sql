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
    v_start_id NUMBER;
BEGIN
    -- Get the maximum user_id used so far
    SELECT COALESCE(MAX(user_id), 0) + 1 INTO v_max_id FROM user_table;

    -- Get the next value that would be used by the sequence
    SELECT user_seq.NEXTVAL INTO v_start_id FROM dual;

    -- Compare and reset if the current sequence value is not greater than max used id
    IF v_start_id <= v_max_id THEN
        -- Remove semicolon within the string
        EXECUTE IMMEDIATE 'ALTER SEQUENCE user_seq RESTART WITH ' || v_max_id;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error resetting sequence: ' || SQLERRM);
END reset_user_sequence;
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

/*
BEGIN
    reset_user_sequence;  -- Reset the sequence based on current data
    user_registration_pkg.register_user(
        p_nickname         => 'testuser2',
        p_email            => 'testuser2@example.com',
        p_password         => 'securePassword!23',
        p_payment_method   => 'Credit Card',
        p_balance          => 150.0,
        p_grade            => 'Sophomore',
        p_avatar           => NULL,
        p_register_time    => SYSDATE,
        p_status           => 1
    );
    DBMS_OUTPUT.PUT_LINE('User registered successfully.');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error registering user: ' || SQLERRM);
END;
/
*/


select * from user_table;