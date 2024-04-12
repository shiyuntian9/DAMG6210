-- Store Procedures: registration of new user
CREATE OR REPLACE PROCEDURE RegisterUser (
    p_nickname VARCHAR2,
    p_email VARCHAR2,
    p_password VARCHAR2
) AS
BEGIN
    INSERT INTO user_table (user_id, nickname, user_email, password, register_time)
    VALUES (user_seq.NEXTVAL, p_nickname, p_email, p_password, SYSDATE);
EXCEPTION
    WHEN OTHERS THEN
        -- handle exceptions such as unique constraint violations
        RAISE;
END;
