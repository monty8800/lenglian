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
        result.isPayStatus.should.be.within(0, 1);
        result.balance.should.be.Number();
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
    it('修改密码', function(done) {
      var passwd, userId;
      userId = '9cd0f23940824702b99bf74328f61f54';
      passwd = '123456a';
      return request.post(config.api.CHANGE_PWD, {
        userId: userId,
        oldpwd: passwd,
        newpwd: passwd
      }, function(result) {
        result.should.not.be.empty();
        return done();
      });
    });
    it('检测支付密码，设置/修改支付密码', function(done) {
      var passwd, userId;
      userId = '7714d0d83c7f47f4bcfac62b9a1bf101';
      passwd = '123456';
      return request.post(config.api.HAS_PAY_PWD, {
        userId: userId
      }, function(data) {
        var status;
        data.should.not.be.empty();
        status = data.status;
        status.should.be.within(0, 1);
        console.log('支付密码状态', status);
        return request.post(config.api.PAY_PWD, {
          userId: userId,
          payPassword: passwd,
          oldPayPwd: status === 1 ? passwd : void 0
        }, function(result) {
          result.should.not.be.empty();
          return done();
        });
      });
    });
    it('找回支付密码', function(done) {
      var mobile, userId;
      userId = '729667936d0d411daaa946e4592978f0';
      mobile = '13100000010';
      return request.post(config.api.SMS_CODE, {
        mobile: mobile,
        type: 3
      }, function(data) {
        var code;
        data.should.not.be.empty();
        code = data.slice(-6);
        code.should.not.be.empty();
        return request.post(config.api.RESET_PAY_PWD, {
          password: '111111',
          usercode: mobile,
          mobileCode: code,
          userId: userId
        }, function(result) {
          result.should.equal(1);
          return done();
        });
      });
    });
    it('登录', function(done) {
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
    return it('添加评论', function(done) {
      var params;
      params = {
        onsetId: "4671d0d8c37f47f4bcfa2323222bf102",
        onsetRole: "2",
        targetId: "7714d0d83c7f47f4bcfac62b9a1bf101",
        targetRole: "1",
        orderNo: "GC20150912581503100000182",
        score: "10",
        content: "fegsgesgdgsegse"
      };
      return request.post(config.api.LOGIN, params, function(result) {
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
