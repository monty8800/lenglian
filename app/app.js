'use strict';

var express = require('express');
var app = express();
var fs = require('fs');
var request = require('superagent');
var process = require('child_process');
var bodyParser = require('body-parser');


var apiServer = 'http://192.168.31.215:8080';


// 一个简单的 logger
app.use(function(req, res, next) {
  console.log('%s %s', req.method, req.url);
  next();
});
app.use(bodyParser());


//反向代理，解决跨域问题
app.all('/*shtml', function(req, res) {
    var url = apiServer + req.url;
    console.log('代理', url);
    console.log(req.body);

    request
        .post(url)
        .type('form')
        .send(req.body)
        .end(function(err, resp) {
            if (err) {
                res.status(500).send(err);
            } else {
               // console.log(resp.text);
                res.send(resp.text);
            }
        });
});



var server = app.listen(3000, function() {
  console.log('Listening on  port %d', server.address().port);
});

//启动webpack server
process.spawn('webpack-dev-server', ['--content-base', './www'], {
  stdio: 'inherit'
});

//启动gulp
process.spawn('gulp', [], {
  stdio: 'inherit'
});