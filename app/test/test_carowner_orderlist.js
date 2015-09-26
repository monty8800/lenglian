(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('车主订单列表', function() {
    return it('车主订单列表', function(done) {
      var params;
      params = {
        carPersonUserId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        pageNow: 1,
        pageSize: 10,
        orderState: ''
      };
      return request.post(config.api.carowner_order_list, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
