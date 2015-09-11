$ = require 'zepto'
Constants = require 'constants/constants'
DB = require 'util/storage'

post = (api, params, cb, key, iv)->
	data = null
	if key
		plainText = JSON.stringify params
		#TODO: 加密
		data = plainText
	else
		data = params

	#没有就从本地取
	uuid = uuid or DB.get 'uuid'
	version = version or DB.get 'version'
	client_type = client_type or DB.get 'client_type'

	if not (uuid && version && client_type)
		console.error 'uuid:', uuid, ',version:', version, ',client_type:', client_type
		return

    #更新本地存储
	DB.put 'uuid', uuid
	DB.put 'version', version
	DB.put 'client_type', client_type

	console.group()
	paramDic = {
		uuid: uuid
		version: version
		client_type: client_type
		data: data
	}
	
	
	console.log '请求接口:', api
	console.log '发送参数:', JSON.stringify(paramDic)

	$.post api, paramDic, (data, status, xhr)->
		console.log '返回数据：', data
		console.groupEnd()
		cb data, status, xhr
	, 'json'

get = (api, cb)->

	console.group()
	console.log '请求接口：', api
	$.get api, (res)->
		console.log '返回数据：', res
		console.groupEnd()
		cb res
	

module.exports = 
	post: post
	get: get