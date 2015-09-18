(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('车辆详情', function() {
    return it('车辆详情', function(done) {
      return request.post(config.api.car_detail, {
        carId: '9f5d91332ea14017a6c406f9649fb1e1'
      }, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
