(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('车辆详情', function() {
    return it('车辆详情', function(done) {
      return request.post(config.api.car_detail, {
        carId: 'c33e64812d244b5a8ad7836ea8471578'
      }, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
