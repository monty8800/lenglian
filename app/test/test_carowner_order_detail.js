(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('车主订单详情', function() {
    return it('车主订单详情', function(done) {
      var params;
      params = {
        carPersonUserId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        orderNo: 'GC20150915100000204'
      };
      return request.post(config.api.carowner_order_detail, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
