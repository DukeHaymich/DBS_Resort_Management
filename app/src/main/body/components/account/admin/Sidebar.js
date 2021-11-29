import './Sidebar.css';
import React from 'react';
import { useHistory, useLocation } from 'react-router-dom';


function Sidebar() {
    const location = useLocation();
    const history = useHistory();
    return (
        <div className="sidebar">
            <ul className="sidebarList">
                <li className="sidebarTitle"> Dashboard </li>
                <i class="fas fa-angle-double-left" id="leftArrow"></i>
                <li className={`sidebarListItem ${location.pathname==='/admin'  ?'active':''}`} onClick={()=>history.push('/admin')}>
                    <div>
                        <i className="fas fa-home"></i>
                        <span className = "labelIcon">Home</span>
                    </div>
                </li>
                <li className={`sidebarListItem ${location.pathname==='/admin/customer'?'active':''}`} onClick={()=>history.push('/admin/customer')}>
                    <div>
                        <i className="fas fa-users"></i>
                        <span className = "labelIcon">Customer</span>
                    </div>
                </li>
                <li className={`sidebarListItem ${location.pathname==='/admin/reservation'?'active':''}`} onClick={()=>history.push('/admin/reservation')}>
                    <div>
                        <i className="fas fa-receipt"></i>
                        <span className = "labelIcon">Reservation</span>
                    </div>
                </li>
                <li className={`sidebarListItem ${location.pathname==='/admin/roomtype'?'active':''}`} onClick={()=>history.push('/admin/roomtype')}>
                    <div>
                        <i className="fas fa-bed"></i>
                        <span className = "labelIcon">Room Type</span>
                    </div>
                </li>
                <li className={`sidebarListItem ${location.pathname==='/admin/settings'?'active':''}`} onClick={()=>history.push('/admin/settings')}>
                    <div>
                        <i className="fas fa-cog"></i>
                        <span className = "labelIcon">Settings</span>
                    </div>
                </li>
            </ul>
        </div>
    );
}

export default Sidebar;