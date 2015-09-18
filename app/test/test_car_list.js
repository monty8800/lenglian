(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('我的车辆', function() {
    return it('我的车辆', function(done) {
      var params;
      params = {
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        pageNow: 1,
        pageSize: 10,
        status: ''
      };
      return request.post(config.api.my_car_list, params, function(result) {
        should.exists(result);
        result.myCarInfo[0].driver.should.not.be.empty();
        return done();
      });
    });
  });

}).call(this);
