(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('仓库订单列表', function() {
    return it('仓库订单列表', function(done) {
      var url;
      url = config.api.store_order_List;
      return request.post(url, {
        userId: 'c413b4b93c674597a563e704090705ef',
        orderState: '1',
        pageNow: 1,
        pageSize: 10
      }, function(result) {
        return done();
      });
    });
  });

}).call(this);
