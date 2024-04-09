CREATE SEQUENCE audit_log_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

CREATE TABLE AUDIT_LOG (
    LOG_ID INT PRIMARY KEY,
    TABLE_NAME VARCHAR2(255),
    OPERATION_TYPE VARCHAR2(50),
    DETAILS VARCHAR2(1024),
    OPERATION_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--1. COMMENT_TABLE
CREATE OR REPLACE TRIGGER trg_audit_comment_insert
AFTER INSERT ON COMMENT_TABLE
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG(TABLE_NAME, OPERATION_TYPE, DETAILS)
    VALUES ('COMMENT_TABLE', 'INSERT', 'Comment added with ID: ' || :NEW.COMMENT_ID);
END;

--2. DORMITORY
CREATE OR REPLACE TRIGGER trg_audit_dormitory_insert
AFTER INSERT ON DORMITORY
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('DORMITORY', 'INSERT', 'New dormitory inserted with ID: ' || :NEW.dorm_id || ', Name: ' || :NEW.dorm_name || ', University ID: ' || :NEW.university_id, SYSTIMESTAMP);
END;


CREATE OR REPLACE TRIGGER trg_dormitory_update
AFTER UPDATE ON DORMITORY
FOR EACH ROW
BEGIN
    IF :NEW.room_score != :OLD.room_score THEN
        INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
        VALUES ('DORMITORY', 'UPDATE', 'Dorm ID: ' || :NEW.dorm_id || ', Room Score Updated to ' || :NEW.room_score, SYSTIMESTAMP);
    END IF;

    IF :NEW.environment_score != :OLD.environment_score THEN
        INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
        VALUES ('DORMITORY', 'UPDATE', 'Dorm ID: ' || :NEW.dorm_id || ', Environment Score Updated to ' || :NEW.environment_score, SYSTIMESTAMP);
    END IF;
END;


--3. LEASE
CREATE OR REPLACE TRIGGER trg_audit_lease_insert
AFTER INSERT ON LEASE
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('LEASE', 'INSERT', 'Lease inserted with ID: ' || :NEW.lease_id || ', Property ID: ' || :NEW.property_id || ', Lease Start Time: ' || TO_CHAR(:NEW.lease_start_time, 'DD-MON-YYYY'), SYSTIMESTAMP);
END;

--备份
CREATE TABLE LEASE_BACKUP (
    lease_id NUMBER,
    property_id NUMBER,
    lease_start_time DATE,
    deposit_status NUMBER(3),
    contract_file BLOB,
    status NUMBER(3),
    deleted_at TIMESTAMP
);

CREATE OR REPLACE TRIGGER trg_lease_delete
BEFORE DELETE ON LEASE
FOR EACH ROW
BEGIN
    INSERT INTO LEASE_BACKUP (lease_id, property_id, lease_start_time, deposit_status, contract_file, status, deleted_at)
    VALUES (:OLD.lease_id, :OLD.property_id, :OLD.lease_start_time, :OLD.deposit_status, :OLD.contract_file, :OLD.status, SYSTIMESTAMP);
END;



--4. ORDER_TABLE
CREATE OR REPLACE TRIGGER trg_order_insert_update
AFTER INSERT OR UPDATE ON ORDER_TABLE
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
        VALUES ('ORDER_TABLE', 'INSERT', 'Order inserted with ID: ' || :NEW.order_id || ', User ID: ' || :NEW.user_id || ', Amount Payable: ' || :NEW.amount_payable, SYSTIMESTAMP);
    ELSIF UPDATING THEN
        INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
        VALUES ('ORDER_TABLE', 'UPDATE', 'Order updated with ID: ' || :NEW.order_id || ', User ID: ' || :NEW.user_id || ', Amount Payable: ' || :NEW.amount_payable, SYSTIMESTAMP);
    END IF;
END;



--5. OWNER
CREATE OR REPLACE TRIGGER trg_audit_owner_insert
AFTER INSERT ON OWNER
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('OWNER', 'INSERT', 'Owner inserted with ID: ' || :NEW.owner_id || ', Contact Email: ' || :NEW.contact_email, SYSTIMESTAMP);
END;


CREATE OR REPLACE TRIGGER trg_owner_delete
BEFORE DELETE ON OWNER
FOR EACH ROW
DECLARE
    -- 用于存储相关联的数量的变量
    v_property_count NUMBER;
BEGIN
    -- 计算即将被删除的数量
    SELECT COUNT(*)
    INTO v_property_count
    FROM PROPERTY
    WHERE owner_id = :OLD.owner_id;
    
    -- 如果存在一或多个相关联的，阻止删除操作
    IF v_property_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'Cannot delete owner with ID ' || :OLD.owner_id || ' because there are associated properties.');
    END IF;
END;


--6. PROPERTY
CREATE OR REPLACE TRIGGER trg_property_insert
AFTER INSERT ON PROPERTY
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('PROPERTY', 'INSERT', 'Property inserted with ID: ' || :NEW.property_id || ', Owner ID: ' || :NEW.owner_id || ', Dorm ID: ' || NVL(TO_CHAR(:NEW.dorm_id), 'N/A') || ', Room Type: ' || :NEW.room_type || ', Monthly Rent: ' || :NEW.monthly_rent, SYSTIMESTAMP);
END;


--7. REVIEW ？
CREATE OR REPLACE TRIGGER trg_audit_review_insert
AFTER INSERT ON REVIEW
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('REVIEW', 'INSERT', 'Review inserted with ID: ' || :NEW.review_id || ', User ID: ' || :NEW.user_id || ', Dorm ID: ' || :NEW.dorm_id || ', Review Time: ' || TO_CHAR(:NEW.review_time, 'DD-MON-YYYY HH24:MI:SS'), SYSTIMESTAMP);
END;

CREATE OR REPLACE PROCEDURE UPDATE_REVIEW_STATS(dorm_id_param IN NUMBER) IS
BEGIN
    -- 示例逻辑: 假设更新评分统计
    -- 在这里添加实际的逻辑，比如根据dorm_id更新评分统计

    DBMS_OUTPUT.PUT_LINE('Updating stats for dorm ID: ' || dorm_id_param);

END;

CREATE OR REPLACE TRIGGER trg_review_update_delete
AFTER UPDATE OR DELETE ON REVIEW
FOR EACH ROW
BEGIN
    IF UPDATING THEN
        INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
        VALUES ('REVIEW', 'UPDATE', 'Review ID: ' || :OLD.review_id || ' updated. User ID: ' || :OLD.user_id || ', Dorm ID: ' || :OLD.dorm_id, SYSTIMESTAMP);
    ELSIF DELETING THEN
        INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
        VALUES ('REVIEW', 'DELETE', 'Review ID: ' || :OLD.review_id || ' deleted. User ID: ' || :OLD.user_id || ', Dorm ID: ' || :OLD.dorm_id, SYSTIMESTAMP);
    END IF;

    IF UPDATING OR DELETING THEN
        UPDATE_REVIEW_STATS(:OLD.dorm_id);
    END IF;
END;


--8. SUBLET
CREATE OR REPLACE TRIGGER trg_audit_sublet_insert
AFTER INSERT ON SUBLET
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('SUBLET', 'INSERT', 'Sublet inserted with ID: ' || :NEW.sublease_id || 
            ', Lease ID: ' || :NEW.lease_id || 
            ', Lessee User ID: ' || :NEW.lessee_user_id || 
            ', Lessor User ID: ' || :NEW.lessor_user_id || 
            ', Rent: ' || :NEW.sublease_rent || 
            ', Available From: ' || TO_CHAR(:NEW.available_from, 'DD-MON-YYYY') || 
            ', To: ' || TO_CHAR(:NEW.available_end, 'DD-MON-YYYY'), 
            SYSTIMESTAMP);
END;



--9. UNIVERSITY
CREATE OR REPLACE TRIGGER trg_audit_university_insert
AFTER INSERT ON UNIVERSITY
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('UNIVERSITY', 'INSERT', 'University inserted with ID: ' || :NEW.university_id || 
            ', Name: ' || :NEW.university_name || 
            ', State: ' || :NEW.location_state || 
            ', City: ' || :NEW.location_city, 
            SYSTIMESTAMP);
END;


CREATE OR REPLACE TRIGGER trg_university_insert_update
BEFORE INSERT OR UPDATE ON UNIVERSITY
FOR EACH ROW
DECLARE
    v_dormitory_count NUMBER;
BEGIN
    IF :NEW.location_state IS NULL OR :NEW.location_city IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'State and city must not be empty.');
    END IF;

    IF UPDATING THEN
        SELECT COUNT(*)
        INTO v_dormitory_count
        FROM DORMITORY
        WHERE university_id = :NEW.university_id;
        
        IF v_dormitory_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'At least one dormitory must be associated with the university.');
        END IF;
    END IF;
END;


--10. USER_LEASE
CREATE OR REPLACE TRIGGER trg_audit_user_lease_insert
AFTER INSERT ON USER_LEASE
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('USER_LEASE', 'INSERT', 'User Lease inserted with User Lease ID: ' || :NEW.user_lease_id || 
            ', User ID: ' || :NEW.user_id || 
            ', Lease ID: ' || :NEW.lease_id, 
            SYSTIMESTAMP);
END;



CREATE OR REPLACE TRIGGER trg_user_lease_update
AFTER UPDATE ON USER_LEASE
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('USER_LEASE', 'UPDATE', 'User Lease updated with User Lease ID: ' || :NEW.user_lease_id || 
            ', User ID: ' || :NEW.user_id || 
            ', Lease ID: ' || :NEW.lease_id || 
            ', Lease Status: ' || :NEW.lease_status, 
            SYSTIMESTAMP);
END;



--11. USER_TABLE
CREATE OR REPLACE TRIGGER trg_user_insert_audit
AFTER INSERT ON user_table
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('user_table', 'INSERT', 'User inserted with ID: ' || :NEW.user_id || ', Email: ' || :NEW.user_email || ', Register Time: ' || TO_CHAR(:NEW.register_time, 'DD-MON-YYYY'), CURRENT_TIMESTAMP);
END;


CREATE OR REPLACE TRIGGER trg_user_update_audit
AFTER UPDATE ON user_table
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('user_table', 'UPDATE', 'User updated with ID: ' || :NEW.user_id || ', Email: ' || :NEW.user_email, CURRENT_TIMESTAMP);
END;

CREATE OR REPLACE TRIGGER trg_user_delete_audit
BEFORE DELETE ON user_table
FOR EACH ROW
BEGIN
    INSERT INTO AUDIT_LOG (TABLE_NAME, OPERATION_TYPE, DETAILS, OPERATION_TIME)
    VALUES ('user_table', 'DELETE', 'User deleted with ID: ' || :OLD.user_id || ', Email: ' || :OLD.user_email, CURRENT_TIMESTAMP);
END;



