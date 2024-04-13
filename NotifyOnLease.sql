
ALTER TABLE lease
add lease_end_date Date;


UPDATE lease
SET lease_end_date = lease_start_time + INTERVAL '1' YEAR;

ALTER TABLE lease
MODIFY lease_end_date DATE NOT NULL;


DESC LEASE;


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


EXEC LeaseManagement.GetExpiringLeases;

EXEC GetExpiringLeases;
