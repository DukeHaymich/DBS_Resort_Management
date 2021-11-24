-- PHAN TAO BANG
DROP SCHEMA IF EXISTS hotel_california;
CREATE SCHEMA hotel_california DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_vi_0900_as_cs;
USE hotel_california;


/*** CREATE TABLE (tạo bảng với các thuộc tính) ***/
/* Phần của Đạt */
CREATE TABLE branch (
    ID              VARCHAR(5),
    province        VARCHAR(50),
    address         VARCHAR(200) UNIQUE NOT NULL,
    phoneNumber     VARCHAR(15) UNIQUE NOT NULL,
    email           VARCHAR(100) NOT NULL
);

CREATE TABLE branchImage (
    branchID        VARCHAR(5),
    imageURL        VARCHAR(100)
);

CREATE TABLE sector (
    branchID        VARCHAR(5),
    name            VARCHAR(50)
);

CREATE TABLE roomType (
    ID              INT,
    roomTypeName    VARCHAR(50) UNIQUE NOT NULL,
    roomArea        FLOAT NOT NULL,
    numberOfGuest   INT NOT NULL,
    description     VARCHAR(100),
    CHECK (numberOfGuest <= 10 AND numberOfGuest >= 1)
);

CREATE TABLE bedInfo (
    roomTypeID      INT,
    size            DECIMAL(2,1) NOT NULL,
    quantity        INT NOT NULL DEFAULT 1,
    CHECK (1 <= quantity  AND quantity <= 10)
);

CREATE TABLE roomTypeOfBranch (
    roomTypeID      INT,
    branchID        VARCHAR(5),
    rentFee         INT NOT NULL        
);

CREATE TABLE room (
    branchID        VARCHAR(5),
    ID              CHAR(3),
    roomTypeID      INT NOT NULL,
    sectorName      VARCHAR(50) NOT NULL
);

/* Phần của Đức */
CREATE TABLE supplyType (
    ID      CHAR(6),
    name    VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE supplyTypeInRoomType (
    supplyTypeID    CHAR(6),
    roomTypeID      INT,
    quantity        INT NOT NULL DEFAULT 1 
        CHECK (1 <= quantity AND quantity <= 20)
);
CREATE TABLE supply (
    branchID        VARCHAR(5),
    supplyTypeID    CHAR(6),
    ID              INT
        CHECK (ID > 0),
    status       	VARCHAR(100) NOT NULL,
    roomID          CHAR(3)
);
CREATE TABLE supplier (
    ID          CHAR(7),
    name        VARCHAR(50) UNIQUE NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    address     VARCHAR(200) UNIQUE NOT NULL
);
CREATE TABLE provideSupply (
    supplierID      CHAR(7) NOT NULL,
    supplyTypeID    CHAR(6),
    branchID        VARCHAR(5)
);
CREATE TABLE customer (
    ID              CHAR(8),
    IDCardNumber    VARCHAR(12) UNIQUE NOT NULL,
    name            VARCHAR(150) NOT NULL,
    phoneNumber     VARCHAR(15) UNIQUE NOT NULL,
    email           VARCHAR(100) UNIQUE,
    username        VARCHAR(50) UNIQUE,
    password        VARCHAR(100),
    point           INT NOT NULL DEFAULT 0
        CHECK (point >= 0),
    type            INT NOT NULL DEFAULT 1
        CHECK (1 <= type AND type <= 4)
);
CREATE TABLE servicePacket (
    name            VARCHAR(50),
    numberOfDays    INT NOT NULL
        CHECK (1 <= numberOfDays AND numberOfDays <= 100),
    numberOfGuests  INT NOT NULL
        CHECK (1 <= numberOfGuests AND numberOfGuests <= 10),
    price           INT NOT NULL
);


/* Phần của Minh */
CREATE TABLE servicePacketInvoice (
	customerID      CHAR(8),
	packetName		VARCHAR(50),
	buyTime		    DATETIME, 
	startTime       DATETIME NOT NULL,
	CHECK (startTime > buyTime),
    totalCost       INT NOT NULL
);
CREATE TABLE reservation (
	ID              CHAR(16),       #check
	bookingDate		DATETIME NOT NULL,
    numberOfGuest   INT NOT NULL,
	checkInDate		DATETIME NOT NULL,
	CHECK (checkInDate > bookingDate),
	checkOutDate    DATETIME NOT NULL,
	CHECK (checkOutDate > checkInDate),
    status          CHAR(1) NOT NULL DEFAULT '0',
    totalCost       INT NOT NULL DEFAULT 0,
    customerID      CHAR(8) NOT NULL,
    packetName      CHAR(9)
);
CREATE TABLE rentedRoom (
	reservationID   CHAR(16),
	branchID        VARCHAR(5),
	roomID          CHAR(3)
);
CREATE TABLE invoice (
	ID              CHAR(16),
	checkInTime     TIME NOT NULL,   #check
    checkOutTime    TIME NOT NULL,   #check 
	reservationID   CHAR(16) NOT NULL
);
CREATE TABLE enterprise (
	ID      CHAR(6),
	name    VARCHAR(50) UNIQUE NOT NULL
);
CREATE TABLE service (
	ID              CHAR(6),
    type            CHAR(1) NOT NULL,
	numberOfGuest   INT,
    style           VARCHAR(50),
    enterpriseID    CHAR(6) NOT NULL
);

/* Phần của Sơn */
CREATE TABLE spa (
	ID	            CHAR(6), 
	type            VARCHAR(30)
);

CREATE TABLE souvenirType (
	ID	            CHAR(6), 
	type	        VARCHAR(30)
);

CREATE TABLE souvenirBrand (
	ID	            CHAR(6), 
	brandName	    VARCHAR(50)
);

CREATE TABLE lot (
	branchID	    VARCHAR(5),
    ID	            INT NOT NULL DEFAULT 1
        CHECK (1 <= ID AND ID <= 50),
    length          FLOAT NOT NULL,
    width           FLOAT NOT NULL,
    rentFee		    INT NOT NULL,
    description     VARCHAR(200),
	serviceID	    CHAR(6),
    shopName        VARCHAR(50),
    logoURL         VARCHAR(100)
);

CREATE TABLE shopImage (
	branchID	    VARCHAR(5),
	lotID		    INT,
    imageURL        VARCHAR(100)
);

CREATE TABLE timeFrame (
	branchID	    VARCHAR(5),
	lotID	        INT,
    startTime       TIME,
    endTime         TIME NOT NULL,
	CHECK (endTime > startTime)
);


/*** ALTER TABLE (thêm khóa cho bảng) ***/
/* Phần của Đạt */
ALTER TABLE branch ADD (
    PRIMARY KEY(ID)
);

ALTER TABLE branchImage ADD (
    PRIMARY KEY(branchID, imageURL),
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE sector ADD (
    PRIMARY KEY(branchID, name),
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE roomType ADD (
    PRIMARY KEY(ID)
);
ALTER TABLE roomType MODIFY
    ID      INT AUTO_INCREMENT
;

ALTER TABLE bedInfo ADD (
    PRIMARY KEY(roomTypeID, size),
    FOREIGN KEY(roomTypeID) REFERENCES roomType(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE roomTypeOfBranch ADD(
    PRIMARY KEY(roomTypeID, branchID),
    FOREIGN KEY(roomTypeID) REFERENCES roomType(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE room ADD (
    PRIMARY KEY(branchID, ID),
    FOREIGN KEY(branchID, sectorName) REFERENCES sector(branchID, name)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(roomTypeID) REFERENCES roomType(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);


/* Phần của Đức */
ALTER TABLE supplyType ADD (
    PRIMARY KEY(ID)
);
ALTER TABLE supplyTypeInRoomType ADD (
    PRIMARY KEY (supplyTypeID, roomTypeID),
    FOREIGN KEY (supplyTypeID) REFERENCES supplyType (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (roomTypeID) REFERENCES roomType (ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE supply ADD (
    PRIMARY KEY (branchID, supplyTypeID, ID),
    FOREIGN KEY (branchID) REFERENCES branch (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supplyTypeID) REFERENCES supplyType (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (branchID, roomID) REFERENCES room (branchID, ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE supplier ADD (
    PRIMARY KEY (ID)
);
ALTER TABLE provideSupply ADD (
    PRIMARY KEY (supplyTypeID, branchID),
    FOREIGN KEY (supplierID) REFERENCES supplier (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supplyTypeID) REFERENCES supplyType (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (branchID) REFERENCES branch (ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);
ALTER TABLE customer ADD (
    PRIMARY KEY (ID)
);
ALTER TABLE servicePacket ADD (
    PRIMARY KEY (name)
);

/* Phần của Minh */
ALTER TABLE servicePacketInvoice 
ADD (
	PRIMARY KEY (customerID, packetName, buyTime),
	FOREIGN KEY (customerID) REFERENCES customer (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (packetName) REFERENCES servicePacket (name)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE reservation 
ADD (	
	PRIMARY KEY (ID),
	FOREIGN KEY (customerID) REFERENCES customer (ID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (packetName) REFERENCES servicePacket (name)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE rentedRoom 
ADD (	
	PRIMARY KEY (reservationID, branchID, roomID),
	FOREIGN KEY (reservationID) REFERENCES reservation (ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (branchID, roomID) REFERENCES room (branchID, ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE invoice 
ADD (	
	PRIMARY KEY (ID),
	FOREIGN KEY (reservationID) REFERENCES reservation (ID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE enterprise 
ADD (	
	PRIMARY KEY (ID)
);

ALTER TABLE service 
ADD (	
	PRIMARY KEY (ID),
    FOREIGN KEY (enterpriseID) REFERENCES enterprise (ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);


/* Phần của Sơn */
ALTER TABLE spa ADD (
    PRIMARY KEY(ID, type),
    FOREIGN KEY(ID) REFERENCES service (ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE souvenirType ADD (
    PRIMARY KEY(ID, type),
    FOREIGN KEY(ID) REFERENCES service(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE souvenirBrand ADD (
    PRIMARY KEY(ID, brandName),
    FOREIGN KEY(ID) REFERENCES service(ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE lot ADD (
    PRIMARY KEY(branchID, ID),
    FOREIGN KEY(branchID) REFERENCES branch(ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(serviceID) REFERENCES service(ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

ALTER TABLE shopImage ADD (
    PRIMARY KEY(branchID, lotID, imageURL),
    FOREIGN KEY(branchID, lotID) REFERENCES lot (branchID, ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

ALTER TABLE timeFrame ADD (
    PRIMARY KEY(branchID, lotID, startTime),
    FOREIGN KEY(branchID, lotID) REFERENCES lot (branchID, ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);



-- TRIGGER BO SUNG DAM BAO CAC RANG BUOC CUA BANG (NEU CO).
CREATE TABLE tableID (
    name       VARCHAR(50),
    number     INT NOT NULL DEFAULT 1,
    PRIMARY KEY (name)
);

INSERT IGNORE INTO tableID(name)
VALUES
    ('branch'),
    ('supplyType'),
    ('supplier'),
    ('customer'),
    ('reservation'),
    ('invoice'),
    ('enterprise')
;


DROP TRIGGER IF EXISTS triggerBranchBI;
DELIMITER #
CREATE TRIGGER triggerBranchBI
BEFORE INSERT ON branch
FOR EACH ROW
BEGIN
    SELECT number
    FROM tableID
    WHERE name = 'branch'
    INTO @count;
    
    SET NEW.ID = CONCAT('CN', @count);

    UPDATE tableID
    SET number = number + 1
    WHERE name = 'branch';
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerSupplyTypeBI;
DELIMITER #
CREATE TRIGGER triggerSupplyTypeBI
BEFORE INSERT ON supplyType
FOR EACH ROW
BEGIN
    SELECT number
    FROM tableID
    WHERE name = "supplyType"
    INTO @count;

    SET NEW.ID = CONCAT('VT', LPAD(@count, 4, 0));

    UPDATE tableID
    SET number = number + 1
    WHERE name = "supplyType";
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerSupplierBI;
DELIMITER #
CREATE TRIGGER triggerSupplierBI
BEFORE INSERT ON supplier
FOR EACH ROW
BEGIN
    SELECT number
    FROM tableID
    WHERE name = "supplier"
    INTO @count;

    SET NEW.ID = CONCAT('NCC', LPAD(@count, 4, 0));

    UPDATE tableID
    SET number = number + 1
    WHERE name = "supplier";
END#
DELIMITER ;

DROP TRIGGER IF EXISTS triggerCustomerBI;
DELIMITER #
CREATE TRIGGER triggerCustomerBI
BEFORE INSERT ON customer
FOR EACH ROW
BEGIN
    SELECT number
    FROM tableID
    WHERE name = "customer"
    INTO @count;

    SET NEW.ID = CONCAT('KH', LPAD(@count, 6, 0));

    UPDATE tableID
    SET number = number + 1
    WHERE name = "customer";
END#
DELIMITER ;

DROP TRIGGER IF EXISTS triggerRoomBD;
DELIMITER #3
CREATE TRIGGER triggerRoomBD
BEFORE DELETE ON room
FOR EACH ROW
BEGIN
    UPDATE supply
    SET supply.roomID = NULL
    WHERE supply.roomID = OLD.ID
    AND supply.branchID = OLD.branchID;
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerReservationBI;
DELIMITER #
CREATE TRIGGER triggerReservationBI
BEFORE INSERT ON reservation
FOR EACH ROW
BEGIN
    SELECT number FROM tableID WHERE name = "reservation" INTO @ID;
    SELECT CONCAT("DP", DATE_FORMAT(DATE(NEW.bookingDate), "%d%m%Y"), LPAD(@ID, 6, 0)) INTO @ID;
	SET NEW.ID = @ID;
    UPDATE tableID
        SET number = number + 1
        WHERE name = "reservation";
END#
DELIMITER ;

DROP TRIGGER IF EXISTS triggerInvoiceBI;
DELIMITER #
CREATE TRIGGER triggerInvoiceBI
BEFORE INSERT ON invoice
FOR EACH ROW
BEGIN
    SELECT number FROM tableID WHERE name = "invoice" INTO @ID;
    SELECT CONCAT("HD", DATE_FORMAT(CURDATE(), "%d%m%Y"), LPAD(@ID, 6, 0)) INTO @ID;
	SET NEW.ID = @ID;
    UPDATE tableID
        SET number = number + 1
        WHERE name = "invoice";
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerEnterpriseBI;
DELIMITER #
CREATE TRIGGER triggerEnterpriseBI
BEFORE INSERT ON enterprise
FOR EACH ROW
BEGIN
    SELECT number FROM tableID WHERE name = "enterprise" INTO @count;
    SET NEW.ID = CONCAT('DN', LPAD(@count, 4, 0));
    UPDATE tableID SET number = number + 1 WHERE name = "enterprise";
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerServiceBI;
DELIMITER #
CREATE TRIGGER triggerServiceBI
BEFORE INSERT ON service
FOR EACH ROW
BEGIN
    SELECT number FROM tableID WHERE name = "service" INTO @count;
    SET NEW.ID = CONCAT('DV', NEW.type, LPAD(@count, 3, 0));
    UPDATE tableID SET number = number + 1 WHERE name = "service";
END#
DELIMITER ;


-- INSERT
/*** INSERT INTO TABLE (sinh dữ liệu cho bảng) ***/
/* Phần của Đạt */
-- Chi nhánh
INSERT INTO branch(province, address, phoneNumber, email)
VALUES 
    ('TP. Hồ Chí Minh', '101 Nguyễn Hữu Cảnh, quận Bình Thạnh', '0901234000', 'DukeHaymich@gmail.com'),
    ('TP. Hồ Chí Minh', '102 Nguyễn Xí, quận Bình Thạnh', '0901234001', 'HaymichDuke@gmail.com'),
    ('TP. Hồ Chí Minh', '302 Kha Vạn Cân, quận Thủ Đức', '0901234002', 'Typn1911@gmail.com');
-- Hình ảnh chi nhánh
INSERT INTO branchImage(branchID, imageURL)
VALUES
    ('CN1', '../img/branchlogo/branchno1.png'),
    ('CN2', '../img/branchlogo/branchno2.png'),
    ('CN3', '../img/branchlogo/branchno3.png'),
-- Khu
INSERT INTO sector(branchID, name)
VALUES
    ('CN1', 'Ven sông'),
    ('CN1', 'Công viên'),
    ('CN2', 'Chợ')
;
-- Loại phòng
-- Thông tin giường
-- Chi nhánh có loại phòng
-- Phòng
/* Phần của Đức */
-- Loại vật tư
INSERT INTO supplyType (name)
VALUES
    ("Khăn tắm"),
    ("Đôi dép"),
    ("Kem đánh răng"),
    ("Xà phòng"),
    ("Tủ quần áo"),
    ("Tủ đầu giường"),
    ("Bàn"),
    ("Ghế"),
    ("Ấm đun nước"),
    ("Tủ lạnh"),
    ("Máy lạnh"),
    ("Quạt"),
    ("Tivi")
    ("Giường"),
    ("Chăn"),
    ("Drap"),
    ("Gối"),
    ("Nệm")
;
-- Loại vật tư trong loại phòng
-- Vật tư
-- Nhà cung cấp
-- Cung cấp vật tư
-- Khách hàng
-- Gói dịch vụ
/* Phần của Minh */
-- Hoá đơn gói dịch vụ
-- Đơn đặt phòng
INSERT INTO reservation (bookingDate,numberOfGuest,checkInDate,checkOutDate,customerID)
VALUES 
    ('2021-11-19 13:17:17',5,'2021-11-20 13:17:17','2021-11-30 13:17:17','KH000001'),
    ('2021-11-15 13:17:17',5,'2021-11-20 13:17:17','2021-11-30 13:17:17','KH000001');
-- Phòng thuê
-- Hoá đơn
-- Doanh nghiệp
-- Dịch vụ
/* Phần của Sơn */
-- Dịch vụ Spa
-- Loại hàng đồ lưu niệm
-- Thương hiệu đồ lưu niệm
-- Mặt bằng
-- Hình ảnh cửa hàng
-- Khung giờ hoạt động cửa hàng