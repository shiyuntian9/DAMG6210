
--1. UserAccountView
CREATE VIEW UserAccountView AS
SELECT user_id, nickname, user_email, password, status
FROM user_table;

--2. UserProfileView
CREATE VIEW UserProfileView AS
SELECT user_id, nickname, user_email, grade, register_time
FROM user_table;

--3. DormitoryListView: Lists all dormitories with basic details.
CREATE VIEW DormitoryListView AS
SELECT d.dorm_id, d.dorm_name, u.university_name, d.location_score, d.number_of_rating
FROM dormitory d
JOIN university u ON d.university_id = u.university_id;

--4. DormReviewsView
CREATE VIEW DormReviewsView AS
SELECT dorm_id, AVG(room_overall_score) AS avg_room_score, AVG(environment_score) AS avg_env_score, AVG(location_overall_score) AS avg_loc_score, AVG(facility_overall_score) AS avg_fac_score, COUNT(review_id) AS number_of_reviews
FROM review
GROUP BY dorm_id;

--5. DormitoryDetailsView
CREATE VIEW DormitoryDetailsView AS
SELECT d.dorm_id, d.dorm_name, p.room_type, p.monthly_rent, p.deposit, p.description
FROM dormitory d
JOIN property p ON d.dorm_id = p.dorm_id;

--6. UserLeasesView
CREATE VIEW UserLeasesView AS
SELECT ul.user_id, l.lease_id, l.lease_start_time, l.deposit_status, l.status
FROM user_lease ul
JOIN lease l ON ul.lease_id = l.lease_id;


--7. PaymentHistoryView
CREATE VIEW PaymentHistoryView AS
SELECT o.user_id, o.amount_payable, o.amount_paid, o.due, o.payment_time, o.status
FROM order_table o;

--8. SubletListView
CREATE VIEW SubletListView AS
SELECT s.sublease_id, s.lease_id, s.lessee_user_id, s.lessor_user_id, s.sublease_rent, s.available_from, s.available_end, s.status
FROM sublet s;


--9. AdminDashboardView
CREATE VIEW AdminDashboardView AS
SELECT (SELECT COUNT(*) FROM user_table) AS total_users, (SELECT COUNT(*) FROM review WHERE status = 'flagged') AS flagged_reviews, (SELECT COUNT(*) FROM order_table) AS total_orders
FROM dual;


--10.Number of dorms per university
CREATE VIEW university_dorm_count AS
SELECT university_id, COUNT(dorm_id) AS dorm_count
FROM dormitory
GROUP BY university_id;

--11.Dorm Ratings Overview: Shows the name of each dorm and the average of all its ratings.
CREATE VIEW dormitory_score_overview AS
SELECT dorm_name,
       (room_score + environment_score + location_score + facility_score) / 4 AS average_score
FROM dormitory;


--12.Ranked Dorm Environment Ratings: Ranks dorms based on their environment ratings.
Number of dorms per university:
CREATE VIEW dormitory_environment_rank AS
SELECT dorm_name, environment_score
FROM dormitory
ORDER BY environment_score DESC;


--13.Most Popular Dorms: displays the most popular dorms based on the number of ratings.
CREATE VIEW most_popular_dormitories AS
SELECT dorm_name, number_of_rating
FROM dormitory
ORDER BY number_of_rating DESC;

--14.Dorms with Location Ratings Above a Criterion: displays dorms with location ratings above a specific value.
CREATE VIEW dormitories_high_location_score AS
SELECT dorm_name, location_score
FROM dormitory
WHERE location_score > 4; -- max:5








