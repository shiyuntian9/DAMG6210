CREATE OR REPLACE PROCEDURE RentLease(
    p_user_id IN NUMBER,
    p_property_id IN NUMBER,
    p_lease_start IN DATE,
    p_deposit_status IN NUMBER,  -- Assume 0 for unpaid, 1 for paid
    p_contract_file IN BLOB,
    p_output OUT VARCHAR2
) AS
    v_min_lease NUMBER;
    v_max_lease NUMBER;
    v_available_from DATE;
    v_property_status NUMBER;
    v_user_status NUMBER;
    v_payment_method VARCHAR2(255);
BEGIN
    -- Check user's status and payment method
    SELECT status, payment_method INTO v_user_status, v_payment_method
    FROM user_table
    WHERE user_id = p_user_id;
    
    IF v_user_status != 1 OR v_payment_method IS NULL THEN
        p_output := 'User is not eligible to rent a lease.';
        RETURN;
    END IF;

    -- Check property's availability and lease terms
    SELECT min_lease_period, max_lease_period, available_from, status INTO v_min_lease, v_max_lease, v_available_from, v_property_status
    FROM property
    WHERE property_id = p_property_id;
    
    IF v_property_status != 1 THEN
        p_output := 'Property is not available for leasing.';
        RETURN;
    ELSIF p_lease_start < v_available_from THEN
        p_output := 'Property is not available from the desired start date.';
        RETURN;
    END IF;

    -- Insert into lease table
    INSERT INTO lease (
        lease_id,
        property_id,
        lease_start_time,
        deposit_status,
        contract_file,
        status
    ) VALUES (
        lease_seq.NEXTVAL,
        p_property_id,
        p_lease_start,
        p_deposit_status,
        p_contract_file,
        1  -- Assume status 1 means active
    );

    -- Retrieve the new lease ID for use in user_lease table
    DECLARE v_lease_id NUMBER;
    BEGIN
        SELECT lease_seq.CURRVAL INTO v_lease_id FROM DUAL;
        
        -- Link the lease to the user
        INSERT INTO user_lease (
            user_lease_id,
            user_id,
            lease_id,
            lease_status
        ) VALUES (
            user_lease_seq.NEXTVAL,  -- Assuming a sequence for user_lease_id
            p_user_id,
            v_lease_id,
            1  -- Assume status 1 means active
        );
    END;

    -- Commit the transaction
    COMMIT;
    p_output := 'Lease rented successfully!';
EXCEPTION
    WHEN OTHERS THEN
        p_output := SQLERRM;
        ROLLBACK;
END RentLease;


DECLARE
    v_output_message VARCHAR2(255);
BEGIN
    RentLease(
        p_user_id => 1,
        p_property_id => 1,
        p_lease_start => TO_DATE('2024-01-01', 'YYYY-MM-DD'),
        p_deposit_status => 1,
        p_contract_file => NULL,  -- Assuming contract file is handled elsewhere or NULL for simplicity
        p_output => v_output_message
    );
    DBMS_OUTPUT.PUT_LINE(v_output_message);
END;
