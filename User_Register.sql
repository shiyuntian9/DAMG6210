CREATE OR REPLACE PROCEDURE RegisterUser(
    p_nickname IN VARCHAR2,
    p_email IN VARCHAR2,
    p_password IN VARCHAR2,
    p_payment_method IN VARCHAR2,
    p_balance IN FLOAT,
    p_grade IN VARCHAR2,
    p_avatar IN BLOB,
    p_status IN NUMBER,
    p_output OUT VARCHAR2
) AS
    v_user_count INT;
BEGIN
    -- Check if the email already exists
    SELECT COUNT(*)
    INTO v_user_count
    FROM user_table
    WHERE user_email = p_email;

    DBMS_OUTPUT.PUT_LINE('Email count: ' || TO_CHAR(v_user_count));  -- Debug output

    IF v_user_count > 0 THEN
        -- Email already exists
        p_output := 'Email already registered. Please use a different email.';
        DBMS_OUTPUT.PUT_LINE(p_output);  -- Additional debug output
    ELSE
        -- Insert new user
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
        )
        VALUES (
            user_seq.NEXTVAL,  -- This now should work since the sequence exists
            p_nickname,
            p_email,
            p_password,
            p_payment_method,
            p_balance,
            p_grade,
            p_avatar,
            SYSDATE,
            p_status
        );
        
        -- If the insert is successful, set output message
        p_output := 'User registered successfully!';

        DBMS_OUTPUT.PUT_LINE(p_output);  -- Additional debug output
    END IF;

    -- Commit the transaction
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- If an error occurs, return the error message
        p_output := SQLERRM;
        DBMS_OUTPUT.PUT_LINE('Error: ' || p_output);  -- Error output
        -- Roll back any changes
        ROLLBACK;
END RegisterUser;


DECLARE
    v_output_message VARCHAR2(255);
BEGIN
    RegisterUser(
        p_nickname => 'NewUser',
        p_email => 'newuser@example.com',
        p_password => 'securepassword123',
        p_payment_method => 'Credit Card',
        p_balance => 0.0,
        p_grade => 'Graduate',
        p_avatar => NULL,
        p_status => 1,
        p_output => v_output_message
    );
    DBMS_OUTPUT.PUT_LINE('Output: ' || v_output_message);  -- This will show in the DBMS Output window
END;
