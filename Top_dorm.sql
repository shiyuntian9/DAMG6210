BEGIN EXECUTE IMMEDIATE 'DROP TABLE TOP_DORMITORIES CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/


--calculate top 5 dorm
CREATE TABLE TOP_DORMITORIES (
    dorm_id NUMBER,
    total_score NUMBER,
    rank NUMBER
);

--Function: Calculate the total score
CREATE OR REPLACE FUNCTION CalculateTotalScore(p_dorm_id NUMBER) RETURN NUMBER IS
    total_score NUMBER;
BEGIN
    SELECT SUM(room_score + environment_score + location_score + facility_score) INTO total_score
    FROM DORMITORY
    WHERE dorm_id = p_dorm_id;
    RETURN total_score;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;




--Stored Procedure: Update Top 5 Dorm Rooms
CREATE OR REPLACE PROCEDURE UpdateTopDormitories IS
BEGIN
    EXECUTE IMMEDIATE 'TRUNCATE TABLE TOP_DORMITORIES';

    INSERT INTO TOP_DORMITORIES (dorm_id, total_score, rank)
    SELECT dorm_id, total_score, ROWNUM AS rank
    FROM (
        SELECT dorm_id, CalculateTotalScore(dorm_id) AS total_score
        FROM DORMITORY
        ORDER BY total_score DESC
    )
    WHERE ROWNUM <= 5;
END;


--Trigger: update the top five after the dorm room table is updated with ratings
CREATE OR REPLACE TRIGGER UpdateTopDormsTrigger
AFTER UPDATE OF room_score, environment_score, location_score, facility_score ON DORMITORY
FOR EACH ROW
BEGIN
    UpdateTopDormitories;
END;


-- Package Specification
CREATE OR REPLACE PACKAGE DormitoryManagement AS
    FUNCTION CalculateTotalScore(p_dorm_id NUMBER) RETURN NUMBER;
    PROCEDURE UpdateTopDormitories;
END DormitoryManagement;

-- Package Body
CREATE OR REPLACE PACKAGE BODY DormitoryManagement AS
    FUNCTION CalculateTotalScore(p_dorm_id NUMBER) RETURN NUMBER IS
        total_score NUMBER;
    BEGIN
        SELECT SUM(room_score + environment_score + location_score + facility_score) INTO total_score
        FROM DORMITORY
        WHERE dorm_id = p_dorm_id;
        RETURN total_score;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;  
    END CalculateTotalScore;

    PROCEDURE UpdateTopDormitories IS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE TOP_DORMITORIES'; 
        
        INSERT INTO TOP_DORMITORIES (dorm_id, total_score, rank)
        SELECT dorm_id, CalculateTotalScore(dorm_id) AS total_score, ROWNUM AS rank
        FROM (
            SELECT dorm_id, CalculateTotalScore(dorm_id) AS total_score
            FROM DORMITORY
            ORDER BY total_score DESC
        ) WHERE ROWNUM <= 5;
    END UpdateTopDormitories;
END DormitoryManagement;




INSERT INTO dormitory (dorm_id, university_id, dorm_name, room_score, environment_score, location_score, facility_score, dorm_photo, number_of_rating, status)
VALUES (8, 7, 'Dorm H', 5, 3, 3, 5, EMPTY_BLOB(), 19, 1);
INSERT INTO dormitory (dorm_id, university_id, dorm_name, room_score, environment_score, location_score, facility_score, dorm_photo, number_of_rating, status)
VALUES (9, 7, 'Dorm I', 5, 4, 3.5, 5, EMPTY_BLOB(), 13, 1);
INSERT INTO dormitory (dorm_id, university_id, dorm_name, room_score, environment_score, location_score, facility_score, dorm_photo, number_of_rating, status)
VALUES (10, 7, 'Dorm I', 2, 4, 3.5, 5, EMPTY_BLOB(), 12, 1);
INSERT INTO dormitory (dorm_id, university_id, dorm_name, room_score, environment_score, location_score, facility_score, dorm_photo, number_of_rating, status)
VALUES (11, 6, 'Dorm I', 3, 4, 3.5, 5, EMPTY_BLOB(), 16, 1);

EXEC UpdateTopDormitories;

SELECT dorm_id, CalculateTotalScore(dorm_id) AS total_score FROM DORMITORY;



SELECT * FROM TOP_DORMITORIES;




