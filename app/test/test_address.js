(function() {
  var _addressId, config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  _addressId = "dae9e1dd2f4d40928a93b6cd228e7f6a";

  describe('地址', function() {
    it('我的地址列表', function(done) {
      var userId;
      userId = '50819ab3c0954f828d0851da576cbc31';
      return request.post(config.api.ADDR_LIST, {
        userId: userId
      }, function(result) {
        result.should.not.be.empty();
        _addressId = result[0].id;
        return done();
      });
    });
    return it('修改地址', function(done) {
      return request.post(config.api.modify_address, {
        id: _addressId,
        userId: '50819ab3c0954f828d0851da576cbc31',
        province: '北京市',
        city: '北京市',
        area: '海淀区',
        street: '泰鹏大厦310',
        latitude: '39.00',
        longitude: '146.00'
      }, function(result) {
        return done();
      });
    });
  });

}).call(this);
