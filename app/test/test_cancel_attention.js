(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('取消关注', function() {
    return it('取消关注', function(done) {
      return request.post(config.api.cancel_attention, {
        id: '7714d0d83c7f47f4bcfac62b9a1bf101',
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
      }, function(data) {
        return done();
      });
    });
  });

}).call(this);
