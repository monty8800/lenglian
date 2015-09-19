keymirror  = require 'keymirror'

actionType = {
	APP_HELLO: null
	USER_INFO: null
	FOUND_CAR: null
	CAR_LIST: null
	CAR_DETAIL: null
	SMS_CODE: null
	REGISTER: null
}


api = {
	#TODO: api列表
	hello: 'http://www.baidu.com'
	#服务器地址
	server: 'http://192.168.26.176'

	#短信验证码
	SMS_CODE: '/register/sendMobileMsg.shtml'
	#登录
	LOGIN: '/loginCtl/userLogin.shtml'
	#注册
	REGISTER: '/register/registerUser.shtml'

	# 个人中心
	USER_CENTER: '/userInfo/userCenter.shtml'

	# 我的仓库详情
	ware_house_detail: '/mjWarehouseCtl/queryMjWarehouseLoad.shtml'
	# 关注列表
	attention_list: '/userInfo/queryMjWishlstList.shtml'
	# 我的车辆
	my_car_list: '/mjCarinfoCtl/queryMjCarinfo.shtml'
	# 车辆详情
	car_detail: '/mjCarinfoCtl/queryMjCarinfoLoad.shtml'
	# 我要找车
	found_car: '/searchCarCtl/searchCar.shtml'
	
}

smsType = {
	register: 1 #注册
	resetPwd: 2 #重置密码
	resetPayPwd: 3 #重置支付密码
}

module.exports = 
	api: api
	actionType: keymirror actionType
	debug: true
	inBrowser: true
	smsType: smsType
