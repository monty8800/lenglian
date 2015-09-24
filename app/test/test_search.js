(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('搜索相关', function() {
    it('我要找库(搜索)', function(done) {
      var params;
      params = {
        startNo: '0',
        pageSize: '10'
      };
      return request.post(config.api.SEARCH_WAREHOUSE, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    return it('仓库找货(搜索)', function(done) {
      var params;
      params = {
        startNo: '0',
        pageSize: '10'
      };
      return request.post(config.api.WAREHOUSE_SEARCH_GOODS, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
