-- calculate lease revenue
CREATE OR REPLACE FUNCTION CalculateLeaseRevenue(p_lease_id NUMBER)
RETURN NUMBER
IS
    total_revenue NUMBER;
BEGIN
    SELECT (lease_period * monthly_rent) + additional_charges INTO total_revenue
    FROM lease
    WHERE lease_id = p_lease_id;
    RETURN total_revenue;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;



-- Trigger to Handle Lease Expiry
CREATE OR REPLACE TRIGGER LeaseEndTrigger
AFTER UPDATE OF lease_end_date ON lease
FOR EACH ROW
WHEN (NEW.lease_end_date < SYSDATE AND NEW.status = 'Active')
BEGIN
    LeaseManagement.ProcessLeaseEnd(:NEW.lease_id);
END;


-- tored Procedure to Update Property and Financial Summary
CREATE OR REPLACE PROCEDURE ProcessLeaseEnd(p_lease_id NUMBER)
IS
    revenue_generated NUMBER;
BEGIN
    -- Calculate the total revenue generated from the lease
    revenue_generated := CalculateLeaseRevenue(p_lease_id);

    -- Update the status of the property to 'Available'
    UPDATE property
    SET status = 'Available'
    WHERE property_id = (SELECT property_id FROM lease WHERE lease_id = p_lease_id);

    -- Insert into financial summary table
    INSERT INTO financial_summary (lease_id, revenue)
    VALUES (p_lease_id, revenue_generated);

    -- Optionally, update lease status if needed
    UPDATE lease
    SET status = 'Completed'
    WHERE lease_id = p_lease_id;
END;


-- Package for Lease Management
CREATE OR REPLACE PACKAGE LeaseManagement IS
    FUNCTION CalculateLeaseRevenue(p_lease_id NUMBER) RETURN NUMBER;
    PROCEDURE ProcessLeaseEnd(p_lease_id NUMBER);
END LeaseManagement;

CREATE OR REPLACE PACKAGE BODY LeaseManagement IS
    FUNCTION CalculateLeaseRevenue(p_lease_id NUMBER) RETURN NUMBER IS
        total_revenue NUMBER;
    BEGIN
        SELECT (lease_period * monthly_rent) + additional_charges INTO total_revenue
        FROM lease
        WHERE lease_id = p_lease_id;
        RETURN total_revenue;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END CalculateLeaseRevenue;

    PROCEDURE ProcessLeaseEnd(p_lease_id NUMBER) IS
        revenue_generated NUMBER;
    BEGIN
        -- Calculate total revenue generated from the lease
        revenue_generated := CalculateLeaseRevenue(p_lease_id);

        -- Update the status of the property to 'Available'
        UPDATE property
        SET status = 'Available'
        WHERE property_id = (SELECT property_id FROM lease WHERE lease_id = p_lease_id);

        -- Insert into financial summary table
        INSERT INTO financial_summary (lease_id, revenue)
        VALUES (p_lease_id, revenue_generated);

        -- Optionally, update lease status if needed
        UPDATE lease
        SET status = 'Completed'
        WHERE lease_id = p_lease_id;
    END ProcessLeaseEnd;
END LeaseManagement;
