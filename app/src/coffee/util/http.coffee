$ = require 'zepto'
Constants = require 'constants/constants'
DB = require 'util/storage'
UUID = require 'util/uuid'
Plugin = require 'util/plugin'

post = (api, params, cb, err, key, iv)->
	data = null
	if key
		plainText = JSON.stringify params
		#TODO: 加密
		data = plainText
	else
		data = JSON.stringify params

	#浏览器中调试，生成假的数据
	if Constants.inBrowser
		uuid = UUID.v4()
		version = '1.0'
		client_type = '1'

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
	api = Constants.api.server + api if api.indexOf('http') isnt 0 and not Constants.inBrowser

	$.post api, paramDic, (data, status, xhr)->
		if status is 0
			Plugin.toast.err '暂时无法连接网络，请检查网络设置'
			return

		console.log '返回数据：', data
		console.groupEnd()
		if data.code isnt '0000'
			return err data if err
			console.error "错误码: #{data.code}, 错误信息: #{data.msg}"
			if Constants.inBrowser
				alert "接口：#{api},错误信息：#{data.msg}"
			else
				Plugin.toast.err data.msg
		else
			cb data.data
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