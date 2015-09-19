(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('添加关注', function() {
    return it('添加关注', function(done) {
      return request.post(config.api.add_attention, {
        focusid: '4671d0d8c37f47f4bcfa2323222bf102',
        focustype: '1',
        userId: '4671d0d8c37f47f4bcfa2323222bf102'
      }, function(data) {
        return done();
      });
    });
  });

}).call(this);
