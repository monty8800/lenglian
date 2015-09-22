(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('测试注册', function() {
    return it('注册', function(done) {
      var mobile;
      mobile = '18513468467';
      return request.post(config.api.SMS_CODE, {
        mobile: mobile,
        type: 1
      }, function(result) {
        var code;
        code = result.slice(-6);
        console.log('验证码:', code);
        return request.post(config.api.REGISTER, {
          usercode: mobile,
          mobileCode: code,
          password: '123456a'
        }, function(result) {
          result.userId.should.not.be.empty();
          return done();
        });
      });
    });
  });

}).call(this);
