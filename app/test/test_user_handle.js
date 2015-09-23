(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('用户以通用角色 获取相关自己相关信息 如评论 ', function() {
    it('添加评论', function(done) {
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
      return request.post(config.api.COMMENT_ADD, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    it('查询评论', function(done) {
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
      return request.post(config.api.GET_COMMENT, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    return it('获取某货源的竞价列表', function(done) {
      var params;
      params = {
        userId: '34568979687',
        goodsResourceId: 'yiuytb78697'
      };
      return request.post(config.api.GET_BID_ORDER_LIST, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);