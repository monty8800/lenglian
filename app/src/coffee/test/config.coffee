module.exports = {
	timeout: 15000
	use_crypto: false
	des_key: '12345678'
	paylod: {
		uuid: 'app_unit_test'
		client_type: '2'
		version: '1.0.0'
		data: {}
	}
	#TODO 接口地址
	api: {
		server: 'http://192.168.26.177:7080/llmj-app/'
		#server: 'http://192.168.29.176:8072/'
		#server: 'http://m.lenglianmajia.com'
		#登录
		LOGIN: '/loginCtl/userLogin.shtml'
		#注册
		REGISTER: '/register/registerUser.shtml'
		#短信验证码
		SMS_CODE: '/register/sendMobileMsg.shtml'
		# 个人中心
		USER_CENTER: '/userInfo/userCenter.shtml'
	}
}