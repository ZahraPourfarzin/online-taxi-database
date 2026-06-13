-- PASSENGER DASHBOARD--

USE ProjectDB
GO

-- ثبت نام مسافران
/* INSERT INTO Passenger (full_name, phone_number, email, wallet_balance)
VALUES
(N'امیر محمدی', N'09121112233', N'amir.mohammadi@example.com', 150000.00),
(N'سارا کریمی', N'09124445566', N'sara.karimi@example.com', 75000.00),
(N'رضا حسینی', N'09357778899', N'reza.hosseini@example.com', 0.00);
*/
-- مانند بخش نقدار دهی اولیه ثبت می شود 


--احراز هویت
SELECT
    passenger_id,
    full_name,
    phone_number,
    email,
    wallet_balance
	registration_date
FROM
    Passenger
WHERE
    phone_number = N'09357778899'
    AND email = N'reza.hosseini@example.com';
	-- فرض: نام کاربری همان شماره تلفن همراه و رمز عبور ایمیل است.


-- درخواست سفر
INSERT INTO Trip (passenger_id, origin_city_id, destination_city_id, origin_address, destination_address, trip_type, status)
VALUES (1, 1, 1, N'خیابان انقلاب، دانشگاه تهران', N'خیابان ولیعصر، پارک ساعی', N'درون شهری', 'pending');

INSERT INTO Trip (passenger_id, origin_city_id, destination_city_id, origin_address, destination_address, trip_type, status, driver_id, start_time, end_time, fare)
VALUES (1, 1, 2, N'تهران، میدان آزادی', N'اصفهان، میدان نقش جهان', N'برون شهری', 'completed', 1, GETDATE(), DATEADD(hour, 4, GETDATE()), 350000.00);

INSERT INTO Trip (passenger_id, origin_city_id, destination_city_id, origin_address, destination_address, trip_type, status)
VALUES (2, 1, 1, N'سعادت آباد، میدان کاج', N'شهرک غرب، میدان صنعت', N'درون شهری', 'pending');

INSERT INTO Trip (passenger_id, origin_city_id, destination_city_id, origin_address, destination_address, trip_type, status, driver_id, start_time, end_time, fare)
VALUES (2, 1, 1, N'مرکز خرید کوروش', N'بام لند', N'درون شهری', 'completed', 2, DATEADD(minute, -30, GETDATE()), GETDATE(), 80000.00);

INSERT INTO Trip (passenger_id, origin_city_id, destination_city_id, origin_address, destination_address, trip_type, status, driver_id, start_time, end_time, fare)
VALUES (1, 1, 1, N'خیابان فرشته', N'تجریش', N'درون شهری', 'completed', 1, DATEADD(hour, -1, GETDATE()), GETDATE(), 120000.00);


-- لغو درخواست سفر
UPDATE Trip
SET status = 'cancelled_by_passenger'
WHERE trip_id = 1 AND passenger_id = 1 AND status IN ('pending', 'accepted');


--ثبت وضعیت سفر
INSERT INTO TripHistory (trip_id, old_status, new_status, notes)
VALUES (4, (SELECT status FROM Trip WHERE trip_id = 4), 'on_trip_traffic', N'ترافیک سنگین در مسیر بازگشت');
UPDATE Trip
SET status = 'on_trip_traffic'
WHERE trip_id = 4;


-- پرداخت
INSERT INTO Transactions (trip_id, passenger_id, transaction_type, amount, payment_status, discount_code_id)
VALUES (2, 1, N'الکترونیکی', 350000.00, N'موفق', NULL);
INSERT INTO Transactions (trip_id, passenger_id, transaction_type, amount, payment_status, discount_code_id)
VALUES (4, 2, N'الکترونیکی', 72000.00, N'موفق', 1);

-- ثبت نظر و امتیاز
INSERT INTO RatingAndReview (trip_id, passenger_id, driver_id, rating, review_text)
VALUES (2, 1, 1, 5, N'راننده بسیار عالی و مودب بودند، سفر بدون مشکل.');
INSERT INTO RatingAndReview (trip_id, passenger_id, driver_id, rating, review_text)
VALUES (4, 2, 2, 4, N'سفر خوب بود، کمی تاخیر داشتیم.');

