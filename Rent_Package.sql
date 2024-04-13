CREATE OR REPLACE PACKAGE rental_mgmt_pkg AS
    PROCEDURE add_lease(
        p_property_id NUMBER,
        p_user_id NUMBER,
        p_lease_start_time DATE
    );

    FUNCTION is_available(p_property_id NUMBER, p_date DATE) RETURN BOOLEAN;

    FUNCTION calculate_due_amount(p_lease_id NUMBER) RETURN NUMBER; -- Assumes a different method to calculate due amounts
END rental_mgmt_pkg;
/

CREATE OR REPLACE PACKAGE BODY rental_mgmt_pkg AS

    PROCEDURE add_lease(
        p_property_id NUMBER,
        p_user_id NUMBER,
        p_lease_start_time DATE
    ) AS
    BEGIN
        INSERT INTO lease (
            lease_id, property_id, lease_start_time, deposit_status, contract_file, status
        ) VALUES (
            lease_seq.NEXTVAL, p_property_id, p_lease_start_time, 0, EMPTY_BLOB(), 1
        );
    END add_lease;

    FUNCTION is_available(p_property_id NUMBER, p_date DATE) RETURN BOOLEAN AS
        l_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO l_count
        FROM lease
        WHERE property_id = p_property_id
          AND lease_start_time <= p_date;
        RETURN l_count = 0;
    END is_available;

    FUNCTION calculate_due_amount(p_lease_id NUMBER) RETURN NUMBER AS
        l_total_due NUMBER;
    BEGIN
        -- As there is no monthly_rent, this function needs rethinking or removal
        l_total_due := 0; -- Placeholder logic
        RETURN l_total_due;
    END calculate_due_amount;

END rental_mgmt_pkg;
/

SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE reset_lease_sequence AS
    v_max_id NUMBER;
    v_start_id NUMBER;
BEGIN
    -- Retrieve the maximum lease_id currently in use
    SELECT COALESCE(MAX(lease_id), 0) + 1 INTO v_max_id FROM lease;

    -- Retrieve the next value of the sequence
    SELECT lease_seq.NEXTVAL INTO v_start_id FROM dual;

    -- If the next sequence value is less than or equal to the maximum used id, reset the sequence
    IF v_start_id <= v_max_id THEN
        -- Reset sequence to the next highest available number
        EXECUTE IMMEDIATE 'ALTER SEQUENCE lease_seq RESTART WITH ' || v_max_id;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions (e.g., sequence does not exist)
        DBMS_OUTPUT.PUT_LINE('Error resetting sequence: ' || SQLERRM);
END reset_lease_sequence;
/




BEGIN
    rental_mgmt_pkg.add_lease(
        p_property_id => 1, 
        p_user_id => 1, 
        p_lease_start_time => TO_DATE('2024-01-01', 'YYYY-MM-DD')
    );
END;
/

select * from lease;






