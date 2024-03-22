
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



COMMIT;