-- Functions: calculate average rating for dormitories
CREATE OR REPLACE FUNCTION GetAverageRating (p_dorm_id NUMBER)
RETURN NUMBER AS
v_avg_rating NUMBER;
BEGIN
    SELECT AVG(room_overall_score)
    INTO v_avg_rating
    FROM review
    WHERE dorm_id = p_dorm_id;

    RETURN v_avg_rating;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END;
