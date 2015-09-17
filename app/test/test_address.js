(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('地址', function() {
    return it('我的地址列表', function(done) {
      var userId;
      userId = 'c413b4b93c674597a563e704090705ef';
      return request.post(config.api.ADDR_LIST, {
        userId: userId
      }, function(result) {
        result.should.not.be.empty();
        return done();
      });
    });
  });

}).call(this);
