

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



COMMIT;