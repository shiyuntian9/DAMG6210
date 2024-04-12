-- package
CREATE OR REPLACE PACKAGE BODY UserManagement AS
    PROCEDURE RegisterUser(p_nickname VARCHAR2, p_email VARCHAR2, p_password VARCHAR2) AS
    BEGIN
        INSERT INTO user_table (user_id, nickname, user_email, password, register_time)
        VALUES (user_seq.NEXTVAL, p_nickname, p_email, p_password, SYSDATE);
    END RegisterUser;

    FUNCTION GetUserDetails(p_user_id NUMBER) RETURN user_table%ROWTYPE AS
        v_user_details user_table%ROWTYPE;
    BEGIN
        SELECT *
        INTO v_user_details
        FROM user_table
        WHERE user_id = p_user_id;
        
        RETURN v_user_details;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END GetUserDetails;
END UserManagement;
