request = require 'superagent'
config = require './config.js'
should = require 'should'

post = (api, params, cb)->
	if config.use_crypto is true
		#TODO 加密
		plainText = JSON.stringify params
		config.paylod.data = plainText
	else
		config.paylod.data = params

	if api.indexOf 'http' isnt 0
		api = config.api.server + api

	console.log '请求接口：', api
	console.log '发送参数：', config.paylod
	if config.use_crypto is true
		console.log '加密前的参数：', params

	request.post(api)
	       .type('form')
	       .send(config.paylod)
	       .end (err, res)->
	       	should.ifError err
	       	result = null;
	       	try
	       		result = JSON.parse res.text
	       	catch e
	       		console.error res.text
	       		j = new should.Assertion(res.text)
	       		j.params = {
	       			operator: 'json 格式'
	       		}
	       		j.fail()

	       	console.log '返回值：', JSON.stringify(result)
	       	result.should.not.empty '返回值不能为空'
	       	result.code.should.equal '0000', '错误码:', result.code, ',错误信息:', result.msg
	       	cb result

module.exports = {
	    post: post
	}	       	
	
	
	