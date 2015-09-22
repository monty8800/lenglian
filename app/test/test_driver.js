(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('明确当前角色是 司机 时的测试', function() {
    it('司机找货', function(done) {
      var params;
      params = {
        startNo: '0',
        pageSize: '10',
        goodsType: '货物类型（数组）',
        fromProvinceId: '99',
        fromCityId: '5',
        fromAreaId: '9',
        toProvinceId: '88',
        toCityId: '9',
        toAreaId: '2',
        priceType: 1,
        coldStoreFlag: 1,
        isInvoice: 1,
        id: '233564756879'
      };
      return request.post(config.api.DRIVER_FIND_GOODS, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    it('车源列表', function(done) {
      var params;
      params = {
        userId: '34567890',
        goodsResourceId: 'f234234tt346453734'
      };
      return request.post(config.api.GET_CARS_FOR_BIND_ORDER, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    it('司机找货抢单', function(done) {
      var params;
      params = {
        userId: '34567890',
        carResourceId: '3456789tyui',
        goodsResourceId: 'f234234tt346453734'
      };
      return request.post(config.api.DRIVER_BIND_ORDER, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    return it('司机找货竞价', function(done) {
      var params;
      params = {
        userId: '324536476586',
        carResourceId: '13423545',
        goodsResourceId: 'qrwt53654',
        price: '1000'
      };
      return request.post(config.api.DRIVER_BID_FOR_GOODS, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
