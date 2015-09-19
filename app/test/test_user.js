(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('测试用户', function() {
    it('个人中心', function(done) {
      var userId;
      userId = '7714d0d83c7f47f4bcfac62b9a1bf101';
      return request.post(config.api.USER_CENTER, {
        userId: userId
      }, function(result) {
        should.exists(result);
        result.carStatus.should.be.within(0, 3);
        result.certification.should.be.within(0, 2);
        result.goodsStatus.should.be.within(0, 3);
        result.myCarCount.should.be.Number();
        result.myMessageCount.should.be.Number();
        result.myWishlistCount.should.be.Number();
        result.userId.should.equal(userId);
        result.usercode.should.not.be.empty();
        result.warehouseStatus.should.be.within(0, 3);
        return done();
      });
    });
    it('找回密码', function(done) {
      var mobile, passwd;
      mobile = '18513468467';
      passwd = '123456a';
      return request.post(config.api.SMS_CODE, {
        mobile: mobile,
        type: 2
      }, function(data) {
        var code;
        data.should.not.be.empty();
        code = data.slice(-6);
        code.should.not.be.empty();
        return request.post(config.api.RESET_PWD, {
          usercode: mobile,
          password: passwd,
          mobileCode: code
        }, function(result) {
          result.should.not.be.empty();
          return done();
        });
      });
    });
    return it('登录', function(done) {
      var mobile, passwd;
      mobile = '18513468467';
      passwd = '123456a';
      return request.post(config.api.LOGIN, {
        usercode: mobile,
        password: passwd
      }, function(result) {
        result.should.not.be.empty();
        result.carStatus.should.be.within(0, 3);
        result.certification.should.be.within(0, 2);
        result.goodsStatus.should.be.within(0, 3);
        result.userId.should.not.be.empty();
        result.warehouseStatus.should.be.within(0, 3);
        return done();
      });
    });
  });

}).call(this);
