(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('测试认证', function() {
    return it('企业认证', function(done) {
      var files, params;
      params = {
        userId: '837164bf1b544abda5ba379c6ad92e56',
        name: '怡红院',
        type: '1',
        province: 19,
        city: 228,
        area: 1147,
        street: '喂人民服雾',
        phone: '18513468467',
        licenseno: 'adffad11',
        certifies: 'lkajldf',
        permits: 'sdfad',
        principalName: '容馍馍'
      };
      files = [
        {
          filed: 'businessLicenseImg',
          path: 'src/images/car-02.jpg',
          name: 'businessLicenseImg.jpg'
        }, {
          filed: 'transportImg',
          path: 'src/images/car-03.jpg',
          name: 'transportImg.jpg'
        }, {
          filed: 'doorImg',
          path: 'src/images/car-04.jpg',
          name: 'doorImg.jpg'
        }
      ];
      return request.postFile(config.api.COMPANY_AUTH, params, files, function(data) {
        data.should.equal(1);
        return done();
      });
    });
  });

}).call(this);
