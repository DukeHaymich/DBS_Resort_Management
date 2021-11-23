-- PHAN TAO BANG
CREATE SCHEMA hotel_california;
USE hotel_california;


/*** CREATE TABLE (tạo bảng với các thuộc tính) ***/
/* Phần của Đạt */
CREATE TABLE branch (
    ID              VARCHAR(5),
    province        VARCHAR(50),
    address         VARCHAR(200),
    phoneNumber     VARCHAR(15),
    email           VARCHAR(100)
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
    ID              INT AUTO_INCREMENT=1,
    roomTypeName    VARCHAR(50),
    roomArea        FLOAT,
    numberOfGuest   INT NOT NULL,
    description     VARCHAR(100),
    CHECK (numberOfGuest <= 10 AND numberOfGuest >= 1)
);

CREATE TABLE bedInfo (
    roomTypeID      INT,
    size            DECIMAL(2,1),
    quantity        INT NOT NULL DEFAULT 1,
    CHECK (quantity <= 10 AND quantity >= 1)
);

CREATE TABLE roomTypeOfBranch (
    roomTypeID      INT,
    branchID        VARCHAR(5),
    rentFee         INT NOT NULL        
);

CREATE TABLE room (
    branchID        VARCHAR(5),
    ID              CHAR(3),
    roomTypeID      INT,
    sectorName      VARCHAR(50)    
);

/* Phần của Đức */
CREATE TABLE supplyType (
    ID      CHAR(6),
    name    VARCHAR(50)
);
CREATE TABLE supplyTypeInRoomType (
    supplyTypeID    CHAR(6),
    roomTypeID      INT,
    quantity        INT NOT NULL DEFAULT 1 
        CHECK (1 <= quantity AND quantity <= 20),
);
CREATE TABLE supply (
    branchID        VARCHAR(5),
    supplyTypeID    CHAR(6),
    ID              INT
        CHECK (ID > 0),
    condition       VARCHAR(100),
    roomID          CHAR(3) NOT NULL DEFAULT "STO"
);
CREATE TABLE supplier (
    ID          CHAR(7),
    name        VARCHAR(50),
    email       VARCHAR(100),
    address     VARCHAR(200)
);
CREATE TABLE provideSupply (
    supplierID      CHAR(7),
    supplyTypeID    CHAR(6),
    branchID        INT -- REVISE TYPE
);
CREATE TABLE customer (
    ID              CHAR(8),
    IDCardNumber    VARCHAR(12) UNIQUE NOT NULL,
    name            VARCHAR(150),
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
        CHECK (1 <= numberOfDays AND numberOfDays <= 10),
    price           INT NOT NULL
);


/* Phần của Minh */
CREATE TABLE servicePacketInvoice (
	customerID      CHAR(8),
	packetName		VARCHAR(50),
	buyTime		    DATETIME, 
	startTime       DATETIME
        CHECK (startTime > buyTime),
    totalCost       INT NOT NULL,
);
CREATE TABLE reservation (
	ID              CHAR(16),
	bookingDate		DATETIME NOT NULL,
    numberOfGuest   INT,
	checkInDate		DATETIME
        CHECK (checkInDate > bookingDate),
	checkOutDate    DATETIME
        CHECK (checkOutDate > checkInDate),
    status          CHAR(1) DEFAULT '0',
    totalCost       INT NOT NULL DEFAULT 0,
    customerID      CHAR(8),
    packetName      CHAR(9)
);
CREATE TABLE rentedRoom (
	reservationID   CHAR(16),
	branchID        VARCHAR(5),
	roomID          CHAR(3)
);
CREATE TABLE invoice (
	ID              CHAR(16),
	checkInTime     TIME,   #check
    checkOutTime    TIME,   #check 
	reservationID   CHAR(16)
);
CREATE TABLE enterprise (
	ID      CHAR(6),
	name    VARCHAR(50)
);
CREATE TABLE service (
	ID              CHAR(6),
    type            CHAR(1),    #check
	numberOfGuest   INT,
    style           VARCHAR(50),
    enterpriseID    CHAR(6)
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
    length          FLOAT,
    width           FLOAT,
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
    endTime         TIME        #check
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
    PRIMARY KEY(branchID, roomID),
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
        ON DELETE SET DEFAULT ON UPDATE CASCADE
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
    PRIMARY KEY (ID),
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



-- TRIIGER BO SUNG DAM BAO CAC RANG BUOC CUA BANG (NEU CO).
# Kiểm tra lại những chỗ đánh dấu #check