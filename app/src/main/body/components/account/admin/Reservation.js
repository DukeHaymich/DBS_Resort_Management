import React, { useContext, useEffect } from "react";
import { useParams } from "react-router";
import DBHelper from "../../../../helpers/DBHelper";

function Reservation(props) {
    const DBHelperCtx = useContext(DBHelper);
    let data = useParams();
    useEffect(() => {
        console.log(data);
        DBHelperCtx.fetchReservationList(data);
        // eslint-disable-next-line
    }, []);

    function showReservation(reservation) {
        return (
            <tr key={DBHelperCtx.reservationList.indexOf(reservation)}>
                <td>{reservation["ID"]}</td>
                <td>{reservation["name"]}</td>
                <td>{reservation["IDCardNumber"]}</td>
                <td>{reservation["phoneNumber"]}</td>
                <td>{reservation["email"]}</td>
                <td>{reservation["username"]}</td>
                <td>{reservation["point"]}</td>
                <td>{reservation["type"]}</td>
            </tr>
        );
    }

    function showReservationList() {
        var content = DBHelperCtx.reservationList.length
            ? DBHelperCtx.reservationList.map(function(reservation) {
                return showReservation(reservation);
            })
            : null;

        return DBHelperCtx.reservationList.length
        ? (<table>
            <thead>
                <tr>
                    <td>ID</td>
                    <td>Ngày đặt phòng</td>
                    <td>Số lượng khách</td>
                    <td>Ngày nhận phòng</td>
                    <td>Ngày trả phòng</td>
                    <td>Tình trạng</td>
                    <td>Giá tiền</td>
                </tr>
            </thead>
            <tbody>
                {content}
            </tbody>
        </table>)
        : <h4>Không có đơn nào cả...</h4>;
    }

    return (
        <React.Fragment>
            {showReservationList()}
        </React.Fragment>
    );
}

export default Reservation;