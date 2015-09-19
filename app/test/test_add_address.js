(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('新增地址', function() {
    return it('我的地址列表', function(done) {
      var userId;
      userId = '7714d0d83c7f47f4bcfac62b9a1bf101';
      return request.post(config.api.ADDR_LIST, {
        userId: userId
      }, function(result) {
        result.should.not.be.empty();
        return done();
      });
    });
  });

}).call(this);
