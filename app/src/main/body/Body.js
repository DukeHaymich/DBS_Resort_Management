import React from 'react';
import "./Body.css";
import FormReservation from './components/FormReservation';
import RoomList from './components/RoomList';
function Body(props) {
    return (
        <div className="body">
            {/* <FormReservation /> */}
            <RoomList />
        </div>
    );
}

export default Body;