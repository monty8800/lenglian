(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('库相关', function() {
    return it('货找库 下单', function(done) {
      var params;
      params = {
        userId: '5b3d93775a22449284aad35443c09fb6',
        warehouseId: '295dd8ab5f6442afae2542175efdba1e',
        orderGoodsId: 'd881b05483ef4f59b4e36290136d7204'
      };
      return request.post(config.api.GOODS_BIND_WAREHOUSE_ORDER, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
