(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('库相关', function() {
    return it('仓库 拒绝 货主的用库请求  取消这个订单', function(done) {
      var params;
      params = {
        orderNo: "GW20151012100000484",
        warehousePersonUserId: "5b3d93775a22449284aad35443c09fb6",
        version: "0"
      };
      return request.post(config.api.WAREHOUSE_CANCLE_ORDER, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
