--SAMPLE DATA INSERTION--

USE ProjectDB
GO

INSERT INTO City (city_name) 
VALUES
(N'تهران'),
(N'اصفهان'),
(N'مشهد');

-- ثبت نام مسافر
INSERT INTO Passenger (full_name, phone_number, email, wallet_balance)
VALUES
(N'امیر محمدی', N'09121112233', N'amir.mohammadi@example.com', 150000.00),
(N'سارا کریمی', N'09124445566', N'sara.karimi@example.com', 75000.00),
(N'رضا حسینی', N'09357778899', N'reza.hosseini@example.com', 0.00);

-- ثبت نام راننده
INSERT INTO Driver (full_name, phone_number, email, license_number, driver_status, approval_status)
VALUES
(N'علی احمدی', N'09355554433', N'ali.ahmadi@example.com', N'LIC123456', 'active', 'approved'),
(N'مریم نظری', N'09191231234', N'maryam.nazari@example.com', N'LIC654321', 'active', 'approved'),
(N'جواد رضایی', N'09109876543', N'javad.rezaei@example.com', N'LIC987654', 'inactive', 'pending');

-- درج اطلاعات خودرو برای رانندگان
INSERT INTO Vehicle (driver_id, model, color, plate_number)
VALUES
((SELECT driver_id FROM Driver WHERE phone_number = N'09355554433'), N'پژو پارس', N'سفید', N'ایران 123 ن 45'),
((SELECT driver_id FROM Driver WHERE phone_number = N'09191231234'), N'پراید', N'نقره‌ای', N'ایران 456 ع 78');
	--برای راننده ای که در انتظار تایید است، فعلا خوردرویی اضافه نمیکنیم

INSERT INTO DiscountCode (code, discount_percentage, expiry_date, usage_limit, is_active)
VALUES
(N'OFF10PERCENT', 10.00, '2025-12-31', 100, 1),
(N'FIRSTTRIP50', NULL, '2025-09-30', 1, 1),
(N'SPECIAL20', 20.00, '2025-07-15', 50, 1);

INSERT INTO Admin (username, password, full_name, access_level)
VALUES (N'admin_user', 'password_admin', N'مدیر سیستم', 'admin');
