(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('关注列表', function() {
    return it('关注列表', function(done) {
      var params;
      params = {
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        focustype: '1'
      };
      return request.post(config.api.attention_list, params, function(result) {
        return done();
      });
    });
  });

}).call(this);
