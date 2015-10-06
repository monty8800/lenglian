(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('钱包_相关', function() {
    return it('添加个人银行卡及绑定(农行)', function(done) {
      return request.post(config.api.ADD_BANK_CARD_PRIVET, {
        id: '7201beba475b49fd8b872e2d1493844a',
        userId: '7201beba475b49fd8b872e2d1493844a',
        cardName: '金穗通宝卡(银联卡)',
        cardNo: '6228480097678508670',
        blankName: '瑞士银行',
        cardType: '借记卡',
        bankMobile: '15321720999',
        userIdNumber: '363241199005251325',
        mobileCode: '5689',
        bankCode: '078403e4d180a28621',
        zfNo: '105',
        bankBranchName: '南环路支行'
      }, function(data) {
        should.exists(data);
        return done();
      });
    });
  });

}).call(this);
