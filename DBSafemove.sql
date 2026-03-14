Create database DBSafemove;

use DBSafemove;

CREATE TABLE Users (
    id INT PRIMARY KEY IDENTITY(1,1),

    full_name NVARCHAR(100) NOT NULL,

    email VARCHAR(100) NOT NULL UNIQUE,

    password VARCHAR(255) NOT NULL,

    phone VARCHAR(20) NOT NULL UNIQUE,

    role VARCHAR(20) NOT NULL
        CHECK (role IN ('ADMIN', 'MANAGER', 'STAFF', 'CUSTOMER')),

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED')),

    failed_attempts INT NOT NULL DEFAULT 0      --Số lần User nhập sai mật khẩu liên tiếp.
        CHECK (failed_attempts >= 0),

    locked_until DATETIME NULL,                 --Thời điểm tài khoản sẽ được mở lại sau khi sai mật khẩu liên tiếp.

    created_at DATETIME NOT NULL DEFAULT GETDATE()
);

--------------------------------------------------------------------------------------

CREATE TABLE ServicePackages (
    id INT PRIMARY KEY IDENTITY(1,1),

    name NVARCHAR(100) NOT NULL UNIQUE,

    description NVARCHAR(500),

    base_price DECIMAL(12,2) NOT NULL
        CHECK (base_price >= 0),

    max_vehicles INT NOT NULL
        CHECK (max_vehicles >= 0),

    max_staff INT NOT NULL
        CHECK (max_staff >= 0),

    created_at DATETIME NOT NULL DEFAULT GETDATE()
);

--------------------------------------------------------------------------------------

CREATE TABLE Vehicles (
    id INT PRIMARY KEY IDENTITY(1,1),

    plate_number VARCHAR(20) NOT NULL UNIQUE,

    type NVARCHAR(50) NOT NULL,

    capacity INT NOT NULL
        CHECK (capacity > 0),

    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE'
        CHECK (status IN ('AVAILABLE', 'ASSIGNED', 'MAINTENANCE')),

    created_at DATETIME NOT NULL DEFAULT GETDATE()
);

--------------------------------------------------------------------------------------

CREATE TABLE SurveyRequests (
    id INT PRIMARY KEY IDENTITY(1,1),

    customer_id INT NOT NULL,

    address NVARCHAR(255) NOT NULL,

    survey_date DATETIME NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED')),

    created_at DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Survey_Customer
        FOREIGN KEY (customer_id)
        REFERENCES Users(id)
        ON DELETE CASCADE
);

--------------------------------------------------------------------------------------

CREATE TABLE Contracts (
    id INT PRIMARY KEY IDENTITY(1,1),

    customer_id INT NOT NULL,

    package_id INT NOT NULL,

    vehicle_id INT NULL,

    total_price DECIMAL(12,2) NOT NULL
        CHECK (total_price >= 0),

    contract_date DATETIME NOT NULL DEFAULT GETDATE(),

    status VARCHAR(20) NOT NULL DEFAULT 'CREATED'
        CHECK (status IN ('CREATED', 'CONFIRMED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),

    created_at DATETIME NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Contract_Customer
        FOREIGN KEY (customer_id)
        REFERENCES Users(id),

    CONSTRAINT FK_Contract_Package
        FOREIGN KEY (package_id)
        REFERENCES ServicePackages(id),

    CONSTRAINT FK_Contract_Vehicle
        FOREIGN KEY (vehicle_id)
        REFERENCES Vehicles(id)
);

--------------------------------------------------------------------------------------

CREATE TABLE ContractStaff (
    contract_id INT NOT NULL,
    staff_id INT NOT NULL,

    assigned_at DATETIME NOT NULL DEFAULT GETDATE(),

    PRIMARY KEY (contract_id, staff_id),

    CONSTRAINT FK_CS_Contract
        FOREIGN KEY (contract_id)
        REFERENCES Contracts(id)
        ON DELETE CASCADE,

    CONSTRAINT FK_CS_Staff
        FOREIGN KEY (staff_id)
        REFERENCES Users(id)
);

--------------------------------------------------------------------------------------
INSERT INTO Users (
    full_name,
    email,
    password,
    phone,
    role,
    status,
    failed_attempts,
    locked_until,
    created_at
)
VALUES (
    N'Nguyễn Hoàng Phúc',
    'admin@safemove.com',
    '8d969eef6ecad3c29a3a629280e686cff8fabd1e9f3e7e3c7d5e6c3a6e0e0c8d',
    '0987654321',
    'ADMIN',
    'ACTIVE',
    0,
    NULL,
    GETDATE()
);


INSERT INTO Users (full_name, email, phone, password, role, created_at)
VALUES 

(N'Staff 1', 'staff@safemove.com', '0911111111', '123456', 'STAFF', GETDATE()),
(N'Customer 1', 'user@safemove.com', '0922222222', '123456', 'CUSTOMER', GETDATE());


INSERT INTO Users
(full_name, email, password, phone, role, status, failed_attempts, locked_until, created_at)
VALUES
(
    N'Customer SafeMove',
    'customer@safemove.com',
    '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
    '0900000003',
    'CUSTOMER',
    'ACTIVE',
    0,
    NULL,
    GETDATE()
);











