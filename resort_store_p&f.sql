USE hotel_california;

-- 2.1.1 PROCEDURE 1
DROP PROCEDURE IF EXISTS GoiDichVu;
DELIMITER #
CREATE PROCEDURE GoiDichVu (
    IN  customerID    CHAR(8)
)
BEGIN
    DECLARE currentDate DATETIME;
    SET currentDate = CURDATE();
    SELECT packetName AS 'Tên gói',
        numberOfGuest AS 'Số khách',
        startDate AS 'Ngày bắt đầu',
        CONVERT(DATE_ADD(startDate, INTERVAL 1 YEAR), DATETIME) AS 'Ngày hết hạn',
        GREATEST(
            LEAST(
                DATEDIFF(DATE_ADD(startDate, INTERVAL 1 YEAR), currentDate),
                DATEDIFF(DATEDIFF(checkInDate, checkOutDate), numberOfDay)
            ),
        0) AS 'Số ngày sử dụng còn lại'
    FROM servicePacketInvoice a
    LEFT JOIN servicePacket b
    ON a.packetName = b.name
    LEFT JOIN reservation c
    ON a.customerID = c.customerID AND a.packetName = c.packetName
    WHERE a.customerID = customerID;
END#
DELIMITER ;

-- 2.1.2 PROCEDURE 2
DROP PROCEDURE IF EXISTS ThongKeLuotKhach;
DELIMITER #
CREATE PROCEDURE ThongKeLuotKhach (
    IN  branchID     VARCHAR(5),
    IN  year         YEAR
)
BEGIN
    SELECT MONTH(checkInDate) AS "Tháng", IFNULL(SUM(numberOfGuest), 0) AS "Tổng số lượt khách"
    FROM reservation
    WHERE YEAR(checkInDate) = year
    AND ID IN (
        SELECT reservationID
        FROM rentedRoom
        WHERE branchID = branchID
    )
    GROUP BY MONTH(checkInDate)
    ORDER BY MONTH(checkInDate) ASC;
END#
DELIMITER ;

-- 2.2.1 TRIGGER 1
-- 2.2.1.1 TRIGGER 1.1

-- 2.2.1.2 TRIGGER 1.2

-- 2.2.1.3 TRIGGER 1.3

DROP TRIGGER IF EXISTS triggerPointCustomer1;
DELIMITER $$
CREATE TRIGGER triggerPointCustomer1
    AFTER UPDATE
    ON reservation FOR EACH ROW
BEGIN
    IF OLD.status = '0' AND NEW.status = '1' THEN
        UPDATE customer
        SET point = point + FLOOR(NEW.totalCost/1000)
        WHERE ID = NEW.customerID;
    END IF;
END$$    
DELIMITER ;

-- 2.2.1.4 TRIGGER 1.4
/**/
DROP TRIGGER IF EXISTS triggerTypeCustomer;
DELIMITER $$
CREATE TRIGGER triggerTypeCustomer
    BEFORE UPDATE
    ON customer FOR EACH ROW
BEGIN
    IF OLD.type = 1 AND NEW.point >= 50 THEN
        SET NEW.type = 2;
    END IF;
    IF OLD.type = 2 AND NEW.point >= 100 THEN
        SET NEW.type = 3;
    END IF;
    IF OLD.type = 3 AND NEW.point >= 1000 THEN
        SET NEW.type = 4;
    END IF;
END$$    
DELIMITER ;
/**/

-- 2.2.2 TRIGGER 2

-- Test PROCEDURE 1
CALL GoiDichVu("KH000001");

-- Test PROCEDURE 2
CALL ThongKeLuotKhach("CN1", "2021");

-- Test TRIGGER 1

-- Test TRIGGER 2