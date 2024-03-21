BEGIN
    FOR v IN (SELECT NULL FROM USER_VIEWS WHERE VIEW_NAME = 'DORMITORY_RATINGS_V') LOOP
        EXECUTE IMMEDIATE 'DROP VIEW dormitory_ratings_v';
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if necessary
        NULL;
END;
/

BEGIN
    FOR v IN (SELECT NULL FROM USER_VIEWS WHERE VIEW_NAME = 'V_AVAILABLE_PROPERTIES') LOOP
        EXECUTE IMMEDIATE 'DROP VIEW v_available_properties';
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if necessary
        NULL;
END;
/

BEGIN
    FOR v IN (SELECT NULL FROM USER_VIEWS WHERE VIEW_NAME = 'V_LEASE_DETAILS') LOOP
        EXECUTE IMMEDIATE 'DROP VIEW v_lease_details';
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if necessary
        NULL;
END;
/

BEGIN
    FOR v IN (SELECT NULL FROM USER_VIEWS WHERE VIEW_NAME = 'V_UNIVERSITY_DORMITORY_OVERVIEW') LOOP
        EXECUTE IMMEDIATE 'DROP VIEW v_university_dormitory_overview';
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions if necessary
        NULL;
END;
/

-- the view for dormaitory ratings
/* This view would aggregate the average scores of each dormitory, providing a quick overview of their ratings. */
CREATE OR REPLACE VIEW dormitory_ratings_v AS
SELECT 
    d.dorm_id,
    d.dorm_name,
    d.university_id,
    u.university_name,
    AVG(r.room_overall_score) AS avg_room_score,
    AVG(r.environment_score) AS avg_environment_score,
    AVG(r.location_overall_score) AS avg_location_score,
    AVG(r.facility_overall_score) AS avg_facility_score,
    COUNT(r.review_id) AS number_of_reviews
FROM dormitory d
JOIN university u ON d.university_id = u.university_id
LEFT JOIN review r ON d.dorm_id = r.dorm_id
GROUP BY d.dorm_id, d.dorm_name, d.university_id, u.university_name
WITH READ ONLY;


-- the view for available properties
/* This view lists properties that are available for lease, including the type of room, 
rent, and the dormitory and university they are associated with. */
CREATE OR REPLACE VIEW v_available_properties AS
SELECT 
    p.property_id,
    p.room_type,
    p.monthly_rent,
    p.deposit,
    p.available_from,
    d.dorm_name,
    u.university_name,
    u.location_city,
    u.location_state
FROM property p
JOIN dormitory d ON p.dorm_id = d.dorm_id
JOIN university u ON d.university_id = u.university_id
WHERE p.status = 1
WITH READ ONLY;


-- the view for lease detials
CREATE OR REPLACE VIEW v_lease_details AS
SELECT 
    l.lease_id,
    p.property_id,
    p.room_type,
    u.user_id AS lessor_id,
    u.nickname AS lessor_nickname,
    ul.user_id AS lessee_id,
    (SELECT nickname FROM user_table WHERE user_id = ul.user_id) AS lessee_nickname,
    l.lease_start_time,
    l.deposit_status,
    l.status
FROM lease l
JOIN property p ON l.property_id = p.property_id
JOIN owner o ON p.owner_id = o.owner_id
JOIN user_table u ON o.owner_id = u.user_id
LEFT JOIN user_lease ul ON l.lease_id = ul.lease_id
WITH READ ONLY;


-- the lease for university dormitory overview
/* This view provides an overview of dormitories for each university, including the number of 
dormitories and the average scores of dormitories under each university. */
CREATE OR REPLACE VIEW v_university_dormitory_overview AS
SELECT 
    u.university_id,
    u.university_name,
    COUNT(d.dorm_id) AS number_of_dormitories,
    AVG(d.room_score) AS avg_room_score,
    AVG(d.environment_score) AS avg_environment_score,
    AVG(d.location_score) AS avg_location_score,
    AVG(d.facility_score) AS avg_facility_score
FROM university u
JOIN dormitory d ON u.university_id = d.university_id
GROUP BY u.university_id, u.university_name
WITH READ ONLY;

COMMIT;