(function() {
  var config, post, request, should;

  request = require('superagent');

  config = require('./config.js');

  should = require('should');

  post = function(api, params, cb) {
    var plainText;
    if (config.use_crypto === true) {
      plainText = JSON.stringify(params);
      config.paylod.data = plainText;
    } else {
      config.paylod.data = JSON.stringify(params);
    }
    if (api.indexOf('http' !== 0)) {
      api = config.api.server + api;
    }
    console.log('请求接口：', api);
    console.log('发送参数：', config.paylod);
    if (config.use_crypto === true) {
      console.log('加密前的参数：', params);
    }
    return request.post(api).type('form').send(config.paylod).end(function(err, res) {
      var e, error, j, result;
      should.ifError(err);
      result = null;
      try {
        result = JSON.parse(res.text);
      } catch (error) {
        e = error;
        console.error(res.text);
        j = new should.Assertion(res.text);
        j.params = {
          operator: 'json 格式'
        };
        j.fail();
      }
      console.log('返回值：', JSON.stringify(result));
      result.should.not.empty('返回值不能为空');
      result.code.should.equal('0000', '错误码:', result.code, ',错误信息:', result.msg);
      return cb(result.data);
    });
  };

  module.exports = {
    post: post
  };

}).call(this);
