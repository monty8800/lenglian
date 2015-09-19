(function() {
  var _addressId, config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  _addressId = "";

  describe('地址', function() {
    return it('新增地址', function(done) {
      return request.post(config.api.add_address, {
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        province: '110000',
        city: '110100',
        area: '110101',
        street: '泰鹏大厦111111',
        licenseno: '',
        createUser: '888888'
      }, function(result) {
        return done();
      });
    });
  });

}).call(this);
