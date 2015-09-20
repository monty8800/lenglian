(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('测试银行卡', function() {
    return it('根据卡号查询银行', function(done) {
      var cardNo;
      cardNo = '6222001901100106378';
      return request.post(config.api.QUERY_BANK_BY_CARD, {
        cardNo: cardNo
      }, function(result) {
        result.should.not.be.empty();
        result.bankName.should.not.be.empty();
        result.bankType.should.not.be.empty();
        return done();
      });
    });
  });

}).call(this);
