(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('货主订单详情', function() {
    return it('货源详情', function(done) {
      var params;
      params = {
        userId: '50819ab3c0954f828d0851da576cbc31',
        id: '665a4a2a311547e5a4be6defeb67cbd4'
      };
      return request.post(config.api.GET_GOODS_DETAIL, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
