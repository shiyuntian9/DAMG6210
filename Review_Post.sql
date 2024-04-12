-- Calculate Average Scores based on reviews
CREATE OR REPLACE FUNCTION CalculateAverageScores(p_dorm_id NUMBER)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
        SELECT AVG(room_overall_score) AS avg_room_score,
               AVG(environment_score) AS avg_environment_score,
               AVG(location_overall_score) AS avg_location_score,
               AVG(facility_overall_score) AS avg_facility_score
        FROM review
        WHERE dorm_id = p_dorm_id;
    RETURN v_cursor;
END;


-- Trigger to Update Dormitory Scores
CREATE OR REPLACE TRIGGER UpdateDormitoryScores
AFTER INSERT ON review
FOR EACH ROW
WHEN (NEW.dorm_id IS NOT NULL)
BEGIN
    DormManagement.UpdateDormitoryScores(:NEW.dorm_id);
END;


-- Stored Procedure to Update Scores and Notify
CREATE OR REPLACE PROCEDURE UpdateDormitoryScores(p_dorm_id NUMBER)
IS
    v_room_score NUMBER;
    v_env_score NUMBER;
    v_loc_score NUMBER;
    v_fac_score NUMBER;
    v_cursor SYS_REFCURSOR;
BEGIN
    v_cursor := CalculateAverageScores(p_dorm_id);
    FETCH v_cursor INTO v_room_score, v_env_score, v_loc_score, v_fac_score;
    CLOSE v_cursor;

    -- Update the dormitory table with new averages
    UPDATE dormitory
    SET room_score = v_room_score,
        environment_score = v_env_score,
        location_score = v_loc_score,
        facility_score = v_fac_score
    WHERE dorm_id = p_dorm_id;

    -- Example notification logic
    IF v_room_score < 3 THEN
        INSERT INTO notification_table (dorm_id, message, notification_date)
        VALUES (p_dorm_id, 'Attention: Room score has dropped below 3.', SYSDATE);
    END IF;
END;

-- Package for dorm management
CREATE OR REPLACE PACKAGE DormManagement IS
    FUNCTION CalculateAverageScores(p_dorm_id NUMBER) RETURN SYS_REFCURSOR;
    PROCEDURE UpdateDormitoryScores(p_dorm_id NUMBER);
END DormManagement;

CREATE OR REPLACE PACKAGE BODY DormManagement IS
    FUNCTION CalculateAverageScores(p_dorm_id NUMBER) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT AVG(room_overall_score) AS avg_room_score,
                   AVG(environment_score) AS avg_environment_score,
                   AVG(location_overall_score) AS avg_location_score,
                   AVG(facility_overall_score) AS avg_facility_score
            FROM review
            WHERE dorm_id = p_dorm_id;
        RETURN v_cursor;
    END CalculateAverageScores;

    PROCEDURE UpdateDormitoryScores(p_dorm_id NUMBER) IS
        v_room_score NUMBER;
        v_env_score NUMBER;
        v_loc_score NUMBER;
        v_fac_score NUMBER;
        v_cursor SYS_REFCURSOR;
    BEGIN
        v_cursor := CalculateAverageScores(p_dorm_id);
        FETCH v_cursor INTO v_room_score, v_env_score, v_loc_score, v_fac_score;
        CLOSE v_cursor;

        UPDATE dormitory
        SET room_score = v_room_score,
            environment_score = v_env_score,
            location_score = v_loc_score,
            facility_score = v_fac_score
        WHERE dorm_id = p_dorm_id;

        IF v_room_score < 3 THEN
            INSERT INTO notification_table (dorm_id, message, notification_date)
            VALUES (p_dorm_id, 'Attention: Room score has dropped below 3.', SYSDATE);
        END IF;
    END UpdateDormitoryScores;
END DormManagement;
