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
	RESET_PAY_PWD: null
	ATTENTION_LIST: null
	ADDRESS_LIST: null
	DEL_ADDRESS: null
	MSG_LIST: null
	PAY_PWD: null
	GET_WAREHOUSE:null
	WAREHOUSE_DETAIL:null
	CHANGE_PWD: null
	SEARCH_WAREHOUSE:null
	COMMENT_ADD:null
	PERSONINFO_AUTH:null
	COMMENT_ADD:null
	GET_COMMENT:null
	DRIVER_FIND_GOODS:null
	GET_CARS_FOR_BIND_ORDER:null
	DRIVER_BIND_ORDER:null
	DRIVER_BID_FOR_GOODS:null
	GET_BID_ORDER_LIST:null
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

	#判断是否有支付密码
	HAS_PAY_PWD: '/myWalletCtl/isPayPassword.shtml'
	#设置／修改支付密码
	PAY_PWD: '/myWalletCtl/payPassword.shtml'
	#找回支付密码
	RESET_PAY_PWD: '/myWalletCtl/resetPayPassword.shtml'


	# 个人中心
	USER_CENTER: '/userInfo/userCenter.shtml'


#YYQ
	# 查询我的仓库
	GET_WAREHOUSE: '/mjWarehouseCtl/queryMjWarehouse.shtml'
	#删除我的仓库
	DELETE_WAREHOUSE:'/mjWarehouseCtl/deleteMjWarehouse.shtml'
	#修改我的仓库
	UPDATE_WAREHOUSE:'/mjWarehouseCtl/updateMjWarehouse.shtml'
	#我的仓库详情
	WAREHOUSE_DETAIL: '/mjWarehouseCtl/queryMjWarehouseLoad.shtml'
	#添加仓库
	WAREHOUSE_ADD: '/mjWarehouseCtl/addMjWarehouse.shtml'
	#我要找库
	SEARCH_WAREHOUSE: '/searchWarehouseCtl/searchWarehouse.shtml'
	#个人认证
	PERSONINFO_AUTH: 'mjPersonInfoAuthCtl/personInfoAuth.shtml'
	#添加评论
	COMMENT_ADD: '/mjRate/addMjRate.shtml'
	# 查询评价
	GET_COMMENT: '/mjRate/queryMjRateList.shtml'
	#司机找货
	DRIVER_FIND_GOODS: '/carFindGoods/list.shtml'
	#司机 竞价/抢单 时获取自己车源列表
	GET_CARS_FOR_BIND_ORDER: '/carFindGoods/listCarResources.shtml'
	#司机找货抢单
	DRIVER_BIND_ORDER: '/carFindGoods/orderTrade.shtml'
	#司机为货物 竞价
	DRIVER_BID_FOR_GOODS:'/carFindGoods/orderBid.shtml'
	#获取某货源的竞价列表
	GET_BID_ORDER_LIST: '/carFindGoods/orderBidList.shtml'




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
	# 我的消息
	message_list: '/mjMymessageCtl/queryMymessage.shtml'

	
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
	inBrowser: not window.cordova
	smsType: smsType
	smsGapTime: 60
