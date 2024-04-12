--1.Update Room Scores in the Dormitory Table
--This trigger automatically updates the average room score in the dormitory table whenever a new review is inserted.
--1.Update Room Scores in the Dormitory Table
CREATE OR REPLACE TRIGGER trg_update_room_score
AFTER INSERT ON review
FOR EACH ROW
BEGIN
    UPDATE dormitory
    SET room_score = (SELECT AVG(room_overall_score) FROM review WHERE dorm_id = :NEW.dorm_id)
    WHERE dorm_id = :NEW.dorm_id;
END;
/


--2.Check Room Availability on Lease Creation
--This trigger ensures that a property cannot be leased if it is not available from the current date onwards.
CREATE OR REPLACE TRIGGER trg_check_room_availability
BEFORE INSERT ON lease
FOR EACH ROW
DECLARE
    v_available_from DATE;
BEGIN
    SELECT available_from INTO v_available_from FROM property WHERE property_id = :NEW.property_id;
    IF v_available_from > SYSDATE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Property is not available for lease yet.');
    END IF;
END;
/

--3.Enforce Maximum Lease Period
--This trigger prevents the creation of a lease that exceeds the maximum lease period defined for a property.
CREATE OR REPLACE TRIGGER trg_enforce_lease_period
BEFORE INSERT ON lease
FOR EACH ROW
DECLARE
    v_max_period NUMBER;
BEGIN
    SELECT max_lease_period INTO v_max_period FROM property WHERE property_id = :NEW.property_id;
    IF MONTHS_BETWEEN(:NEW.lease_start_time, SYSDATE) > v_max_period THEN
        RAISE_APPLICATION_ERROR(-20002, 'Lease period exceeds maximum allowed duration.');
    END IF;
END;
/


--4.Validate New User Email
--This trigger ensures that the email address for a new user is unique and not already registered in the system.
CREATE OR REPLACE TRIGGER trg_validate_user_email
BEFORE INSERT ON user_table
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM user_table WHERE user_email = :NEW.user_email;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Email already registered.');
    END IF;
END;
/


--5. Auto-Calculate Lease End Date Trigger
--This trigger will automatically calculate and set the lease end date when a new lease is created, based on the lease start date and the maximum lease period specified for the property. This helps ensure that all lease records are consistently maintained with accurate end dates.
DECLARE
    col_exists NUMBER;
BEGIN
    -- Check if the column already exists
    SELECT COUNT(*) INTO col_exists
    FROM user_tab_cols
    WHERE table_name = 'LEASE' AND column_name = 'LEASE_END_TIME';

    -- If the column does not exist, add it
    IF col_exists = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE lease ADD (lease_end_time DATE)';
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE; -- Re-raise any unexpected exceptions
END;
/
