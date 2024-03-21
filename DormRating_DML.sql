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
    owner_id NUMBER PRIMARY KEY,
    owner_type VARCHAR2(255),
    contact_email VARCHAR2(255),
    contact_phone VARCHAR2(255),
    owner_info CLOB,
    status NUMBER(3)
);

-- University Table
CREATE TABLE university (
    university_id NUMBER PRIMARY KEY,
    university_name VARCHAR2(255),
    location_state VARCHAR2(255),
    location_city VARCHAR2(255),
    univ_photo BLOB,
    univ_description CLOB,
    official_website_link VARCHAR2(255),
    status NUMBER(3)
);

-- Dormitory Table
CREATE TABLE dormitory (
    dorm_id NUMBER PRIMARY KEY,
    university_id NUMBER,
    dorm_name VARCHAR2(255),
    room_score NUMBER,
    environment_score FLOAT,
    location_score FLOAT,
    facility_score FLOAT,
    dorm_photo BLOB,
    number_of_rating NUMBER,
    status NUMBER(3)
    CONSTRAINT fk_dormitory_univ FOREIGN KEY (university_id) REFERENCES university(university_id)
);

-- Foreign Key for dormitory referencing university
ALTER TABLE dormitory
ADD CONSTRAINT dorm_univ_fk
FOREIGN KEY (university_id) REFERENCES university(university_id);


-- Property Table
CREATE TABLE property (
    property_id NUMBER PRIMARY KEY,
    owner_id NUMBER,
    dorm_id NUMBER,
    room_type VARCHAR2(255),
    monthly_rent NUMBER,
    deposit NUMBER,
    min_lease_period NUMBER(3),
    max_lease_period NUMBER(3),
    available_from DATE,
    property_photo BLOB,
    description CLOB,
    status NUMBER(3),
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


-- Review Table
CREATE TABLE review (
    review_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    dorm_id NUMBER,
    comment_text CLOB,
    room_type VARCHAR2(255),
    room_overall_score NUMBER(3),
    environment_score NUMBER(3),
    location_overall_score NUMBER(3),
    facility_overall_score NUMBER(3),
    review_time TIMESTAMP,
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
    user_id NUMBER PRIMARY KEY,
    nickname VARCHAR2(255),
    user_email VARCHAR2(255),
    password VARCHAR2(255),
    payment_method VARCHAR2(255),
    balance FLOAT,
    grade VARCHAR2(255),
    avatar BLOB,
    register_time DATE,
    status NUMBER(3)
);

-- Admin_user Table
CREATE TABLE admin_user (
    admin_user_id NUMBER PRIMARY KEY,
    admin_username VARCHAR2(255),
    admin_password VARCHAR2(255),
    permission_level NUMBER(3),
    status NUMBER(3)
);

-- Lease Table
CREATE TABLE lease (
    lease_id NUMBER PRIMARY KEY,
    property_id NUMBER,
    lease_start_time DATE,
    deposit_status NUMBER(3),
    contract_file BLOB,
    status NUMBER(3),
    FOREIGN KEY (property_id) REFERENCES property(property_id)
);

--Foreign key referencing the Property table
ALTER TABLE lease
ADD CONSTRAINT lease_prop_fk
FOREIGN KEY (property_id) REFERENCES property(property_id);


-- Sublet Table
CREATE TABLE sublet (
    sublease_id NUMBER PRIMARY KEY,
    lease_id NUMBER,
    lessee_user_id NUMBER,
    lessor_user_id NUMBER,
    sublease_rent NUMBER,
    available_from DATE,
    available_end DATE,
    status NUMBER(3),
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
    user_lease_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    lease_id NUMBER,
    lease_status NUMBER(3),
    FOREIGN KEY (user_id) REFERENCES user_table(user_id)
    FOREIGN KEY (lease_id) REFERENCES lease(lease_id),
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
    coupon_id NUMBER PRIMARY KEY,
    description CLOB,
    user_id NUMBER,
    effective_time TIMESTAMP,
    expire_time TIMESTAMP,
    status NUMBER(3),
    FOREIGN KEY (user_id) REFERENCES user_table(user_id)
);

--Foreign key referencing the User Table
ALTER TABLE coupon
ADD CONSTRAINT coup_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);


-- Order Table (renamed to avoid reserved keyword)
CREATE TABLE order_table (
    order_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    lease_id NUMBER,
    coupon_id NUMBER,
    amount_payable FLOAT,
    amount_paid FLOAT,
    amount_discount FLOAT,
    late_payment_fee FLOAT,
    due TIMESTAMP,
    generate_time DATE,
    payment_time DATE,
    status NUMBER(3),
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
CREATE TABLE comment (
    comment_id NUMBER PRIMARY KEY,
    user_id NUMBER,
    university_id NUMBER,
    comment_content CLOB,
    number_of_upvote NUMBER,
    comment_time TIMESTAMP,
    status NUMBER(3),
    FOREIGN KEY (user_id) REFERENCES user_table(user_id),
    CONSTRAINT fk_comment_univ FOREIGN KEY (university_id) REFERENCES university(university_id)
);

--two foreign keys; one referencing the User Table, and the other referencing the University table
ALTER TABLE comment
ADD CONSTRAINT comm_user_fk
FOREIGN KEY (user_id) REFERENCES user_table(user_id);

ALTER TABLE comment
ADD CONSTRAINT comm_univ_fk
FOREIGN KEY (university_id) REFERENCES university(university_id);



