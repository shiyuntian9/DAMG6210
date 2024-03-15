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