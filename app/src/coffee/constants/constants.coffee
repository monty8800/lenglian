keymirror  = require 'keymirror'

actionType = {
	APP_HELLO: null
	USER_INFO: null
	FOUND_CAR: null
	CAR_LIST: null
	CAR_DETAIL: null
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

module.exports = 
	api: api
	actionType: keymirror actionType
	debug: true
	inBrowser: true
