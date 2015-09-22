(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('搜索相关', function() {
    return it('我要找库', function(done) {
      var params;
      params = {
        startNo: '0',
        pageSize: '10',
        provinceId: '99',
        cityId: '5',
        areaId: '9',
        id: '234253654375',
        wareHouseType: [],
        cuvinType: [],
        extensiveBegin: '100',
        extensiveEnd: '200'
      };
      return request.post(config.api.GET_WAREHOUSE, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
