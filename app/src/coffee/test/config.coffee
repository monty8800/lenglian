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

		#地址列表
		ADDR_LIST: '/userInfo/queryMjUserAddressList.shtml'




		# 我的仓库详情
		ware_house_detail: '/mjWarehouseCtl/queryMjWarehouseLoad.shtml'
		# 关注列表
		attention_list: '/userInfo/queryMjWishlstList.shtml'
		# 我的车辆
		my_car_list: '/mjCarinfoCtl/queryMjCarinfo.shtml'
		# 添加车辆
		add_car: '/mjCarinfoCtl/addMjCarinfo.shtml'
		# 车辆详情
		car_detail: '/mjCarinfoCtl/queryMjCarinfoLoad.shtml'
		# 省市区
		location_list: '/dictionaryCtl/provinceList.shtml'
		# 我要找车
		found_car: '/searchCarCtl/searchCar.shtml'
		# 添加关注
		add_attention: '/userInfo/addDeleteMjWishlst.shtml'
		# 取消收藏
		cancel_attention: '/userInfo/addDeleteMjWishlst.shtml'
		# 新增地址
		add_address: '/userInfo/addMjUserAddress.shtml'
		# 删除地址
		del_address: '/userInfo/deleteMjUserAddress.shtml'
		# 修改地址
		modify_address: '/userInfo/updateMjUserAddress.shtml'
		# 我的消息
		message_list: '/mjMymessageCtl/queryMymessage.shtml'

	}
}
