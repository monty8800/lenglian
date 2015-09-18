(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('省市区列表', function() {
    return it('省市区列表', function(done) {
      return request.post(config.api.location_list, {}, function(result) {
        should.exists(result);
        result[0].rl.should.not.be.empty();
        result[0].rl[0].rl.should.not.be.empty();
        return done();
      });
    });
  });

}).call(this);
