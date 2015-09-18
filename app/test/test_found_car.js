(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('我要找车', function() {
    return it('我要找车', function(done) {
      var params;
      params = {
        startNo: 1,
        pageSize: 10,
        fromProvinceId: '',
        fromCityId: '',
        fromAreaId: '',
        toProvinceId: '',
        toCityId: '',
        toAreaId: '',
        vehicle: '',
        heavy: '',
        isInvoice: '',
        carType: '',
        id: ''
      };
      return request.post(config.api.found_car, params, function(result) {
        return done();
      });
    });
  });

}).call(this);
