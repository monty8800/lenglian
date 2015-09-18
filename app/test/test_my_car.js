(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describle('我的车辆', function() {
    return it('我的车辆', function(done) {
      var params;
      params = {
        status: '',
        pageNow: '1',
        pageSize: '10',
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
      };
      return request.post(config.api.my_car_list, params, function(result) {
        return done();
      });
    });
  });

}).call(this);
