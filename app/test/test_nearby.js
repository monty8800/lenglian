(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('测试附近', function() {
    var api, apiList, i, leftLat, leftLng, len, results, rightLat, rightLng;
    rightLng = '124.075610';
    rightLat = '48.758752';
    leftLng = '108.404454';
    leftLat = '28.953292';
    apiList = [config.api.NEARBY_CAR, config.api.NEARBY_WAREHOUSE, config.api.NEARBY_GOODS];
    results = [];
    for (i = 0, len = apiList.length; i < len; i++) {
      api = apiList[i];
      results.push(it('附近找车', function(done) {
        return request.post(api, {
          leftLng: leftLng,
          leftLat: leftLng,
          rightLng: rightLng,
          rightLat: rightLat
        }, function(data) {
          return done();
        });
      }));
    }
    return results;
  });

}).call(this);
