--DRIVER DASHBOARD--

USE ProjectDB
Go

--ثبت نام رانندگان
/*INSERT INTO Driver (full_name, phone_number, email, license_number, driver_status, approval_status)
VALUES
(N'علی احمدی', N'09355554433', N'ali.ahmadi@example.com', N'LIC123456', 'active', 'approved'),
(N'مریم نظری', N'09191231234', N'maryam.nazari@example.com', N'LIC654321', 'active', 'approved'),
(N'جواد رضایی', N'09109876543', N'javad.rezaei@example.com', N'LIC987654', 'inactive', 'pending');
*/
-- مانند بخش مقداردهی انجام می شود


-- ثبت اطلاعات خودرو
/*INSERT INTO Vehicle (driver_id, model, color, plate_number)
VALUES
((SELECT driver_id FROM Driver WHERE phone_number = N'09355554433'), N'پژو پارس', N'سفید', N'ایران 123 ن 45'),
((SELECT driver_id FROM Driver WHERE phone_number = N'09191231234'), N'پراید', N'نقره‌ای', N'ایران 456 ع 78');
*/
-- مانند بخش مقداردهی انجام می شود.


--احراز هویت
SELECT
    Driver.driver_id,
    Driver.full_name AS driver_name,
    Driver.phone_number,
    Driver.email,
    Driver.license_number,
	Driver.driver_status,
	Driver.approval_status,
	Vehicle.model,
	Vehicle.color,
	Vehicle.plate_number
FROM
    Driver
JOIN
	Vehicle ON  (Vehicle.driver_id = Driver.driver_id)	
WHERE
    phone_number = N'09355554433'
    AND email = N'ali.ahmadi@example.com';
	-- فرض: نام کاربری همان شماره تلفن همراه و رمز عبور ایمیل است.


-- نمایش درخواست سفر های نزدیک
SELECT
	Trip.trip_id,
    Passenger.full_name AS passenger_name,
    Trip.origin_address,
    Trip.destination_address,
    Trip.request_time,
    Trip.trip_type
FROM
    Trip
JOIN
    Passenger  ON Trip.passenger_id = Passenger.passenger_id
WHERE
    Trip.status = 'pending'
ORDER BY
    Trip.request_time ASC;


--پذیرش درخواست سفر
UPDATE Trip
SET driver_id = 2, status = 'accepted'
WHERE trip_id = 3 AND status = 'pending';


-- رد درخواست سفر
UPDATE Trip
SET driver_id = NULL, status = 'pending'
WHERE trip_id = 5 AND driver_id = 1 AND status = 'accepted';


-- ثبت وضعیت سفر
UPDATE Trip
SET status = 'started', start_time = GETDATE()
WHERE trip_id = 3 AND driver_id = 2 AND status = 'accepted';
UPDATE Trip
SET status = 'on_trip'
WHERE trip_id = 3 AND driver_id = 2 AND status = 'started';
UPDATE Trip
SET status = 'completed', end_time = GETDATE()
WHERE trip_id = 3 AND driver_id = 2 AND status IN ('started', 'on_trip');

