const mysql = require('mysql');
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));

const db = mysql.createPool({
    connectionLimit: 100,
    host: "localhost",
    user: "sManager",
    password: "123456",
    database: "hotel_california"
});

// get room query
app.get("/api/getroom",(req, res)=>{
    const data = req.body;
    res.send("YEEEEE");
    // const sqlGet = "Call GetRoomAvailable(?);";

    // db.query(sqlGet, [data.branchID],(err, result)=>{
    //     console.log(err)
    // });

})

// Lấy danh sách phòng đã đăt của khách
app.get("/api/guest/getroom", (req, res)=>{
    const data = req.body;

    const sqlGet = "CALL PhongDaThue(\"dukeHaymich\", \"123456\", \"9999999999\");";

    db.query(sqlGet, data, (err, result)=>{
        res.send(result);
        
    });
});

app.get("/api/getbranch", (req, res)=>{
    const data = req.body;
    const sqlGet = "CALL getBranch();";

    db.query(sqlGet, [data.imageURL, ...data], (err, result)=>{
        console.log(err);
    });
})

app.listen(3001, ()=>{
    console.log("Running on port 3001");
})