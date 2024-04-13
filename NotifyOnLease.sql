ALTER TABLE lease
add lease_end_date Date;


UPDATE lease
SET lease_end_date = lease_start_time + INTERVAL '1' YEAR;

ALTER TABLE lease
MODIFY lease_end_date DATE NOT NULL;


DESC LEASE;
DESC User_lease;


CREATE OR REPLACE FUNCTION DaysUntilExpiration(p_lease_end_date DATE) RETURN NUMBER IS
    days_left NUMBER;
BEGIN
    SELECT p_lease_end_date - SYSDATE INTO days_left FROM dual;
    RETURN days_left;
END;


CREATE OR REPLACE PROCEDURE GetExpiringLeases IS
BEGIN
    FOR r IN (
        SELECT l.lease_id, ul.user_id, l.lease_end_date
        FROM LEASE l
        JOIN USER_LEASE ul ON l.lease_id = ul.lease_id
        WHERE DaysUntilExpiration(l.lease_end_date) <= 30
          AND DaysUntilExpiration(l.lease_end_date) > 0
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('Lease ID: ' || r.lease_id || ', User ID: ' || r.user_id || ', Expiration Date: ' || TO_CHAR(r.lease_end_date, 'DD-MON-YYYY'));
    END LOOP;
END;



CREATE OR REPLACE TRIGGER NotifyOnLeaseUpdate
AFTER UPDATE OF lease_end_date ON LEASE
FOR EACH ROW
BEGIN
    IF DaysUntilExpiration(:NEW.lease_end_date) <= 30 THEN
        GetExpiringLeases;
    END IF;
END;




CREATE OR REPLACE PACKAGE LeaseManagement AS
    FUNCTION DaysUntilExpiration(p_lease_end_date DATE) RETURN NUMBER;
    PROCEDURE GetExpiringLeases;
END LeaseManagement;

CREATE OR REPLACE PACKAGE BODY LeaseManagement AS
    FUNCTION DaysUntilExpiration(p_lease_end_date DATE) RETURN NUMBER IS
        days_left NUMBER;
    BEGIN
        SELECT p_lease_end_date - SYSDATE INTO days_left FROM dual;
        RETURN days_left;
    END DaysUntilExpiration;

    PROCEDURE GetExpiringLeases IS
    BEGIN
        FOR r IN (SELECT l.lease_id, ul.user_id, l.lease_end_date
                  FROM LEASE l
                  JOIN USER_LEASE ul ON l.lease_id = ul.lease_id
                  WHERE DaysUntilExpiration(l.lease_end_date) <= 30 AND DaysUntilExpiration(l.lease_end_date) > 0)
        LOOP
            DBMS_OUTPUT.PUT_LINE('Lease ID: ' || r.lease_id || ', User ID: ' || r.user_id || ', Expiration Date: ' || TO_CHAR(r.lease_end_date, 'DD-MON-YYYY'));
        END LOOP;
    END GetExpiringLeases;
END LeaseManagement;

SET SERVEROUTPUT ON;

EXEC LeaseManagement.GetExpiringLeases;

EXEC GetExpiringLeases;


--Test
INSERT INTO lease (lease_id, property_id, lease_start_time, lease_end_date, deposit_status, contract_file, status)
VALUES (8, 2, SYSDATE - 365, SYSDATE + 29, 1, EMPTY_BLOB(), 1);  -- 即将到期

INSERT INTO lease (lease_id, property_id, lease_start_time, lease_end_date, deposit_status, contract_file, status)
VALUES (9, 4, SYSDATE - 365, SYSDATE + 45, 1, EMPTY_BLOB(), 1);  -- 不会到期

INSERT INTO lease (lease_id, property_id, lease_start_time, lease_end_date, deposit_status, contract_file, status)
VALUES (10, 7, SYSDATE - 365, SYSDATE - 1, 1, EMPTY_BLOB(), 1);   -- 已经到期


INSERT INTO user_lease (user_lease_id, user_id, lease_id, lease_status)
VALUES (8, 7, 8, 1);

INSERT INTO user_lease (user_lease_id, user_id, lease_id, lease_status)
VALUES (9, 6, 9, 1);

INSERT INTO user_lease (user_lease_id, user_id, lease_id, lease_status)
VALUES (10, 5, 10, 1);

SET SERVEROUTPUT ON;

EXEC LeaseManagement.GetExpiringLeases;

EXEC GetExpiringLeases;


