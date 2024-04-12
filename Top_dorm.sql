--calculate top 5 dorm
CREATE TABLE TOP_DORMITORIES (
    dorm_id NUMBER,
    total_score NUMBER,
    rank NUMBER
);

--Function: Calculate the total score
CREATE OR REPLACE FUNCTION CalculateTotalScore(dorm_id NUMBER) RETURN NUMBER IS
    total_score NUMBER;
BEGIN
    SELECT (environment_score + location_score + facility_score) INTO total_score
    FROM DORMITORY
    WHERE dorm_id = dorm_id;
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
    SELECT dorm_id, CalculateTotalScore(dorm_id) AS total_score, ROWNUM AS rank
    FROM (
        SELECT dorm_id
        FROM DORMITORY
        ORDER BY CalculateTotalScore(dorm_id) DESC
    ) WHERE ROWNUM <= 5;
END;


--Trigger: update the top five after the dorm room table is updated with ratings
CREATE OR REPLACE TRIGGER UpdateTopDormsTrigger
AFTER UPDATE OF environment_score, location_score, facility_score ON DORMITORY
FOR EACH ROW
BEGIN
    UpdateTopDormitories;
END;


CREATE OR REPLACE PACKAGE DormitoryManagement AS
    FUNCTION CalculateTotalScore(dorm_id NUMBER) RETURN NUMBER;
    PROCEDURE UpdateTopDormitories;
END DormitoryManagement;

--Encapsulate the above functionality into a single package
CREATE OR REPLACE PACKAGE BODY DormitoryManagement AS
    FUNCTION CalculateTotalScore(dorm_id NUMBER) RETURN NUMBER IS
        total_score NUMBER;
    BEGIN
        SELECT (environment_score + location_score + facility_score) INTO total_score
        FROM DORMITORY
        WHERE dorm_id = dorm_id;
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
            SELECT dorm_id
            FROM DORMITORY
            ORDER BY CalculateTotalScore(dorm_id) DESC
        ) WHERE ROWNUM <= 5;
    END UpdateTopDormitories;
END DormitoryManagement;




