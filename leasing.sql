-- Stored Procedure: property leasing process
CREATE OR REPLACE PROCEDURE LeaseProperty (
    p_property_id NUMBER,
    p_user_id NUMBER,
    p_start_date DATE
) AS
BEGIN
    -- Example: Check if the property is available
    -- Update the property status and create a lease record
    UPDATE property SET status = 0 WHERE property_id = p_property_id AND status = 1;
    INSERT INTO lease (lease_id, property_id, lease_start_time, status)
    VALUES (lease_seq.NEXTVAL, p_property_id, p_start_date, 1);

    -- Update user_lease table
    INSERT INTO user_lease (user_lease_id, user_id, lease_id)
    VALUES (user_lease_seq.NEXTVAL, p_user_id, lease_seq.CURRVAL);
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
