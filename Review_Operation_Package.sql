-- Package Specification
CREATE OR REPLACE PACKAGE review_pkg AS
    -- Procedure to add a review, assuming the review table and required columns exist
    PROCEDURE add_review(
        p_user_id NUMBER,
        p_dorm_id NUMBER,
        p_room_type VARCHAR2,
        p_room_score NUMBER,
        p_environment_score NUMBER,
        p_location_score NUMBER,
        p_facility_score NUMBER,
        p_comment_text CLOB,
        p_review_time TIMESTAMP
    );

    -- Function to calculate average score, assuming the review table and room_overall_score column exist
    FUNCTION calculate_average_score(p_dorm_id NUMBER) RETURN NUMBER;
END review_pkg;
/

-- Package Body
CREATE OR REPLACE PACKAGE BODY review_pkg AS

    -- Procedure to add a review into the review table.
    PROCEDURE add_review(
        p_user_id NUMBER,
        p_dorm_id NUMBER,
        p_room_type VARCHAR2,
        p_room_score NUMBER,
        p_environment_score NUMBER,
        p_location_score NUMBER,
        p_facility_score NUMBER,
        p_comment_text CLOB,
        p_review_time TIMESTAMP
    ) AS
    BEGIN
        -- Insert the new review into the review table.
        -- The associated trigger will handle updating the dormitory scores.
        INSERT INTO review (
            review_id, user_id, dorm_id, room_type, room_overall_score, environment_score, 
            location_overall_score, facility_overall_score, comment_text, review_time
        ) VALUES (
            review_seq.NEXTVAL,  -- Assuming 'review_seq' exists for ID generation
            p_user_id, 
            p_dorm_id, 
            p_room_type, 
            p_room_score, 
            p_environment_score, 
            p_location_score, 
            p_facility_score, 
            p_comment_text, 
            p_review_time
        );
    END;

    -- Function to calculate the average score for a dorm.
    -- This might be used for additional reporting or logic that requires this value outside of the score update logic handled by the trigger.
    FUNCTION calculate_average_score(p_dorm_id NUMBER) RETURN NUMBER AS
        l_average_score NUMBER;
    BEGIN
        -- Calculate the average of room_overall_score from the reviews for a specific dorm.
        SELECT AVG(room_overall_score) INTO l_average_score
        FROM review
        WHERE dorm_id = p_dorm_id;

        RETURN l_average_score;
    END;

END review_pkg;
/


SELECT increment_by FROM user_sequences WHERE sequence_name = 'REVIEW_SEQ';

SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE reset_review_sequence AS
    v_max_id NUMBER;
    v_start_id NUMBER;
BEGIN
    -- Get the maximum review_id used so far
    SELECT COALESCE(MAX(review_id), 0) + 1 INTO v_max_id FROM review;

    -- Get the next value that would be used by the sequence
    SELECT review_seq.NEXTVAL INTO v_start_id FROM dual;

    -- Compare and reset if the current sequence value is not greater than max used id
    IF v_start_id <= v_max_id THEN
        EXECUTE IMMEDIATE 'ALTER SEQUENCE review_seq RESTART WITH ' || v_max_id;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error resetting sequence: ' || SQLERRM);
END reset_review_sequence;
/



BEGIN
    review_pkg.add_review(
        p_user_id => 1,
        p_dorm_id => 4,
        p_room_type => 'Single',
        p_room_score => 8,
        p_environment_score => 7,
        p_location_score => 9,
        p_facility_score => 8,
        p_comment_text => 'Great room with excellent amenities!',
        p_review_time => SYSTIMESTAMP
    );
    DBMS_OUTPUT.PUT_LINE('Review added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding review: ' || SQLERRM);
END;
/


BEGIN
    review_pkg.add_review(
        p_user_id => 1,
        p_dorm_id => 4,
        p_room_type => 'Single',
        p_room_score => 10,
        p_environment_score => 7,
        p_location_score => 9,
        p_facility_score => 8,
        p_comment_text => 'Great room with excellent amenities!',
        p_review_time => SYSTIMESTAMP
    );
    DBMS_OUTPUT.PUT_LINE('Review added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding review: ' || SQLERRM);
END;
/

BEGIN
    review_pkg.add_review(
        p_user_id => 1,
        p_dorm_id => 4,
        p_room_type => 'Single',
        p_room_score => 9,
        p_environment_score => 7,
        p_location_score => 9,
        p_facility_score => 8,
        p_comment_text => 'Great room with excellent amenities!',
        p_review_time => SYSTIMESTAMP
    );
    DBMS_OUTPUT.PUT_LINE('Review added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding review: ' || SQLERRM);
END;
/



BEGIN
    review_pkg.add_review(
        p_user_id => 1,
        p_dorm_id => 4,
        p_room_type => 'Single',
        p_room_score => 11,
        p_environment_score => 7,
        p_location_score => 9,
        p_facility_score => 8,
        p_comment_text => 'Great room with excellent amenities!',
        p_review_time => SYSTIMESTAMP
    );
    DBMS_OUTPUT.PUT_LINE('Review added successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error adding review: ' || SQLERRM);
END;
/


SELECT *
FROM review;


SELECT *
FROM dormitory;




