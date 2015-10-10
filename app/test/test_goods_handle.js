(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('货相关的操作', function() {
    return it('货源详情', function(done) {
      var params;
      params = {
        userId: '50819ab3c0954f828d0851da576cbc31',
        id: '336accc50b4e48aeab5a8f5fd31761f0'
      };
      return request.post(config.api.GET_GOODS_DETAIL, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
