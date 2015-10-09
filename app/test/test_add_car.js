(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('新增车辆', function() {
    return it('新增车辆', function(done) {
      var files, params;
      params = {
        bulky: '11111',
        carno: '傻b22224',
        category: '1',
        driver: '司机' + parseInt(Math.random() * 100),
        heavy: '1',
        latitude: '39',
        longitude: '146',
        phone: '13100000000',
        type: '1',
        userId: '50819ab3c0954f828d0851da576cbc31',
        vehicle: '2'
      };
      files = [
        {
          filed: 'imgUrl',
          path: 'src/images/car-02.jpg',
          name: 'imgUrl.jpg'
        }, {
          filed: 'drivingImg',
          path: 'src/images/car-03.jpg',
          name: 'drivingImg.jpg'
        }, {
          filed: 'transportImg',
          path: 'src/images/car-04.jpg',
          name: 'transportImg.jpg'
        }
      ];
      return request.postFile(config.api.add_car, params, files, function(data) {
        return console.log('data--------', data);
      });
    });
  });

}).call(this);
