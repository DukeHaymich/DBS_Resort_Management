import React, { useContext, useEffect, useRef, useState } from "react";
import { Link, useHistory } from "react-router-dom";
import DBHelper from "../../../../helpers/DBHelper";

function Customer() {
    const DBHelperCtx = useContext(DBHelper);
    const [maxCustomer, setMaxCustomer] = useState(0);
    useEffect(() => {
        DBHelperCtx.fetchCustomerList();
        setMaxCustomer(DBHelperCtx.customerList.length);
        // eslint-disable-next-line
    }, []);

    const name = useRef();
    const history = useHistory();

    function autoSearchHandler() {
        if (name.current.value === "" || maxCustomer < 100) {
            DBHelperCtx.fetchCustomerByName(name.current.value);
        }
    }

    function searchHandler(event) {
        event.preventDefault();
        DBHelperCtx.fetchCustomerByName(name.current.value);
    }

    function showCustomer(customer) {
        return (
            <tr key={DBHelperCtx.customerList.indexOf(customer)} onClick>
                <td>{customer["ID"]}</td>
                <td onClick={()=>{history.pushState("/admin/reservation?customerID="+customer["ID"])}}>{customer["name"]}</td>
                <td>{customer["IDCardNumber"]}</td>
                <td>{customer["phoneNumber"]}</td>
                <td>{customer["email"]}</td>
                <td>{customer["username"]}</td>
                <td>{customer["point"]}</td>
                <td>{customer["type"]}</td>
            </tr>
        );
    }

    function showCustomerList() {
        var content = DBHelperCtx.customerList.length
            ? DBHelperCtx.customerList.map(function(customer) {
                return showCustomer(customer);
            })
            : null;

        return DBHelperCtx.customerList.length
        ? (<table>
            <thead>
                <tr>
                    <td>ID</td>
                    <td>Họ và tên</td>
                    <td>CMND/CCCD</td>
                    <td>Điện thoại</td>
                    <td>Email</td>
                    <td>Username</td>
                    <td>Điểm</td>
                    <td>Loại</td>
                </tr>
            </thead>
            <tbody>
                {content}
            </tbody>
        </table>)
        : <h4>Không có khách nào ở đây cả...</h4>;
    }

    return (
        <React.Fragment>
            <div className="search-form">
                <h3>Tìm kiếm</h3>
                <form onSubmit={searchHandler}>
                    <label>Họ và tên</label>
                    <input type="text" placeholder="Nguyễn Văn A" className="box" ref={name} onChange={autoSearchHandler} />
                    <input type="submit" value="Tìm" className="btn" />
                </form>
            </div>
            {showCustomerList()}
        </React.Fragment>
    );
}

export default Customer;