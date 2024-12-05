const express = require("express");

const app = express();

app.use(express.json());

app.use(express.urlencoded({
    express: true
}));

const productData = [];

app.listen(2000, ()=>{
    console.log("Connect to server at 2000");
})

//post api

app.post("/api/add_product",(req,res)=> {

    console.log("Result", req.body);

    const data = {
        "slot": req.body.slot,
        "hour": req.body.hour,
        "min": req.body.min,
        "name": req.body.name,
        "dosagePT": req.body.dosagePT,
        "dosageL": req.body.dosageL,
        "info": req.body.info,
    };

    productData.push(data);
    console.log("Final", data);

    res.status(200).send
({
    "status_code": 200,
    "message": "Done",
    "data":data
})
})