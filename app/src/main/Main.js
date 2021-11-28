import React from "react";
import Body from "./body/Body";
import Header from "./header/Header";

function Main(props) {
    return (
        <div className="main">
            <Header/>
            <Body/>
        </div>
    );
}

export default Main;