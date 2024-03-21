--Login as DormRating user account and run below script
BEGIN EXECUTE IMMEDIATE 'DROP TABLE owner CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE property CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE dormitory CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE university CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE review CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE user_table CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE admin_user CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE sublet CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE lease CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE user_lease CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE order_table CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE coupon CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
BEGIN EXECUTE IMMEDIATE 'DROP TABLE comment CASCADE CONSTRAINTS'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;

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

INSERT INTO university VALUES (1, 'Tech University', 'TechState', 'TechCity', EMPTY_BLOB(), 'Leading technology university.', 'http://techuniv.edu', 1);
INSERT INTO university VALUES (2, 'History University', 'HistoryState', 'HistoryCity', EMPTY_BLOB(), 'University with a rich history.', 'http://historyuniv.edu', 1);
INSERT INTO university VALUES (3, 'Science University', 'ScienceState', 'ScienceCity', EMPTY_BLOB(), 'Top science programs and research.', 'http://scienceuniv.edu', 1);
INSERT INTO university VALUES (4, 'Arts University', 'ArtsState', 'ArtsCity', EMPTY_BLOB(), 'Renowned for arts and humanities.', 'http://artsuniv.edu', 1);
INSERT INTO university VALUES (5, 'Engineering University', 'EngState', 'EngCity', EMPTY_BLOB(), 'Excellence in engineering education.', 'http://enguniv.edu', 1);
INSERT INTO university VALUES (6, 'Medical University', 'MedState', 'MedCity', EMPTY_BLOB(), 'Premier medical research and education.', 'http://meduniv.edu', 1);
INSERT INTO university VALUES (7, 'Business University', 'BusState', 'BusCity', EMPTY_BLOB(), 'Elite business school with global reach.', 'http://busuniv.edu', 1);
INSERT INTO university VALUES (8, 'Environmental University', 'EnvState', 'EnvCity', EMPTY_BLOB(), 'Focused on environmental studies and sustainability.', 'http://envuniv.edu', 1);
INSERT INTO university VALUES (9, 'Law University', 'LawState', 'LawCity', EMPTY_BLOB(), 'Distinguished law school with notable alumni.', 'http://lawuniv.edu', 1);
INSERT INTO university VALUES (10, 'Education University', 'EduState', 'EduCity', EMPTY_BLOB(), 'Dedicated to advancing education and teaching.', 'http://eduuniv.edu', 1);



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

-- Foreign Key for dormitory referencing university
ALTER TABLE dormitory
ADD CONSTRAINT dorm_univ_fk
FOREIGN KEY (university_id) REFERENCES university(university_id);

INSERT INTO dormitory VALUES (1, 1, 'Dorm Alpha', 4, 3.5, 4.2, 4.0, EMPTY_BLOB(), 200, 1);
INSERT INTO dormitory VALUES (2, 1, 'Dorm Beta', 5, 4.5, 4.8, 4.6, EMPTY_BLOB(), 150, 1);
INSERT INTO dormitory VALUES (3, 2, 'Residence Gamma', 3, 3.2, 3.8, 3.5, EMPTY_BLOB(), 100, 1);
INSERT INTO dormitory VALUES (4, 2, 'Residence Delta', 4, 4.0, 4.2, 4.1, EMPTY_BLOB(), 180, 1);
INSERT INTO dormitory VALUES (5, 3, 'Hall Epsilon', 3.5, 3.8, 4.0, 3.9, EMPTY_BLOB(), 120, 1);
INSERT INTO dormitory VALUES (6, 3, 'Hall Zeta', 4.5, 4.3, 4.5, 4.4, EMPTY_BLOB(), 210, 1);
INSERT INTO dormitory VALUES (7, 4, 'Suite Eta', 5, 4.8, 5.0, 4.9, EMPTY_BLOB(), 95, 1);
INSERT INTO dormitory VALUES (8, 4, 'Suite Theta', 4, 3.9, 4.1, 4.0, EMPTY_BLOB(), 165, 1);
INSERT INTO dormitory VALUES (9, 5, 'Tower Iota', 4.2, 4.2, 4.3, 4.1, EMPTY_BLOB(), 140, 1);
INSERT INTO dormitory VALUES (10, 5, 'Tower Kappa', 3.8, 3.7, 4.0, 3.8, EMPTY_BLOB(), 130, 1);




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

--Two foreign keys; one referencing the Owner table, and the other referencing the Dormitory table
ALTER TABLE property
ADD CONSTRAINT prop_own_fk
FOREIGN KEY (owner_id) REFERENCES owner(owner_id);

ALTER TABLE property
ADD CONSTRAINT prop_dorm_fk
FOREIGN KEY (dorm_id) REFERENCES dormitory(dorm_id);

INSERT INTO property VALUES (1, 1, 1, 'Studio', 1200, 600, 3, 12, DATE '2023-09-01', EMPTY_BLOB(), 'Studio apartment with full kitchen and bath.', 1);
INSERT INTO property VALUES (2, 1, 2, 'Single', 1000, 500, 6, 12, DATE '2023-09-01', EMPTY_BLOB(), 'Single room, shared kitchen and living area.', 1);
INSERT INTO property VALUES (3, 2, 3, 'Double', 800, 400, 6, 12, DATE '2023-10-01', EMPTY_BLOB(), 'Double room, ideal for friends.', 1);
INSERT INTO property VALUES (4, 2, 4, 'Suite', 1500, 750, 6, 12, DATE '2023-11-01', EMPTY_BLOB(), 'Private suite, includes bedroom and study area.', 1);
INSERT INTO property VALUES (5, 3, 5, 'Single', 950, 475, 6, 12, DATE '2024-01-01', EMPTY_BLOB(), 'Cozy single room with great light.', 1);
INSERT INTO property VALUES (6, 3, 6, 'Double', 850, 425, 6, 12, DATE '2024-02-01', EMPTY_BLOB(), 'Double room, great for roommates.', 1);
INSERT INTO property VALUES (7, 4, 7, 'Studio', 1100, 550, 6, 12, DATE '2024-03-01', EMPTY_BLOB(), 'Efficient studio with modern amenities.', 1);
INSERT INTO property VALUES (8, 4, 8, 'Loft', 1600, 800, 3, 12, DATE '2024-04-01', EMPTY_BLOB(), 'Spacious loft, open floor plan.', 1);
INSERT INTO property VALUES (9, 5, 9, 'Single', 1050, 525, 6, 12, DATE '2024-05-01', EMPTY_BLOB(), 'Single room, private balcony.', 1);
INSERT INTO property VALUES (10, 5, 10, 'Double', 900, 450, 6, 12, DATE '2024-06-01', EMPTY_BLOB(), 'Double room with ensuite bathroom.', 1);


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

--Two foreign keys; one referencing the User Table, and the other referencing the Dormitory table
ALTER TABLE review
ADD CONSTRAINT rev_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);

ALTER TABLE review
ADD CONSTRAINT rev_dorm_fk
FOREIGN KEY (dorm_id) REFERENCES dormitory(dorm_id);


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


--Foreign key referencing the Property table
ALTER TABLE lease
ADD CONSTRAINT lease_prop_fk
FOREIGN KEY (property_id) REFERENCES property(property_id);


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


--Three foreign keys; referencing the Lease table, and two referencing the User Table (for lessee and lessor)
ALTER TABLE sublet
ADD CONSTRAINT sub_lease_fk
FOREIGN KEY (lease_id) REFERENCES lease(lease_id);

ALTER TABLE sublet
ADD CONSTRAINT sub_lessee_fk
FOREIGN KEY (lessee_user_id) REFERENCES user_table(user_id);

ALTER TABLE sublet
ADD CONSTRAINT sub_lessor_fk
FOREIGN KEY (lessor_user_id) REFERENCES user_table(user_id);


-- User_lease Table
CREATE TABLE user_lease (
    user_lease_id NUMBER CONSTRAINT user_lease_pk PRIMARY KEY,
    user_id NUMBER,
    lease_id NUMBER,
    lease_status NUMBER(3) CONSTRAINT ul_lease_stat_nn NOT NULL, 
    FOREIGN KEY (user_id) REFERENCES user_table(user_id),
    FOREIGN KEY (lease_id) REFERENCES lease(lease_id)
);

--Two foreign keys; one referencing the User Table, and the other referencing the Lease table
ALTER TABLE user_lease
ADD CONSTRAINT ul_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);

ALTER TABLE user_lease
ADD CONSTRAINT ul_lease_fk
FOREIGN KEY (lease_id) REFERENCES lease(lease_id);


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

--Foreign key referencing the User Table
ALTER TABLE coupon
ADD CONSTRAINT coup_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);


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


--Three foreign keys; one referencing the User Table, one referencing the Lease table, and one referencing the Coupon table
ALTER TABLE order_table
ADD CONSTRAINT ord_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);

ALTER TABLE order_table
ADD CONSTRAINT ord_lease_fk
FOREIGN KEY (lease_id) REFERENCES lease(lease_id);

ALTER TABLE order_table
ADD CONSTRAINT ord_coupon_fk
FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id);


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


--two foreign keys; one referencing the User Table, and the other referencing the University table
ALTER TABLE comment_table
ADD CONSTRAINT comm_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);

ALTER TABLE comment_table
ADD CONSTRAINT comm_univ_fk
FOREIGN KEY (university_id) REFERENCES university(university_id);



