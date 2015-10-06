(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('钱包_相关', function() {
    return it('根据银行卡号查询银行', function(done) {
      return request.post(config.api.GET_BANK_CARD_INFO, {
        userId: '4671d0d8c37f47f4bcfa2323222bf102',
        cardNo: '6228480097678508670'
      }, function(data) {
        should.exists(data);
        return done();
      });
    });
  });

}).call(this);
