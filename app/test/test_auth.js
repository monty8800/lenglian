(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('测试认证', function() {
    return it('个人认证', function(done) {
      var files, params;
      params = {
<<<<<<< HEAD
        phone: "18988889999",
        type: "3",
        username: "YYQ",
        userId: "7201beba475b49fd8b872e2d1493844a",
=======
        phone: "13100000010",
        type: "1",
        username: "王永",
        userId: "50819ab3c0954f828d0851da576cbc31",
>>>>>>> 3128b3c8d255e163112561e98874af8fe9d94a56
        cardno: "12342342344234",
        carno: "1243x",
        frameno: "sfdj222"
      };
      files = [
        {
          filed: 'idcardImg',
          path: 'src/images/car-02.jpg',
          name: 'idcardImg.jpg'
        }, {
          filed: 'drivingImg',
          path: 'src/images/car-03.jpg',
          name: 'drivingImg.jpg'
        }, {
          filed: 'taxiLicenseImg',
          path: 'src/images/car-04.jpg',
          name: 'taxiLicenseImg.jpg'
        }
      ];
      return request.postFile(config.api.PERSONINFO_AUTH, params, files, function(data) {
        data.should.equal(1);
        return done();
      });
    });
  });

}).call(this);
