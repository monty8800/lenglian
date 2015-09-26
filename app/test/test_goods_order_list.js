(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('货主订单列表', function() {
    return it('货主订单列表', function(done) {
      var params;
      params = {
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        pageNo: 1,
        pageSize: 10,
        state: ''
      };
      return request.post(config.api.goods_order_list, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
