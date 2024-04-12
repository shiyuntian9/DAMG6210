CREATE OR REPLACE PACKAGE rental_mgmt_pkg AS
    -- Adds a new lease to the database
    PROCEDURE add_lease(
        p_property_id NUMBER,
        p_user_id NUMBER,
        p_start_date DATE,
        p_end_date DATE,
        p_monthly_rent NUMBER
    );

    -- Checks if an apartment is available for rent
    FUNCTION is_available(p_property_id NUMBER, p_date DATE) RETURN BOOLEAN;

    -- Updates the rent for a particular lease
    PROCEDURE update_rent(p_lease_id NUMBER, p_new_rent NUMBER);

    -- Calculates the total amount due for a lease including any penalties
    FUNCTION calculate_due_amount(p_lease_id NUMBER) RETURN NUMBER;
END rental_mgmt_pkg;
/


CREATE OR REPLACE PACKAGE BODY rental_mgmt_pkg AS

    PROCEDURE add_lease(
        p_property_id NUMBER,
        p_user_id NUMBER,
        p_start_date DATE,
        p_end_date DATE,
        p_monthly_rent NUMBER
    ) AS
    BEGIN
        INSERT INTO lease (property_id, user_id, lease_start_time, lease_end_time, monthly_rent)
        VALUES (p_property_id, p_user_id, p_start_date, p_end_date, p_monthly_rent);
    END add_lease;

    FUNCTION is_available(p_property_id NUMBER, p_date DATE) RETURN BOOLEAN AS
        l_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO l_count
        FROM lease
        WHERE property_id = p_property_id
          AND lease_start_time <= p_date
          AND lease_end_time >= p_date;

        RETURN l_count = 0;
    END is_available;

    PROCEDURE update_rent(p_lease_id NUMBER, p_new_rent NUMBER) AS
    BEGIN
        UPDATE lease
        SET monthly_rent = p_new_rent
        WHERE lease_id = p_lease_id;
    END update_rent;

    FUNCTION calculate_due_amount(p_lease_id NUMBER) RETURN NUMBER AS
        l_total_due NUMBER;
    BEGIN
        -- Example calculation: base rent + late fees (simplified)
        SELECT monthly_rent + NVL((SELECT sum(late_fee) FROM payments WHERE lease_id = p_lease_id AND is_late = 'Y'), 0)
        INTO l_total_due
        FROM lease
        WHERE lease_id = p_lease_id;

        RETURN l_total_due;
    END calculate_due_amount;

END rental_mgmt_pkg;
/
