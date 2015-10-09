$ = require 'zepto'
Constants = require 'constants/constants'
DB = require 'util/storage'
UUID = require 'util/uuid'
Plugin = require 'util/plugin'
# request = require 'superagent'

postFile = (api, params, files, cb, err)->
	data = JSON.stringify params

	#浏览器中调试，生成假的数据
	if Constants.inBrowser
		uuid = UUID.v4()
		version = '1.0'
		client_type = '2'

	#没有就从本地取
	uuid = window.uuid or DB.get 'uuid'
	version = window.version or DB.get 'version'
	client_type = window.client_type or DB.get 'client_type'

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
	
	api = Constants.api.server + api if api.indexOf('http') isnt 0 and not Constants.inBrowser
	console.log '请求接口:', api
	console.log '发送参数:', JSON.stringify(paramDic)

	Plugin.run [7, api, paramDic, files]
	# req = request.post(api)
	#    .type('form')
	#    .query(paramDic)
	# for file in files
	# 	console.log 'file', file
	# 	req = req.attach file.filed, file.path, file.name if file.path

	# console.log 

	# req.end (error, res)->
	# 	Plugin.loading.hide()
	# 	if error
	# 		Plugin.toast '图片上传失败'
	# 	else
	# 		result = null;
	# 		try
	# 			result = JSON.parse res.text
	# 		catch e
	# 			console.error res.text
	# 			Plugin.toast.err '出错啦！请稍候重试'
	# 			return
	# 		if result.code isnt '0000'
	# 			return err result if err
	# 			console.error "错误码: #{result.code}, 错误信息: #{result.msg}"
	# 			if Constants.inBrowser
	# 				alert "接口：#{api},错误信息：#{result.msg}"
	# 			else
	# 				Plugin.toast.err result.msg
	# 		else
	# 			cb result.data


post = (api, params, cb, err, showLoading, key, iv)->
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
		client_type = '2'

	#没有就从本地取
	uuid = window.uuid or DB.get 'uuid'
	version = window.version or DB.get 'version'
	client_type = window.client_type or DB.get 'client_type'

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
	
	api = Constants.api.server + api if api.indexOf('http') isnt 0 and not Constants.inBrowser
	console.log '请求接口:', api
	console.log '发送参数:', JSON.stringify(paramDic)

	Plugin.loading.show() if showLoading
	$.post api, paramDic, (data, status, xhr)->
		console.log '请求状态', status
		Plugin.loading.hide() if showLoading
		if status is 0
			Plugin.toast.err '暂时无法连接网络，请检查网络设置'
			return
		if status isnt 'success'
			Plugin.toast.err '请求出错'
			return

		console.log '返回数据：', JSON.stringify(data)
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
	postFile: postFile
	get: get