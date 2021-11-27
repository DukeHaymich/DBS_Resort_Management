DROP EVENT IF EXISTS eventDeleteReservation;
DELIMITER #
CREATE EVENT eventDeleteReservation
ON SCHEDULE EVERY 1 HOUR
DO BEGIN
    DELETE FROM reservation
    WHERE TIMESTAMPDIFF(HOUR, checkInDate, NOW()) < 36
    AND status = '0';
END#
DELIMITER ;


DROP EVENT IF EXISTS eventCancelReservation;
DELIMITER #
CREATE EVENT eventCancelReservation
ON SCHEDULE EVERY 1 DAY
DO BEGIN
    SET @rentDay = DATEDIFF(checkOutDate, checkInDate);
    UPDATE reservation
    SET status = '2' AND totalCost = totalCost*(@rentDay - 1)/@rentDay
    WHERE status = '1'
    AND NOT EXISTS (
        SELECT *
        FROM invoice
        WHERE reservationID = reservation.ID
    );
END#
DELIMITER ;


DROP TRIGGER IF EXISTS triggerReservationBU;
DELIMITER #
CREATE TRIGGER triggerReservationBU
BEFORE UPDATE ON reservation
FOR EACH ROW
BEGIN
    IF (OLD.status = '1' AND NEW.status = '2'
        AND TIMESTAMPDIFF(HOUR, checkInDate, NOW()) < 24)
    THEN BEGIN
        SET @rentDay = DATEDIFF(checkOutDate, checkInDate);
        SET NEW.totalCost = NEW.totalCost*(@rentDay - 1)/@rentDay;
    END;
    END IF;
END#
DELIMITER ;



DROP PROCEDURE IF EXISTS PhongDaThue;
DELIMITER #
CREATE PROCEDURE PhongDaThue (
    IN  username        VARCHAR(50),
    IN  password        VARCHAR(100),
    IN  IDCardNumber    VARCHAR(12)
)
BEGIN
    SELECT r.ID AS "Mã phòng", r.branchID AS "Chi nhánh", r.sectorName AS "Khu",
        rT.name AS "Loại phòng", rT.area AS "Diện tích"
    FROM room r
    JOIN roomType rT ON r.roomTypeID = rT.ID
    WHERE (r.branchID, r.ID) IN (
        SELECT branchID, roomID
        FROM rentedRoom
        WHERE reservationID IN (
            SELECT ID
            FROM reservation
            WHERE customerID IN (
                SELECT ID
                FROM customer c
                WHERE c.username = username
                AND c.password = password
                AND c.IDCardNumber = IDCardNumber
            )
        )
    );
END#
DELIMITER ;


DROP PROCEDURE IF EXISTS ThongKeThang;
DELIMITER #
CREATE PROCEDURE ThongKeThang (

)
BEGIN
    SELECT branchID, SUM(totalCost), SUM(numberOfGuest) 
    FROM rentedRoom a
    LEFT JOIN reservation b ON a.reservationID = b.ID
    GROUP BY (branchID) 
END#
DELIMITER ;