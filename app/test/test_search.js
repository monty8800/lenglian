(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('搜索相关', function() {
    return it('查询我的货源', function(done) {
      var params;
      params = {
        userId: '50819ab3c0954f828d0851da576cbc31',
        resourceStatus: '',
        pageNow: '1',
        pageSize: '10'
      };
      return request.post(config.api.GET_GOODS_LIST, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
