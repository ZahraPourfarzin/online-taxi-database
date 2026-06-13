--ADMIN DASHBOARD--

USE ProjectDB
GO

-- ثبت تعرفه ها
SELECT * FROM Fare;
INSERT INTO Fare (city_id, trip_type, cost_per_km, effective_date)
VALUES (1, N'درون شهری', 1800, '2025-01-01');
UPDATE Fare
SET cost_per_km = 2000
WHERE fare_id = 1;


-- فهرست متقاضیان ثبت نام به عنوان راننده و مدارک مربوطه
INSERT INTO DriverApplication (applicant_name, applicant_phone, applicant_email, documents_submitted, application_date)
VALUES (N'مریم حسنی', N'09129998877', N'maryam.hasani@example.com', N'گواهینامه، کارت ملی، بیمه، مدل خودرو: پژو 206، رنگ: آبی، پلاک: 11111111', GETDATE());

SELECT
    application_id,
    applicant_name,
    applicant_phone,
    applicant_email,
    documents_submitted,
    application_date,
    admin_decision
FROM
    DriverApplication
WHERE
    admin_decision = 'pending'
ORDER BY
    application_date ASC;


--تایید درخواست‌های متقاضیان ثبت نام
UPDATE DriverApplication
SET admin_decision = 'approved', decision_date = GETDATE(), admin_id = 1
WHERE application_id = 1; 
-- فرض: Application_ID = 1 توسط مدیر تایید شده است.


-- درج راننده تایید شده در حدول
INSERT INTO Driver (full_name, phone_number, email, license_number, approval_status, driver_status)
SELECT applicant_name, applicant_phone, applicant_email, N'LIC_APP_' + CAST(application_id AS NVARCHAR(10)), 'approved', 'inactive'
FROM DriverApplication
WHERE application_id = 1 AND admin_decision = 'approved'
AND NOT EXISTS (SELECT 1 FROM Driver WHERE phone_number = (SELECT applicant_phone FROM DriverApplication WHERE application_id = 1));

INSERT INTO Vehicle (driver_id, model, color, plate_number)
SELECT
    (SELECT driver_id FROM Driver WHERE phone_number = (SELECT applicant_phone FROM DriverApplication WHERE application_id = 1)),
    N'نامشخص', N'نامشخص', N'پلاک_نامشخص_1' 
	-- این مقادیر باید از documents_submitted استخراج شوند
FROM DriverApplication
WHERE application_id = 1 AND admin_decision = 'approved'
AND NOT EXISTS (SELECT 1 FROM Vehicle WHERE driver_id = (SELECT driver_id FROM Driver WHERE phone_number = (SELECT applicant_phone FROM DriverApplication WHERE application_id = 1)));


-- رد درخواست‌ متقاضیان ثبت نام
INSERT INTO DriverApplication (applicant_name, applicant_phone, applicant_email, documents_submitted, application_date)
VALUES (N'محمدی', N'09120000000', N'mohammadi@example.com', N'مدارک ناقص', GETDATE());

UPDATE DriverApplication
SET admin_decision = 'rejected', decision_date = GETDATE(), admin_id = 1
WHERE application_id = 2; 
-- فرض: Application_ID = 2 توسط مدیر رد شده است.


-- مشاهده تراکنش های مالی
SELECT
    Transactions.transaction_id,
    Transactions.transaction_date,
    Transactions.amount,
    Transactions.transaction_type,
    Transactions.payment_status,
    Passenger.full_name AS passenger_name,
    Driver.full_name AS driver_name,
    Trip.trip_id
FROM
    Transactions
LEFT JOIN
    Passenger ON Transactions.passenger_id = Passenger.passenger_id
LEFT JOIN
    Driver ON Transactions.driver_id = Driver.driver_id
LEFT JOIN
    Trip ON Transactions.trip_id = Trip.trip_id
ORDER BY
    Transactions.transaction_date DESC;


-- موقعیت مکانی
INSERT INTO Location (driver_id, latitude, longitude) VALUES (1, 35.715298, 51.404343);
INSERT INTO Location (driver_id, latitude, longitude) VALUES (2, 35.689252, 51.389025);
INSERT INTO Location (passenger_id, latitude, longitude) VALUES (1, 35.700000, 51.400000);

SELECT Location.driver_id, Driver.full_name, Location.latitude, Location.longitude, Location.timestamp
FROM Location 
JOIN Driver ON Location.driver_id = Driver.driver_id
WHERE Location.timestamp = (SELECT MAX(L.timestamp) FROM Location L WHERE L.driver_id = Location.driver_id)
AND Location.driver_id IS NOT NULL;

SELECT latitude, longitude, timestamp
FROM Location
WHERE driver_id = 1
ORDER BY timestamp DESC


-- گزارش مسافران:-------------------------------------------------------------

--تعداد سفر های ماهانه
SELECT
    Passenger.full_name AS passenger_name,
    FORMAT(Trip.request_time, 'yyyy-MM') AS month_year,
    COUNT(Trip.trip_id) AS number_of_trips
FROM
    Passenger
JOIN
    Trip ON Passenger.passenger_id = Trip.passenger_id
GROUP BY
    Passenger.passenger_id, Passenger.full_name, FORMAT(Trip.request_time, 'yyyy-MM')
ORDER BY
    month_year DESC, number_of_trips DESC;


--بیشترین میزان پرداخت
SELECT
    Passenger.full_name AS passenger_name,
    SUM(Transactions.amount) AS total_paid_amount
FROM
    Passenger
JOIN
    Trip ON Passenger.passenger_id = Trip.passenger_id
JOIN
    Transactions ON Trip.trip_id = Transactions.trip_id
WHERE
    Transactions.transaction_type IN (N'نقدی', N'الکترونیکی')
GROUP BY
    Passenger.passenger_id, Passenger.full_name
ORDER BY
    total_paid_amount DESC

-- گزارش رانندگان: ----------------------------------------------------------------------

--تعداد سفر
SELECT
    Driver.full_name AS driver_name,
    COUNT(CASE WHEN Trip.trip_type = N'درون شهری' THEN Trip.trip_id END) AS internal_trips,
    COUNT(CASE WHEN Trip.trip_type = N'برون شهری' THEN Trip.trip_id END) AS external_trips,
    COUNT(Trip.trip_id) AS total_trips
FROM
    Driver
LEFT JOIN
    Trip ON Driver.driver_id = Trip.driver_id
WHERE
    Trip.status = 'completed'
GROUP BY
    Driver.driver_id, Driver.full_name
ORDER BY
    total_trips DESC;

--میانگین امتیاز
SELECT
    Driver.full_name AS driver_name,
    AVG(CAST(RatingAndReview.rating AS DECIMAL(3,2))) AS average_rating -- دستور محاسبه میانگین
FROM
    Driver
JOIN
    RatingAndReview ON Driver.driver_id = RatingAndReview.driver_id
GROUP BY
    Driver.driver_id, Driver.full_name
ORDER BY
    average_rating DESC;

--گزارش مسیر سفر: -----------------------------------------------------------

-- شناسایی ساعات اوج رفت و آمد 
SELECT
    c_origin.city_name AS origin_city,
    c_dest.city_name AS destination_city,
    Trip.origin_address,
    Trip.destination_address,
    DATEPART(HOUR, Trip.request_time) AS hour_of_day,
    COUNT(Trip.trip_id) AS number_of_requests
FROM
    Trip
JOIN
    City c_origin ON Trip.origin_city_id = c_origin.city_id
JOIN
    City c_dest ON Trip.destination_city_id = c_dest.city_id
GROUP BY
    c_origin.city_name, c_dest.city_name, Trip.origin_address, Trip.destination_address, DATEPART(HOUR, Trip.request_time)
ORDER BY
    number_of_requests DESC;

--مسیر های پرتردد
SELECT TOP 10
    c_origin.city_name AS origin_city,
    c_dest.city_name AS destination_city,
    Trip.origin_address,
    Trip.destination_address,
    Trip.trip_type,
    COUNT(Trip.trip_id) AS number_of_requests
FROM
    Trip
JOIN
    City c_origin ON Trip.origin_city_id = c_origin.city_id
JOIN
    City c_dest ON Trip.destination_city_id = c_dest.city_id
WHERE
    Trip.trip_type IN (N'درون شهری', N'برون شهری')
GROUP BY
    c_origin.city_name, c_dest.city_name, Trip.origin_address, Trip.destination_address, Trip.trip_type
ORDER BY
    number_of_requests DESC;
