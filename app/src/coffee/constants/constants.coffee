keymirror  = require 'keymirror'

actionType = {
	APP_HELLO: null
	USER_INFO: null
}

api = {
	#TODO: api列表
	hello: 'http://www.baidu.com'
	#服务器地址
	server: 'http://192.168.26.176'
	#登录
	LOGIN: '/loginCtl/userLogin.shtml'
	#注册
	REGISTER: '/register/registerUser'

	# 个人中心
	USER_CENTER: '/userInfo/userCenter.shtml'
}

module.exports = 
	api: api
	actionType: keymirror actionType
	debug: true