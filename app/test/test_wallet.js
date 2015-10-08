(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('钱包_相关', function() {
    return it('查询银行列表', function(done) {
      return request.post(config.api.GET_BANK_LIST, {
        userId: '7201beba475b49fd8b872e2d149384a'
      }, function(data) {
        should.exists(data);
        return done();
      });
    });
  });

}).call(this);
