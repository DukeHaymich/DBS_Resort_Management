import React from 'react';
import "./Header.css";

function Header(props) {
    // var loginButton, loginForm;
    var navbar, navButton;
    // var searchForm, searchButton;
    // var menu, menuContainer;

    function getDOM() {
        navbar = document.querySelector('.navbar');
        navButton = document.getElementById('nav-btn');
    }

    function Nav_handle() {
        getDOM()
        navbar.classList.toggle('active');
        navButton.classList.toggle('active');
    }


    return (
        <header className="header">
            <a href="#home" className="logo">{/*<img src={logo} alt=""/>*/}Hotel<span>California</span></a>
            <nav id="nav-nav" className="navbar">
                <a href="/#">Trang chủ</a>
                <a href="/#">Đặt phòng</a>
                <a href="/#">Tin tức</a>
                <a href="/#">Liên hệ</a>
            </nav>
            <div className="icons">
                <div id="nav-btn" onClick={Nav_handle} className="fas fa-bars"></div>
                <div id="account-btn" className="fas fa-user"></div>
            </div>
        </header>
    );
}
export default Header;