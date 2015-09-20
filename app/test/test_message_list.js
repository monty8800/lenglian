(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('我的消息', function() {
    return it('我的消息', function(done) {
      return request.post(config.api.message_list, {
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        userRole: '1'
      }, function(result) {
        return done();
      });
    });
  });

}).call(this);
