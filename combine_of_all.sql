BEGIN EXECUTE IMMEDIATE 'DROP TABLE owner CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE property CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE dormitory CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE university CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE review CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE user_table CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE admin_user CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE sublet CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE lease CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE user_lease CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE order_table CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE coupon CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE comment_table CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/



ALTER SESSION SET NLS_LANGUAGE=American;
ALTER SESSION SET NLS_TERRITORY=America;

-- Owner Table
CREATE TABLE owner (
    owner_id NUMBER CONSTRAINT owner_pk PRIMARY KEY,
    owner_type VARCHAR2(255),
    contact_email VARCHAR2(255) CONSTRAINT own_email_nn NOT NULL,
    contact_phone VARCHAR2(255) CONSTRAINT own_phone_nn NOT NULL,
    owner_info CLOB,
    status NUMBER(3) CONSTRAINT own_stat_nn NOT NULL
);



-- University Table
CREATE TABLE university (
    university_id NUMBER CONSTRAINT univ_pk PRIMARY KEY,
    university_name VARCHAR2(255) CONSTRAINT univ_name_nn NOT NULL,
    location_state VARCHAR2(255) CONSTRAINT univ_state_nn NOT NULL,
    location_city VARCHAR2(255) CONSTRAINT univ_city_nn NOT NULL,
    univ_photo BLOB,
    univ_description CLOB,
    official_website_link VARCHAR2(255),
    status NUMBER(3) CONSTRAINT univ_stat_nn NOT NULL
);



-- Dormitory Table
CREATE TABLE dormitory (
    dorm_id NUMBER CONSTRAINT dorm_pk PRIMARY KEY,
    university_id NUMBER NOT NULL,
    dorm_name VARCHAR2(255) CONSTRAINT dorm_name_nn NOT NULL,
    room_score NUMBER CONSTRAINT dorm_rscore_nn NOT NULL,
    environment_score FLOAT CONSTRAINT dorm_escore_nn NOT NULL,
    location_score FLOAT CONSTRAINT dorm_lscore_nn NOT NULL,
    facility_score FLOAT CONSTRAINT dorm_fscore_nn NOT NULL,
    dorm_photo BLOB,
    number_of_rating NUMBER,
    status NUMBER(3) CONSTRAINT dorm_stat_nn NOT NULL,
    CONSTRAINT fk_dormitory_univ FOREIGN KEY (university_id) REFERENCES university(university_id)
);


-- Property Table
CREATE TABLE property (
    property_id NUMBER CONSTRAINT prop_pk PRIMARY KEY,
    owner_id NUMBER,
    dorm_id NUMBER,
    room_type VARCHAR2(255) CONSTRAINT prop_rtype_nn NOT NULL,
    monthly_rent NUMBER CONSTRAINT prop_mrent_nn NOT NULL,
    deposit NUMBER CONSTRAINT prop_deposit_nn NOT NULL,
    min_lease_period NUMBER(3),
    max_lease_period NUMBER(3),
    available_from DATE CONSTRAINT prop_afrom_nn NOT NULL,
    property_photo BLOB,
    description CLOB,
    status NUMBER(3) CONSTRAINT property_stauts_nn NOT NULL,
    CONSTRAINT fk_property_owner FOREIGN KEY (owner_id) REFERENCES owner(owner_id),
    CONSTRAINT fk_property_dorm FOREIGN KEY (dorm_id) REFERENCES dormitory(dorm_id)
);


-- User Table
CREATE TABLE user_table (
    user_id NUMBER CONSTRAINT user_pk PRIMARY KEY,
    nickname VARCHAR2(255),
    user_email VARCHAR2(255) CONSTRAINT usr_email_nn NOT NULL,
    password VARCHAR2(255) CONSTRAINT usr_pwd_nn NOT NULL,
    payment_method VARCHAR2(255),
    balance FLOAT,
    grade VARCHAR2(255),
    avatar BLOB,
    register_time DATE CONSTRAINT usr_rtime_nn NOT NULL,
    status NUMBER(3)
);

-- Review Table
CREATE TABLE review (
    review_id NUMBER CONSTRAINT rev_pk PRIMARY KEY,
    user_id NUMBER,
    dorm_id NUMBER,
    comment_text CLOB,
    room_type VARCHAR2(255),
    room_overall_score NUMBER(3) CONSTRAINT rev_roscore_nn NOT NULL,
    environment_score NUMBER(3),
    location_overall_score NUMBER(3),
    facility_overall_score NUMBER(3),
    review_time TIMESTAMP CONSTRAINT rev_rtime_nn NOT NULL,
    status NUMBER(3),
    FOREIGN KEY (user_id) REFERENCES user_table(user_id),
    FOREIGN KEY (dorm_id) REFERENCES dormitory(dorm_id)
);

-- Admin_user Table
CREATE TABLE admin_user (
    admin_user_id NUMBER CONSTRAINT admin_user_pk PRIMARY KEY,
    admin_username VARCHAR2(255) CONSTRAINT adm_usr_nn NOT NULL,
    admin_password VARCHAR2(255) CONSTRAINT adm_pwd_nn NOT NULL,
    permission_level NUMBER(3) CONSTRAINT adm_perm_lvl_nn NOT NULL,
    status NUMBER(3)
);

-- Lease Table
CREATE TABLE lease (
    lease_id NUMBER CONSTRAINT lease_pk PRIMARY KEY,
    property_id NUMBER,
    lease_start_time DATE CONSTRAINT lease_stime_nn NOT NULL,
    deposit_status NUMBER(3) CONSTRAINT lease_dstat_nn NOT NULL,
    contract_file BLOB CONSTRAINT lease_cfile_nn NOT NULL,
    status NUMBER(3) CONSTRAINT lease_stat_nn NOT NULL,
    FOREIGN KEY (property_id) REFERENCES property(property_id)
);

-- Sublet Table
CREATE TABLE sublet (
    sublease_id NUMBER CONSTRAINT sublet_pk PRIMARY KEY,
    lease_id NUMBER,
    lessee_user_id NUMBER,
    lessor_user_id NUMBER,
    sublease_rent NUMBER CONSTRAINT sublet_rent_nn NOT NULL,
    available_from DATE CONSTRAINT sublet_afrom_nn NOT NULL,
    available_end DATE CONSTRAINT sublet_aend_nn NOT NULL,
    status NUMBER(3) CONSTRAINT sublet_stat_nn NOT NULL,
    FOREIGN KEY (lease_id) REFERENCES lease(lease_id),
    FOREIGN KEY (lessee_user_id) REFERENCES user_table(user_id),
    FOREIGN KEY (lessor_user_id) REFERENCES user_table(user_id)
);


-- User_lease Table
CREATE TABLE user_lease (
    user_lease_id NUMBER CONSTRAINT user_lease_pk PRIMARY KEY,
    user_id NUMBER,
    lease_id NUMBER,
    lease_status NUMBER(3) CONSTRAINT ul_lease_stat_nn NOT NULL, 
    FOREIGN KEY (user_id) REFERENCES user_table(user_id),
    FOREIGN KEY (lease_id) REFERENCES lease(lease_id)
);



-- Coupon Table
CREATE TABLE coupon (
    coupon_id NUMBER CONSTRAINT coupon_pk PRIMARY KEY,
    description_coupon CLOB,
    user_id NUMBER,
    effective_time TIMESTAMP CONSTRAINT effct_time_nn NOT NULL,
    expire_time TIMESTAMP CONSTRAINT expr_time_nn NOT NULL,
    status NUMBER(3) CONSTRAINT coupon_stat_nn NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user_table(user_id)
);


-- Order Table (renamed to avoid reserved keyword)
CREATE TABLE order_table (
    order_id NUMBER CONSTRAINT order_pk PRIMARY KEY,
    user_id NUMBER,
    lease_id NUMBER,
    coupon_id NUMBER,
    amount_payable FLOAT CONSTRAINT ord_apay_nn NOT NULL,
    amount_paid FLOAT CONSTRAINT ord_apd_nn NOT NULL,
    amount_discount FLOAT CONSTRAINT ord_adisc_nn NOT NULL,
    late_payment_fee FLOAT CONSTRAINT ord_lpf_nn NOT NULL,
    due TIMESTAMP CONSTRAINT ord_due_nn NOT NULL,
    generate_time DATE CONSTRAINT ord_gtime_nn NOT NULL,
    payment_time DATE CONSTRAINT ord_ptime_nn NOT NULL,
    status NUMBER(3) CONSTRAINT ord_stat_nn NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user_table(user_id),
    FOREIGN KEY (lease_id) REFERENCES lease(lease_id),
    FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id)
);



-- Comment Table
CREATE TABLE comment_table (
    comment_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    university_id NUMBER,
    comment_content CLOB CONSTRAINT comm_cont_nn NOT NULL,
    number_of_upvote NUMBER CONSTRAINT comm_upvote_nn NOT NULL,
    comment_time TIMESTAMP CONSTRAINT comm_time_nn NOT NULL,
    status NUMBER(3) CONSTRAINT comm_stat_nn NOT NULL,
    FOREIGN KEY (user_id) REFERENCES user_table(user_id),
    CONSTRAINT fk_comment_univ FOREIGN KEY (university_id) REFERENCES university(university_id)
);

BEGIN
   FOR c IN (SELECT username FROM dba_users WHERE username = 'DORM_USER') LOOP
      EXECUTE IMMEDIATE 'DROP USER DORM_USER CASCADE';
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      -- ignore if user does not exist
      NULL;
END;
/

BEGIN
   FOR c IN (SELECT username FROM dba_users WHERE username = 'DORM_MANAGEMENT') LOOP
      EXECUTE IMMEDIATE 'DROP USER DORM_MANAGEMENT CASCADE';
   END LOOP;
EXCEPTION
   WHEN OTHERS THEN
      -- ignore if user does not exist
      NULL;
END;
/


--1.dorm_user
CREATE USER dorm_user IDENTIFIED BY User2023password#;

GRANT CONNECT, RESOURCE TO dorm_user;
GRANT SELECT, INSERT, UPDATE ON user_table TO dorm_user;
GRANT SELECT, INSERT, UPDATE ON user_lease TO dorm_user;
GRANT CREATE VIEW TO dorm_user;


--2.dorm_management
CREATE USER dorm_management IDENTIFIED BY Admin2023password#;

GRANT CONNECT TO dorm_management;
-- Consider granting specific privileges instead of RESOURCE, or ensure RESOURCE is acceptable in your context.
GRANT CREATE SESSION, CREATE TABLE, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TRIGGER TO dorm_management;

-- Permissions to manage 'owner' details
GRANT SELECT, INSERT, UPDATE, DELETE ON owner TO dorm_management;
-- Access to view and update university information
GRANT SELECT, UPDATE ON university TO dorm_management;
-- Full access to 'dormitory' table for management purposes
GRANT SELECT, INSERT, UPDATE, DELETE ON dormitory TO dorm_management;
-- 'property' management might require comprehensive permissions
GRANT SELECT, INSERT, UPDATE, DELETE ON property TO dorm_management;
-- Lease management permissions corrected to match user name
GRANT SELECT, UPDATE ON lease TO dorm_management;
-- Reviewing and moderating 'review' entries
GRANT SELECT, UPDATE, DELETE ON review TO dorm_management;
-- Basic access to 'user_table', primarily for viewing
GRANT SELECT ON user_table TO dorm_management;

-- Example: Granting the ability to create views if necessary
GRANT CREATE VIEW TO dorm_management;


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

BEGIN
BEGIN
INSERT INTO owner VALUES (1, 'Individual', 'owner1@example.com', '1234567891', 'Owner 1 details', 1);
INSERT INTO owner VALUES (2, 'Company', 'owner2@example.com', '1234567892', 'Owner 2 details', 1);
INSERT INTO owner VALUES (3, 'Individual', 'owner3@example.com', '1234567893', 'Owner 3 details', 1);
INSERT INTO owner VALUES (4, 'Company', 'owner4@example.com', '1234567894', 'Owner 4 details', 1);
INSERT INTO owner VALUES (5, 'Individual', 'owner5@example.com', '1234567895', 'Owner 5 details', 1);
INSERT INTO owner VALUES (6, 'Company', 'owner6@example.com', '1234567896', 'Owner 6 details', 1);
INSERT INTO owner VALUES (7, 'Individual', 'owner7@example.com', '1234567897', 'Owner 7 details', 1);

INSERT INTO university VALUES (1, 'Tech University', 'TechState', 'TechCity', EMPTY_BLOB(), 'Tech University Description', 'http://techuniversity.com', 1);
INSERT INTO university VALUES (2, 'History University', 'HistoryState', 'HistoryCity', EMPTY_BLOB(), 'History University Description', 'http://historyuniversity.com', 1);
INSERT INTO university VALUES (3, 'Science University', 'ScienceState', 'ScienceCity', EMPTY_BLOB(), 'Science University Description', 'http://scienceuniversity.com', 1);
INSERT INTO university VALUES (4, 'Arts University', 'ArtsState', 'ArtsCity', EMPTY_BLOB(), 'Arts University Description', 'http://artsuniversity.com', 1);
INSERT INTO university VALUES (5, 'Engineering University', 'EngineeringState', 'EngineeringCity', EMPTY_BLOB(), 'Engineering University Description', 'http://engineeringuniversity.com', 1);
INSERT INTO university VALUES (6, 'Medical University', 'MedicalState', 'MedicalCity', EMPTY_BLOB(), 'Medical University Description', 'http://medicaluniversity.com', 1);
INSERT INTO university VALUES (7, 'Business University', 'BusinessState', 'BusinessCity', EMPTY_BLOB(), 'Business University Description', 'http://businessuniversity.com', 1);

INSERT INTO dormitory VALUES (1, 1, 'Dorm A', 4, 4.5, 4.5, 4, EMPTY_BLOB(), 20, 1);
INSERT INTO dormitory VALUES (2, 2, 'Dorm B', 3, 3.5, 3.5, 3, EMPTY_BLOB(), 15, 1);
INSERT INTO dormitory VALUES (3, 3, 'Dorm C', 5, 5, 5, 5, EMPTY_BLOB(), 30, 1);
INSERT INTO dormitory VALUES (4, 4, 'Dorm D', 2, 2.5, 2.5, 2, EMPTY_BLOB(), 10, 1);
INSERT INTO dormitory VALUES (5, 5, 'Dorm E', 3, 3, 3, 3, EMPTY_BLOB(), 25, 1);
INSERT INTO dormitory VALUES (6, 6, 'Dorm F', 4, 4, 4, 4, EMPTY_BLOB(), 18, 1);
INSERT INTO dormitory VALUES (7, 7, 'Dorm G', 5, 4.5, 4, 4.5, EMPTY_BLOB(), 22, 1);


INSERT INTO property VALUES (1, 1, 1, 'Studio', 1200, 600, 3, 12, DATE '2023-09-01', EMPTY_BLOB(), 'Studio apartment with full kitchen and bath.', 1);
INSERT INTO property VALUES (2, 1, 2, 'Single', 1000, 500, 6, 12, DATE '2023-09-01', EMPTY_BLOB(), 'Single room, shared kitchen and living area.', 1);
INSERT INTO property VALUES (3, 2, 3, 'Double', 800, 400, 6, 12, DATE '2023-10-01', EMPTY_BLOB(), 'Double room, ideal for friends.', 1);
INSERT INTO property VALUES (4, 2, 4, 'Suite', 1500, 750, 6, 12, DATE '2023-11-01', EMPTY_BLOB(), 'Private suite, includes bedroom and study area.', 1);
INSERT INTO property VALUES (5, 3, 5, 'Single', 950, 475, 6, 12, DATE '2024-01-01', EMPTY_BLOB(), 'Cozy single room with great light.', 1);
INSERT INTO property VALUES (6, 3, 6, 'Double', 850, 425, 6, 12, DATE '2024-02-01', EMPTY_BLOB(), 'Double room, great for roommates.', 1);
INSERT INTO property VALUES (7, 4, 7, 'Studio', 1100, 550, 6, 12, DATE '2024-03-01', EMPTY_BLOB(), 'Efficient studio with modern amenities.', 1);


INSERT INTO user_table VALUES (1, 'UserOne', 'user1@example.com', 'Pass1', 'PayPal', 100.0, 'Senior', EMPTY_BLOB(), SYSDATE - 10, 1);
INSERT INTO user_table VALUES (2, 'UserTwo', 'user2@example.com', 'Pass2', 'Visa', 200.0, 'Junior', EMPTY_BLOB(), SYSDATE - 20, 1);
INSERT INTO user_table VALUES (3, 'UserThree', 'user3@example.com', 'Pass3', 'MasterCard', 300.0, 'Sophomore', EMPTY_BLOB(), SYSDATE - 30, 1);
INSERT INTO user_table VALUES (4, 'UserFour', 'user4@example.com', 'Pass4', 'Bitcoin', 400.0, 'Freshman', EMPTY_BLOB(), SYSDATE - 40, 1);
INSERT INTO user_table VALUES (5, 'UserFive', 'user5@example.com', 'Pass5', 'Cash', 500.0, 'Graduate', EMPTY_BLOB(), SYSDATE - 50, 1);
INSERT INTO user_table VALUES (6, 'UserSix', 'user6@example.com', 'Pass6', 'Ethereum', 600.0, 'Senior', EMPTY_BLOB(), SYSDATE - 60, 1);
INSERT INTO user_table VALUES (7, 'UserSeven', 'user7@example.com', 'Pass7', 'Credit Card', 700.0, 'Alumnus', EMPTY_BLOB(), SYSDATE - 70, 1);

INSERT INTO review VALUES (1, 1, 1, 'Great place to live!', 'Single', 5, 5, 5, 5, CURRENT_TIMESTAMP, 1);
INSERT INTO review VALUES (2, 2, 2, 'Needs improvement.', 'Double', 3, 2, 4, 3, CURRENT_TIMESTAMP, 1);
INSERT INTO review VALUES (3, 3, 3, 'I love the community here.', 'Single', 4, 4, 4, 4, CURRENT_TIMESTAMP, 1);
INSERT INTO review VALUES (4, 4, 4, 'Quite expensive for the quality.', 'Studio', 2, 3, 2, 2, CURRENT_TIMESTAMP, 1);
INSERT INTO review VALUES (5, 5, 5, 'Perfect location.', 'Single', 5, 5, 5, 5, CURRENT_TIMESTAMP, 1);
INSERT INTO review VALUES (6, 6, 6, 'Could be cleaner.', 'Double', 3, 2, 3, 3, CURRENT_TIMESTAMP, 1);
INSERT INTO review VALUES (7, 7, 7, 'Amazing amenities!', 'Studio', 4, 5, 4, 5, CURRENT_TIMESTAMP, 1);

INSERT INTO admin_user VALUES (1, 'AdminOne', 'SecurePass1', 1, 1);
INSERT INTO admin_user VALUES (2, 'AdminTwo', 'SecurePass2', 2, 1);
INSERT INTO admin_user VALUES (3, 'AdminThree', 'SecurePass3', 3, 1);
INSERT INTO admin_user VALUES (4, 'AdminFour', 'SecurePass4', 4, 1);
INSERT INTO admin_user VALUES (5, 'AdminFive', 'SecurePass5', 5, 1);
INSERT INTO admin_user VALUES (6, 'AdminSix', 'SecurePass6', 6, 1);
INSERT INTO admin_user VALUES (7, 'AdminSeven', 'SecurePass7', 7, 1);

INSERT INTO lease VALUES (1, 1, SYSDATE, 1, EMPTY_BLOB(), 1);
INSERT INTO lease VALUES (2, 2, SYSDATE, 1, EMPTY_BLOB(), 1);
INSERT INTO lease VALUES (3, 3, SYSDATE, 1, EMPTY_BLOB(), 1);
INSERT INTO lease VALUES (4, 4, SYSDATE, 1, EMPTY_BLOB(), 1);
INSERT INTO lease VALUES (5, 5, SYSDATE, 1, EMPTY_BLOB(), 1);
INSERT INTO lease VALUES (6, 6, SYSDATE, 1, EMPTY_BLOB(), 1);
INSERT INTO lease VALUES (7, 7, SYSDATE, 1, EMPTY_BLOB(), 1);

INSERT INTO sublet VALUES (1, 1, 1, 2, 500, SYSDATE - 30, SYSDATE + 180, 1);
INSERT INTO sublet VALUES (2, 2, 3, 4, 450, SYSDATE - 20, SYSDATE + 180, 1);
INSERT INTO sublet VALUES (3, 3, 5, 6, 550, SYSDATE - 10, SYSDATE + 180, 1);
INSERT INTO sublet VALUES (4, 4, 2, 1, 600, SYSDATE - 15, SYSDATE + 180, 1);
INSERT INTO sublet VALUES (5, 5, 4, 3, 475, SYSDATE - 25, SYSDATE + 180, 1);
INSERT INTO sublet VALUES (6, 6, 6, 5, 525, SYSDATE - 5, SYSDATE + 180, 1);
INSERT INTO sublet VALUES (7, 7, 7, 7, 490, SYSDATE, SYSDATE + 180, 1);


INSERT INTO user_lease VALUES (1, 1, 7, 1);
INSERT INTO user_lease VALUES (2, 2, 6, 1);
INSERT INTO user_lease VALUES (3, 3, 5, 1);
INSERT INTO user_lease VALUES (4, 4, 3, 1);
INSERT INTO user_lease VALUES (5, 5, 4, 1);
INSERT INTO user_lease VALUES (6, 6, 2, 1);
INSERT INTO user_lease VALUES (7, 7, 1, 1);


INSERT INTO coupon VALUES (1, '10% off next payment', 1, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '30' DAY, 1);
INSERT INTO coupon VALUES (2, '20% off for 6 months lease', 2, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '30' DAY, 1);
INSERT INTO coupon VALUES (3, 'Free cleaning service', 3, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '30' DAY, 1);
INSERT INTO coupon VALUES (4, '50% off parking space', 4, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '30' DAY, 1);
INSERT INTO coupon VALUES (5, '$100 off next payment', 5, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '30' DAY, 1);
INSERT INTO coupon VALUES (6, 'Free gym membership', 6, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '30' DAY, 1);
INSERT INTO coupon VALUES (7, '25% off next three payments', 7, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '30' DAY, 1);


INSERT INTO order_table VALUES (1, 1, 1, 1, 1000.00, 900.00, 100.00, 0.00, CURRENT_TIMESTAMP + INTERVAL '1' DAY, SYSDATE, SYSDATE + 1, 1);
INSERT INTO order_table VALUES (2, 2, 2, 2, 1100.00, 990.00, 110.00, 10.00, CURRENT_TIMESTAMP + INTERVAL '2' DAY, SYSDATE - 5, SYSDATE + 2, 1);
INSERT INTO order_table VALUES (3, 3, 3, NULL, 950.00, 950.00, 0.00, 0.00, CURRENT_TIMESTAMP + INTERVAL '3' DAY, SYSDATE - 10, SYSDATE + 3, 1);
INSERT INTO order_table VALUES (4, 4, 4, NULL, 1200.00, 1080.00, 120.00, 20.00, CURRENT_TIMESTAMP + INTERVAL '4' DAY, SYSDATE - 15, SYSDATE + 4, 1);
INSERT INTO order_table VALUES (5, 5, 5, 3, 800.00, 720.00, 80.00, 5.00, CURRENT_TIMESTAMP + INTERVAL '5' DAY, SYSDATE - 20, SYSDATE + 5, 1);
INSERT INTO order_table VALUES (6, 6, 6, 4, 1000.00, 850.00, 150.00, 25.00, CURRENT_TIMESTAMP + INTERVAL '6' DAY, SYSDATE - 25, SYSDATE + 6, 1);
INSERT INTO order_table VALUES (7, 7, 7, 5, 1050.00, 892.50, 157.50, 0.00, CURRENT_TIMESTAMP + INTERVAL '7' DAY, SYSDATE - 30, SYSDATE + 7, 1);


INSERT INTO comment_table VALUES (1, 1, 1, 'Great university with lots of resources.', 15, CURRENT_TIMESTAMP, 1);
INSERT INTO comment_table VALUES (2, 2, 1, 'Could use more study spaces.', 8, CURRENT_TIMESTAMP, 1);
INSERT INTO comment_table VALUES (3, 3, 2, 'Excellent faculty in the engineering department.', 25, CURRENT_TIMESTAMP, 1);
INSERT INTO comment_table VALUES (4, 4, 2, 'Library is well equipped but often crowded.', 12, CURRENT_TIMESTAMP, 1);
INSERT INTO comment_table VALUES (5, 5, 3, 'Campus food options are diverse and delicious.', 20, CURRENT_TIMESTAMP, 1);
INSERT INTO comment_table VALUES (6, 6, 3, 'Parking can be a challenge during peak hours.', 7, CURRENT_TIMESTAMP, 1);
INSERT INTO comment_table VALUES (7, 7, 4, 'The new student center is a great addition to campus life.', 30, CURRENT_TIMESTAMP, 1);

EXCEPTION WHEN DUP_VAL_ON_INDEX THEN
    NULL; -- Ignore the error and continue
END;
END;
/


COMMIT;

