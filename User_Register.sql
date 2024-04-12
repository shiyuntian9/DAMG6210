-- Ensure the sequence for user IDs exists
CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NOMAXVALUE;

-- Creating a stored procedure for registering a new user
CREATE OR REPLACE PROCEDURE register_user (
    p_nickname           VARCHAR2,
    p_email              VARCHAR2,
    p_password           VARCHAR2,
    p_payment_method     VARCHAR2,
    p_balance            FLOAT,
    p_grade              VARCHAR2,
    p_avatar             BLOB,
    p_register_time      DATE,
    OUT p_user_id        NUMBER
) AS
    v_email_count NUMBER;
BEGIN
    -- Check if the email is already registered
    SELECT COUNT(*)
    INTO v_email_count
    FROM user_table
    WHERE user_email = p_email;

    IF v_email_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Email already registered.');
    END IF;

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
    ) VALUES (
        user_id_seq.NEXTVAL,
        p_nickname,
        p_email,
        DBMS_CRYPTO.HASH(UTL_RAW.CAST_TO_RAW(p_password), 2), -- Hashing password using SHA-1
        p_payment_method,
        p_balance,
        p_grade,
        p_avatar,
        p_register_time,
        1
    )
    RETURNING user_id INTO p_user_id;
    
    -- Commit the transaction
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle unexpected errors
        ROLLBACK;
        RAISE;
END;
