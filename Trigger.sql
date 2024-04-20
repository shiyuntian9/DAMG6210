--1.Update Room Scores in the Dormitory Table
--This trigger automatically updates the average room score in the dormitory table whenever a new review is inserted.

CREATE OR REPLACE TRIGGER trg_update_scores
FOR INSERT ON review
COMPOUND TRIGGER

    -- Type to store dorm IDs during the row-level phase
    TYPE t_dorm_ids IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    g_dorm_ids t_dorm_ids;

    AFTER EACH ROW IS
    BEGIN
        -- Collect dorm IDs from inserted reviews to ensure they are unique
        g_dorm_ids(:NEW.dorm_id) := 1;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        -- Update dormitory scores after all rows are processed
        FOR idx IN g_dorm_ids.FIRST .. g_dorm_ids.LAST LOOP
            IF g_dorm_ids.EXISTS(idx) THEN
                -- Calculate new average scores for each category
                UPDATE dormitory d
                SET room_score = (
                    SELECT AVG(room_overall_score)
                    FROM review
                    WHERE dorm_id = idx
                ),
                environment_score = (
                    SELECT AVG(environment_score)
                    FROM review
                    WHERE dorm_id = idx
                ),
                location_score = (
                    SELECT AVG(location_score)
                    FROM review
                    WHERE dorm_id = idx
                ),
                facility_score = (
                    SELECT AVG(facility_score)
                    FROM review
                    WHERE dorm_id = idx
                )
                WHERE d.dorm_id = idx;
            END IF;
        END LOOP;
    END AFTER STATEMENT;
END;
/




--2.Check Room Availability on Lease Creation
--This trigger ensures that a property cannot be leased if it is not available from the current date onwards.
CREATE OR REPLACE TRIGGER trg_check_lease_availability
BEFORE INSERT ON lease
FOR EACH ROW
DECLARE
    v_lease_end_time DATE;
BEGIN
    -- Retrieve the end date of the last lease for the property
    SELECT MAX(lease_end_time)
    INTO v_lease_end_time
    FROM lease
    WHERE property_id = :NEW.property_id;

    -- If there's a lease that ends after the new lease is set to start, raise an exception
    IF v_lease_end_time IS NOT NULL AND v_lease_end_time >= :NEW.lease_start_time THEN
        RAISE_APPLICATION_ERROR(-20002, 'The property is not available for leasing on the requested start date.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Handle any exception that was not previously caught
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        
END;
/


--3.Enforce Maximum and min Lease Period
--This trigger prevents the creation of a lease that exceeds the maximum lease period defined for a property.
CREATE OR REPLACE TRIGGER trg_check_lease_duration
BEFORE INSERT ON lease
FOR EACH ROW
DECLARE
    v_min_lease_period NUMBER;
    v_max_lease_period NUMBER;
    v_lease_duration   NUMBER;
BEGIN
    -- Retrieve the minimum and maximum lease periods for the property
    SELECT min_lease_period, max_lease_period
    INTO v_min_lease_period, v_max_lease_period
    FROM property
    WHERE property_id = :NEW.property_id;

    -- Calculate the duration of the new lease in months
    v_lease_duration := MONTHS_BETWEEN(:NEW.lease_end_time, :NEW.lease_start_time);

    -- Check if the lease duration is within the min and max lease periods
    IF v_lease_duration < v_min_lease_period OR v_lease_duration > v_max_lease_period THEN
        RAISE_APPLICATION_ERROR(-20003, 'Lease duration must be between ' || 
                                        TO_CHAR(v_min_lease_period) || ' and ' || 
                                        TO_CHAR(v_max_lease_period) || ' months.');
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


 --5.check every score not greater than 10
CREATE OR REPLACE TRIGGER trg_check_scores_before_insert
BEFORE INSERT ON review
FOR EACH ROW
BEGIN
    -- Check if any score exceeds 10
    IF :NEW.room_overall_score > 10 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Room overall score cannot exceed 10.');
    ELSIF :NEW.environment_score > 10 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Environment score cannot exceed 10.');
    ELSIF :NEW.location_overall_score > 10 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Location overall score cannot exceed 10.');
    ELSIF :NEW.facility_overall_score > 10 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Facility overall score cannot exceed 10.');
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
