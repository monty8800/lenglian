(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('库相关', function() {
    return it('查询我的仓库', function(done) {
      var params;
      params = {
        userId: '7201beba475b49fd8b872e2d1493844a',
        status: '1',
        pageNow: 1,
        pageSize: 10
      };
      return request.post(config.api.GET_WAREHOUSE, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
