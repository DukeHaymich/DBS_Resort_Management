import { useState, createContext } from 'react';
import Axios from "axios";

const DBHelper = createContext({
    loading: false,

    roomsAvailable: [],
    fetchRoomsAvailable: ()=>{},

    roomList: [],
    fetchRoomList: (username, password, IDCardNumber)=>{},

    branchList: [],
    fetchBranchList: ()=>{},
})

export function DBHelperProvider(props){
    const [roomsAvailable, setRoomsAvailable] = useState([]);
    const [roomList, setRoomList] = useState([]);
    const [branchList, setBranchList] = useState([]);
    const [loading, setLoading] = useState(false);


    function fetchRoomsAvailableHandler(data) {
        setLoading(true);
        console.log("Sended");
        Axios.get('http://localhost:3001/api/getroom').then(
            (response)=>{
                console.log(response.data);
                // setRoomsAvailable(response.data);
                setLoading(false);
            }
        )
    }

    function fetchRoomListHandler(username, password, IDCardNumber) {
        setLoading(true);
        Axios.get("http://localhost:3001/api/guest/getroom", {
            username: username,
            password: password,
            IDCardNumber: IDCardNumber
        }).then(
            (response)=>{
                setRoomList(response.data);
                setLoading(false);
            }
        )
    }

    function fetchBranchListHandler(data) {
        setLoading(true);
        Axios.get('http://localhost:3001/api/getbranch').then(
            (response)=>{
                setBranchList(response.data);
                setLoading(false);
            }
        )
    }

    const context = {
        loading: loading,

        roomsAvailable: roomsAvailable,
        fetchRoomsAvailable: fetchRoomsAvailableHandler,

        roomList: roomList,
        fetchRoomList: fetchRoomListHandler,

        branchList: branchList,
        fetchBranchList: fetchBranchListHandler,
    }

    return <DBHelper.Provider value={context}>
        {props.children}
    </DBHelper.Provider>
}

export default DBHelper;
