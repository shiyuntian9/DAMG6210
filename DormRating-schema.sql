-- Table creation scripts
-- first drop the existing tables
drop table owner;
drop table property;
drop table dormitory;
drop table university;
drop table review;
drop table user;
drop table admin_user;
drop table sublet;
drop table user_lease;
drop table lease;
drop table order;
drop table coupon;
drop table comment;


-- Owner Table
CREATE TABLE owner (
    owner_id INT PRIMARY KEY,
    owner_type VARCHAR(255),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(255),
    owner_info TEXT,
    status TINYINT
);

-- Property Table
CREATE TABLE property (
    property_id INT PRIMARY KEY,
    owner_id INT,
    dorm_id INT,
    room_type VARCHAR(255),
    monthly_rent INT,
    deposit INT,
    min_lease_period TINYINT,
    max_lease_period TINYINT,
    available_from TIMESTAMP,
    description TEXT,
    status TINYINT,
    FOREIGN KEY (owner_id) REFERENCES owner(owner_id)
    -- Assuming dorm_id is a FK, add a FK constraint when dormitory table is created
);

-- Dormitory Table
CREATE TABLE dormitory (
    dorm_id INT PRIMARY KEY,
    university_id INT,
    dorm_name VARCHAR(255),
    room_count INT,
    environment_score FLOAT,
    location_score FLOAT,
    facility_score FLOAT,
    room_price FLOAT,
    number_of_rating INT,
    status TINYINT
    -- Assuming university_id is a FK, add a FK constraint when university table is created
);

-- University Table
CREATE TABLE university (
    university_id INT PRIMARY KEY,
    university_name VARCHAR(255),
    location_name VARCHAR(255),
    website_url VARCHAR(255),
    univ_photo BLOB,
    univ_description TEXT,
    univ_history TEXT,
    official_website_link VARCHAR(255),
    status TINYINT
);

-- Review Table
CREATE TABLE review (
    review_id INT PRIMARY KEY,
    user_id INT,
    dorm_id INT,
    comment_text TEXT,
    room_type VARCHAR(255),
    room_overall_score TINYINT,
    environment_score TINYINT,
    location_overall_score TINYINT,
    facility_overall_score TINYINT,
    review_time TIMESTAMP,
    status TINYINT,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (dorm_id) REFERENCES dormitory(dorm_id)
);

-- User Table
CREATE TABLE user (
    user_id INT PRIMARY KEY,
    nickname VARCHAR(255),
    user_email VARCHAR(255),
    password VARCHAR(255),
    payment_method VARCHAR(255),
    balance FLOAT,
    grade VARCHAR(255),
    avatar BLOB,
    register_time TIMESTAMP,
    status TINYINT
);

-- Admin_user Table
CREATE TABLE admin_user (
    admin_user_id INT PRIMARY KEY,
    admin_username VARCHAR(255),
    admin_level VARCHAR(255),
    permission_level TINYINT,
    status TINYINT
);

-- Sublessee Table
CREATE TABLE sublet (
    sublease_id INT PRIMARY KEY,
    lessee_id INT,
    lessor_user_id INT,
    sublease_start TIMESTAMP,
    available_from TIMESTAMP,
    available_end TIMESTAMP,
    status TINYINT,
    FOREIGN KEY (lessee_id) REFERENCES user_lease(user_id),
    FOREIGN KEY (lessor_user_id) REFERENCES user(user_id)
);

-- User_lease Table
CREATE TABLE user_lease (
    user_lease_id INT PRIMARY KEY,
    user_id INT,
    lease_id INT,
    lease_status TINYINT,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    -- Assuming lease_id is a FK, add a FK constraint when lease table is created
);

-- Lease Table
CREATE TABLE lease (
    lease_id INT PRIMARY KEY,
    property_id INT,
    lease_start_time TIMESTAMP,
    deposit_status TINYINT,
    contract_file BLOB,
    status TINYINT,
    FOREIGN KEY (property_id) REFERENCES property(property_id)
);

-- Order Table
CREATE TABLE order (
    order_id INT PRIMARY KEY,
    user_id INT,
    lease_id INT,
    coupon_id INT,
    amount_payable FLOAT,
    amount_paid FLOAT,
    amount_discount FLOAT,
    late_payment_fee FLOAT,
    e_past_due TIMESTAMP,
    generate_time TIMESTAMP,
    payment_time TIMESTAMP,
    status TINYINT,
    FOREIGN KEY (user_id) REFERENCES user(user_id),
    FOREIGN KEY (lease_id) REFERENCES lease(lease_id),
    FOREIGN KEY (coupon_id) REFERENCES coupon(coupon_id)
);

-- Coupon Table
CREATE TABLE coupon (
    coupon_id INT PRIMARY KEY,
    description TEXT,
    user_id INT,
    effective_date TIMESTAMP,
    expire_date TIMESTAMP,
    status TINYINT,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
);

-- Comment Table
CREATE TABLE comment (
    comment_id INT PRIMARY KEY,
    user_id INT,
    content_id INT,
    XML_content TEXT,
    number_of_upvote INT,
    comment_time TIMESTAMP,
    status TINYINT,
    FOREIGN KEY (user_id) REFERENCES user(user_id)
    -- Assuming content_id is a FK, add a FK constraint when the content table is created
);


-- Sample data for owner table
INSERT INTO owner VALUES
(1, 'Individual', 'email1@example.com', '1234567890', 'Info about owner 1', 1),
(2, 'Company', 'email2@example.com', '0987654321', 'Info about owner 2', 1),
(3, 'Individual', 'email3@example.com', '1122334455', 'Info about owner 3', 1),
(4, 'Company', 'email4@example.com', '5566778899', 'Info about owner 4', 1),
(5, 'Individual', 'email5@example.com', '1231231234', 'Info about owner 5', 1);

-- Sample data for property table
-- Note: Ensure that owner_id and dorm_id have valid foreign keys before inserting the data.
INSERT INTO property VALUES
(1, 1, 1, 'Studio', 1000, 500, 6, 12, '2024-04-01 00:00:00', 'Cozy studio near campus', 1),
(2, 2, 2, '2 Bedroom', 1500, 750, 6, 12, '2024-05-01 00:00:00', 'Spacious 2 bedroom apartment', 1),
(3, 3, 3, '1 Bedroom', 1200, 600, 6, 12, '2024-06-01 00:00:00', 'Sunny 1 bedroom with view', 1),
(4, 4, 4, 'Studio', 1000, 500, 6, 12, '2024-07-01 00:00:00', 'Studio in the heart of downtown', 1),
(5, 5, 5, '3 Bedroom', 2000, 1000, 6, 12, '2024-08-01 00:00:00', 'Large 3 bedroom for families', 1);

-- Sample data for dormitory table
-- Note: Ensure that university_id has a valid foreign key before inserting the data.
INSERT INTO dormitory VALUES
(1, 1, 'Dorm A', 100, 8.5, 9.0, 8.0, 500, 200, 1),
(2, 2, 'Dorm B', 200, 7.5, 8.5, 9.0, 450, 150, 1),
(3, 3, 'Dorm C', 150, 9.0, 9.5, 8.5, 550, 250, 1),
(4, 4, 'Dorm D', 120, 8.0, 8.0, 7.5, 400, 100, 1),
(5, 5, 'Dorm E', 180, 7.0, 8.5, 8.0, 480, 170, 1);

-- Sample data for university table
INSERT INTO university VALUES
(1, 'University A', 'City A', 'www.unia.edu', NULL, 'Description A', 'History A', 'www.officialunia.edu', 1),
(2, 'University B', 'City B', 'www.unib.edu', NULL, 'Description B', 'History B', 'www.officialunib.edu', 1),
(3, 'University C', 'City C', 'www.unic.edu', NULL, 'Description C', 'History C', 'www.officialunic.edu', 1),
(4, 'University D', 'City D', 'www.unid.edu', NULL, 'Description D', 'History D', 'www.officialunid.edu', 1),
(5, 'University E', 'City E', 'www.unie.edu', NULL, 'Description E', 'History E', 'www.officialunie.edu', 1);

-- Sample data for user table
INSERT INTO user VALUES
(1, 'User1', 'user1@example.com', 'pass1', 'Credit Card', 100.00, 'A', NULL, '2024-03-01 00:00:00', 1),
(2, 'User2', 'user2@example.com', 'pass2', 'PayPal', 200.00, 'B', NULL, '2024-03-02 00:00:00', 1),
(3, 'User3', 'user3@example.com', 'pass3', 'Debit Card', 150.00, 'C', NULL, '2024-03-03 00:00:00', 1),
(4, 'User4', 'user4@example.com', 'pass4', 'Bank Transfer', 250.00, 'A+', NULL, '2024-03-04 00:00:00', 1),
(5, 'User5', 'user5@example.com', 'pass5', 'Credit Card', 300.00, 'A', NULL, '2024-03-05 00:00:00', 1);

-- Sample data for admin_user table
INSERT INTO admin_user VALUES
(1, 'Admin1', 'High', 3, 1),
(2, 'Admin2', 'Medium', 2, 1),
(3, 'Admin3', 'Low', 1, 1),
(4, 'Admin4', 'Medium', 2, 1),
(5, 'Admin5', 'High', 3, 1);

-- Sample data for sublet table
-- Note: Ensure that lessee_id and lessor_user_id have valid foreign keys before inserting the data.
INSERT INTO sublet VALUES
(1, 1, 2, '2024-09-01 00:00:00', '2024-09-01 00:00:00', '2024-12-01 00:00:00', 1),
(2, 2, 3, '2024-10-01 00:00:00', '2024-10-01 00:00:00', '2025-01-01 00:00:00', 1),
(3, 3, 4, '2024-11-01 00:00:00', '2024-11-01 00:00:00', '2025-02-01 00:00:00', 1),
(4, 4, 5, '2024-12-01 00:00:00', '2024-12-01 00:00:00', '2025-03-01 00:00:00', 1),
(5, 5, 1, '2025-01-01 00:00:00', '2025-01-01 00:00:00', '2025-04-01 00:00:00', 1);

-- Sample data for user_lease table
-- Note: Ensure that user_id and lease_id have valid foreign keys before inserting the data.
INSERT INTO user_lease VALUES
(1, 1, 1, 1),
(2, 2, 2, 1),
(3, 3, 3, 1),
(4, 4, 4, 1),
(5, 5, 5, 1);

-- Sample data for lease table
-- Note: Ensure that property_id has a valid foreign key before inserting the data.
INSERT INTO lease VALUES
(1, 1, '2024-09-01 00:00:00', 1, NULL, 1),
(2, 2, '2024-10-01 00:00:00', 1, NULL, 1),
(3, 3, '2024-11-01 00:00:00', 1, NULL, 1),
(4, 4, '2024-12-01 00:00:00', 1, NULL, 1),
(5, 5, '2025-01-01 00:00:00', 1, NULL, 1);

-- Sample data for order table
-- Note: Ensure that user_id, lease_id, and coupon_id have valid foreign keys before inserting the data.
INSERT INTO order VALUES
(1, 1, 1, 1, 950.00, 950.00, 50.00, 0, '2024-09-01 00:00:00', '2024-09-01 00:00:00', '2024-09-05 00:00:00', 1),
(2, 2, 2, 2, 1450.00, 1400.00, 50.00, 5, '2024-10-01 00:00:00', '2024-10-01 00:00:00', '2024-10-05 00:00:00', 1),
(3, 3, 3, 3, 1150.00, 1150.00, 50.00, 0, '2024-11-01 00:00:00', '2024-11-01 00:00:00', '2024-11-05 00:00:00', 1),
(4, 4, 4, 4, 950.00, 950.00, 50.00, 0, '2024-12-01 00:00:00', '2024-12-01 00:00:00', '2024-12-05 00:00:00', 1),
(5, 5, 5, 5, 1950.00, 1900.00, 50.00, 10, '2025-01-01 00:00:00', '2025-01-01 00:00:00', '2025-01-05 00:00:00', 1);

-- Sample data for coupon table
-- Note: Ensure that user_id has a valid foreign key before inserting the data.
INSERT INTO coupon VALUES
(1, 'Discount for first-time renters', 1, '2024-09-01 00:00:00', '2024-12-31 00:00:00', 1),
(2, 'Holiday special discount', 2, '2024-12-01 00:00:00', '2025-01-31 00:00:00', 1),
(3, 'Spring semester promotion', 3, '2025-01-01 00:00:00', '2025-05-31 00:00:00', 1),
(4, 'Loyalty customer appreciation', 4, '2024-10-01 00:00:00', '2025-10-31 00:00:00', 1),
(5, 'Early bird special', 5, '2024-08-01 00:00:00', '2024-09-30 00:00:00', 1);

-- Sample data for comment table
-- Note: Ensure that user_id and content_id have valid foreign keys before inserting the data.
INSERT INTO comment VALUES
(1, 1, 1, '<comment>Great place to live!</comment>', 10, '2024-03-01 00:00:00', 1),
(2, 2, 2, '<comment>Could use some more amenities.</comment>', 5, '2024-03-02 00:00:00', 1),
(3, 3, 3, '<comment>Loved the location!</comment>', 15, '2024-03-03 00:00:00', 1),
(4, 4, 4, '<comment>Too noisy at night.</comment>', 3, '2024-03-04 00:00:00', 1),
(5, 5, 5, '<comment>Amazing staff, very helpful.</comment>', 20, '2024-03-05 00:00:00', 1);
