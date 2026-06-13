--CREATE TABLES--

DROP TABLE IF EXISTS Location;
DROP TABLE IF EXISTS RatingAndReview;
DROP TABLE IF EXISTS Transactions;
DROP TABLE IF EXISTS TripHistory;
DROP TABLE IF EXISTS Trip;
DROP TABLE IF EXISTS Vehicle;
DROP TABLE IF EXISTS DriverApplication;
DROP TABLE IF EXISTS Fare;
DROP TABLE IF EXISTS Route;
DROP TABLE IF EXISTS Passenger;
DROP TABLE IF EXISTS Driver;
DROP TABLE IF EXISTS DiscountCode;
DROP TABLE IF EXISTS Admin;
DROP TABLE IF EXISTS City;
-------------------------------------------------------------------------------------------------------------

CREATE TABLE City (
    city_id INT PRIMARY KEY IDENTITY(1,1),
    city_name NVARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Passenger (
    passenger_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    phone_number NVARCHAR(15) UNIQUE NOT NULL,
    email NVARCHAR(100) UNIQUE,
    wallet_balance DECIMAL(10, 2) DEFAULT 0,
    registration_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE Driver (
    driver_id INT PRIMARY KEY IDENTITY(1,1),
    full_name NVARCHAR(100) NOT NULL,
    phone_number NVARCHAR(15) UNIQUE NOT NULL,
    email NVARCHAR(100) UNIQUE,
    license_number NVARCHAR(50) UNIQUE NOT NULL,
    driver_status NVARCHAR(50) DEFAULT 'inactive' CHECK (driver_status IN ('active', 'inactive', 'on_trip')),
    approval_status NVARCHAR(50) DEFAULT 'pending' CHECK (approval_status IN ('pending', 'approved', 'rejected')),
    registration_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY IDENTITY(1,1),
    driver_id INT UNIQUE NOT NULL,
    model NVARCHAR(100) NOT NULL, 
    color NVARCHAR(50) NOT NULL, 
    plate_number NVARCHAR(20) UNIQUE NOT NULL, 
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE DiscountCode (
    discount_code_id INT PRIMARY KEY IDENTITY(1,1),
    code NVARCHAR(50) UNIQUE NOT NULL,
    discount_percentage DECIMAL(5, 2),
    fixed_amount DECIMAL(10, 2),
    expiry_date DATE NOT NULL,
    usage_limit INT DEFAULT 1,
    times_used INT DEFAULT 0,
    is_active BIT DEFAULT 1,
    created_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE Admin (
    admin_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    access_level NVARCHAR(50) NOT NULL,
    employment_date DATETIME DEFAULT GETDATE()
);

CREATE TABLE DriverApplication (
    application_id INT PRIMARY KEY IDENTITY(1,1),
    applicant_name NVARCHAR(100) NOT NULL,
    applicant_phone NVARCHAR(15) NOT NULL,
    applicant_email NVARCHAR(100),
    documents_submitted NVARCHAR(MAX), 
    application_date DATETIME DEFAULT GETDATE(),
    admin_decision NVARCHAR(50) DEFAULT 'pending' CHECK (admin_decision IN ('pending', 'approved', 'rejected')),
    decision_date DATETIME,
	driver_id INT,
    admin_id INT,
    FOREIGN KEY (admin_id) REFERENCES Admin(admin_id),
	FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE Trip (
    trip_id INT PRIMARY KEY IDENTITY(1,1),
    passenger_id INT NOT NULL,
    driver_id INT,
    origin_city_id INT NOT NULL,
    destination_city_id INT NOT NULL,
    origin_address NVARCHAR(255) NOT NULL,
    destination_address NVARCHAR(255) NOT NULL,
    trip_type NVARCHAR(50) NOT NULL CHECK (trip_type IN (N'درون شهری', N'برون شهری', N'رفت و برگشت', N'اشتراکی', N'اقتصادی')),
    request_time DATETIME DEFAULT GETDATE(),
    start_time DATETIME,
    end_time DATETIME,
    status NVARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'started', 'completed', 'cancelled_by_passenger', 'cancelled_by_driver', 'on_trip_traffic', 'on_trip')),
    fare DECIMAL(10, 2),
    discount_code_id INT,
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    FOREIGN KEY (origin_city_id) REFERENCES City(city_id),
    FOREIGN KEY (destination_city_id) REFERENCES City(city_id),
    FOREIGN KEY (discount_code_id) REFERENCES DiscountCode(discount_code_id)
);

CREATE TABLE TripHistory (
    history_id INT PRIMARY KEY IDENTITY(1,1),
    trip_id INT NOT NULL,
    status_change_time DATETIME DEFAULT GETDATE(),
    old_status NVARCHAR(50),
    new_status NVARCHAR(50),
    notes NVARCHAR(MAX),
    FOREIGN KEY (trip_id) REFERENCES Trip(trip_id)
);

CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY IDENTITY(1,1),
    trip_id INT,
    passenger_id INT,
    driver_id INT,
    transaction_type NVARCHAR(50) NOT NULL CHECK (transaction_type IN (N'نقدی', N'الکترونیکی', N'افزایش_کیف_پول', N'برداشت_از_کیف_پول')),
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATETIME DEFAULT GETDATE(),
    payment_status NVARCHAR(50) DEFAULT N'موفق' CHECK (payment_status IN (N'موفق', N'ناموفق', N'در انتظار')),
    discount_code_id INT,
    FOREIGN KEY (trip_id) REFERENCES Trip(trip_id),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE RatingAndReview (
    rating_id INT PRIMARY KEY IDENTITY(1,1),
    trip_id INT NOT NULL UNIQUE,
    passenger_id INT NOT NULL,
    driver_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    review_text NVARCHAR(MAX),
    rating_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (trip_id) REFERENCES Trip(trip_id),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
);

CREATE TABLE Fare (
    fare_id INT PRIMARY KEY IDENTITY(1,1),
    city_id INT NOT NULL,
    trip_type NVARCHAR(50) NOT NULL CHECK (trip_type IN (N'درون شهری', N'برون شهری')),
    cost_per_km DECIMAL(10, 2) NOT NULL,
    effective_date DATE NOT NULL,
    FOREIGN KEY (city_id) REFERENCES City(city_id)
);

CREATE TABLE Route (
    route_id INT PRIMARY KEY IDENTITY(1,1),
    origin_city_id INT NOT NULL,
    destination_city_id INT NOT NULL,
    route_description NVARCHAR(MAX),
    FOREIGN KEY (origin_city_id) REFERENCES City(city_id),
    FOREIGN KEY (destination_city_id) REFERENCES City(city_id)
);

CREATE TABLE Location (
    location_id INT PRIMARY KEY IDENTITY(1,1),
    driver_id INT,
    passenger_id INT,
    latitude DECIMAL(9, 6) NOT NULL,
    longitude DECIMAL(9, 6) NOT NULL,
    timestamp DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id),
    FOREIGN KEY (passenger_id) REFERENCES Passenger(passenger_id)
);
