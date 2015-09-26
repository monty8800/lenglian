(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('货主订单详情', function() {
    return it('货主订单详情', function(done) {
      var params;
      params = {
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        orderNo: '1'
      };
      console.log(config.api.goods_order_detail);
      return request.post(config.api.goods_order_detail, params, function(result) {
        return done();
      });
    });
  });

}).call(this);
