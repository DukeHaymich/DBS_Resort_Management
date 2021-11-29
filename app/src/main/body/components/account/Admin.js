import React from 'react';
import { useLocation } from 'react-router';
import './Admin.css';
import Sidebar from './admin/Sidebar';
import Home from './admin/Home';
import Customer from './admin/Customer';
import RoomType from './admin/RoomType';
import Reservation from './admin/Reservation';

function Admin() {
    const location = useLocation().pathname;

    return (
        <div className="container">
            <Sidebar />
            <div className ="otherpage">
                {location === "/admin" && <Home/>}
                {location === "/admin/customer" && <Customer/>}
                {location === "/admin/reservation" && <Reservation/>}
                {location === "/admin/roomtype" && <RoomType/>}
            </div>
        </div>
    );
}

export default Admin;