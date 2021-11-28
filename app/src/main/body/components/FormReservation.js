/*Khách hàng có thể đặt phòng online trên website của resort.
Khi đặt phòng, khách hàng cần cung cấp 
thông  tin:  CCCD/CMND, họ tên, số điện thoại, email liên lạc, chi nhánh, số lượng khách,  ngày  nhận 
phòng, ngày trả phòng. 
Hệ thống sẽ hiển thị các loại phòng trống phù hợp với yêu cầu của khách hàng. 
Tiếp đó, khách hàng lựa chọn loại phòng, số lượng phòng mong muốn, số tiền cần thanh toán sẽ được 
    tự động tính toán */

import { useRef, useContext } from 'react'
import DBHelper  from '../../helpers/DBHelper';

function FormReservation(props) {
    const DBHelperCtx=useContext(DBHelper);
    const data = {
        ID : useRef(),
        name : useRef(),
        phoneNumber : useRef(),
        email : useRef(),
        branchID : useRef(),
        numberOfGuest: useRef(),
        startDate: useRef(),
        endDate: useRef()
    }
    function submitHandler(){
        console.log("YOLO");
        DBHelperCtx.fetchRoomsAvailable({
            branchID: data.branchID.current.value,
            numberOfGuest: data.numberOfGuest.current.value,
            startDate: data.startDate.current.value,
            endDate: data.endDate.current.value,
        })
    }
    return (
        <div>
        <h2>Đăng Ký Đặt Phòng</h2>
            <label>CCCD/CMND: </label>
            <input ref={data.ID} />
            <label>Họ tên: </label>
            <input ref={data.name}/>
            <label>Số điện thoại: </label>
            <input ref={data.phoneNumber} />
            <label>Email: </label>
            <input ref={data.email} />
            <label>Chi nhánh: </label>
            <select ref={data.branchID}>
                <option value="CN001">aaa</option>
                <option value="CN002">bbb</option>
                <option value="CN003">ccc</option>
            </select>
            <label>Số lượng người:</label>
            <input type="number" min={1} ref={data.numberOfGuest}/>
            <label>Ngày nhận phòng: </label>
            <input type="date" ref={data.startDate}/>
            <label>Ngày trả phòng: </label>
            <input type="date" ref={data.endDate}/>
            <button onClick={submitHandler}>Đăng ký</button>
        </div>
    );
}
    
export default FormReservation;