(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('测试认证', function() {
    return it('个人认证', function(done) {
      var files, params;
      params = {
        phone: "18088889999",
        type: "3",
        username: "YYQ",
        userId: "5b3d93775a22449284aad35443c09fb6",
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
