keymirror  = require 'keymirror'

actionType = {
	APP_HELLO: null
	USER_INFO: null
	FOUND_CAR: null
	CAR_LIST: null
	CAR_DETAIL: null
	SMS_CODE: null
	REGISTER: null
	LOGIN: null
	RESET_PWD: null
	ATTENTION_LIST: null
	ADDRESS_LIST: null
	DEL_ADDRESS: null
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

	#找回密码
	RESET_PWD: '/register/retrievePWD.shtml'

	#修改密码
	CHANGE_PWD: '/loginCtl/changPwd.shtml'

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
	# 关注列表
	attention_list: '/userInfo/queryMjWishlstList.shtml'
	# 地址列表
	address_list: '/userInfo/queryMjUserAddressList.shtml'
	# 删除地址
	del_address: '/userInfo/deleteMjUserAddress.shtml'
	
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
	smsGapTime: 60
