(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('测试用户', function() {
    return it('修改头像', function(done) {
      var files;
      files = [
        {
          filed: 'file',
          path: 'src/images/car-02.jpg',
          name: 'avatar.jpg'
        }
      ];
      return request.postFile(config.api.SET_AVATAR, {
        userId: '50819ab3c0954f828d0851da576cbc31'
      }, files, function(data) {
        data.should.equal(1);
        return done();
      });
    });
  });

}).call(this);
