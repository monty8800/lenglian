(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('库相关', function() {
    return it('查询我的仓库', function(done) {
      var params;
      params = {
        userId: '5b3d93775a22449284aad35443c09fb6',
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
