(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('测试用户', function() {
    return it('个人中心', function(done) {
      var userId;
      userId = '7714d0d83c7f47f4bcfac62b9a1bf101';
      return request.post(config.api.USER_CENTER, {
        userId: userId
      }, function(result) {
        should.exists(result);
        result.carStatus.should.be.within(0, 1);
        result.certification.should.be.within(0, 2);
        result.goodsStatus.should.be.within(0, 1);
        result.imgurl.should.not.be.empty();
        result.myCarCount.should.be.Number();
        result.myMessageCount.should.be.Number();
        result.myWishlistCount.should.be.Number();
        result.userId.should.equal(userId);
        result.usercode.should.not.be.empty();
        result.warehouseStatus.should.be.within(0, 1);
        return done();
      });
    });
  });

}).call(this);
