'use strict';
const express = require('express');
const cors = require('cors');
const cookieParser = require("cookie-parser");
// const csrf = require("csurf");
const bodyParser = require('body-parser');
const config = require('./config');
const doctorRoutes = require('./routes/Doctors-routes');

// const csrfMiddleware = csrf({ cookie: true });
const app = express();

app.engine("html",require("ejs").renderFile);
app.use('/static',express.static('static'));

app.use(express.json());
app.use(
    express.urlencoded({
      extended: true
    })
  )
app.use(cors());
app.use(bodyParser.json());
app.use(cookieParser());
// app.use(csrfMiddleware);

// app.all("*",(req, res, next) => {
//     res.cookie("XSRF-TOKEN", req.csrfToken());
//     next();
// });

app.get("/",function(req, res){
    res.render("login.html");
});

app.get("/signup",function(req, res){
    res.render("signup.html");
});

app.get("/dashboard",function(req, res){
    res.render("index.html");
});

app.use('/api', doctorRoutes.routes);


app.listen(config.port, () => console.log('App is listening on url http://localhost:'+config.port))