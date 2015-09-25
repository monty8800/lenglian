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
		# server: 'http://192.168.29.176:8072/'
		#server: 'http://m.lenglianmajia.com'
		#server: 'http://192.168.28.90:8072/' #朱舟 
		
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
		#根据卡号查银行
		QUERY_BANK_BY_CARD: '/mjUserBankCard/queryBankType.shtml'

		#附近找车
		NEARBY_CAR: '/findNear/nearCar.shtml'
		SEARCH_CAR_DETAIL: '/searchCarCtl/searchCar.shtml'

		#附近找仓库
		NEARBY_WAREHOUSE: '/findNear/nearWarehouse.shtml'
		SEARCH_WAREHOUSE_DETAIL: '/searchWarehouseCtl/searchWarehouse.shtml'

		#附近找货
		NEARBY_GOODS: '/findNear/nearGoods.shtml'
		SEARCH_GOODS_DETAIL: '/carFindGoods/list.shtml'

		#企业认证
		COMPANY_AUTH: '/enterprise/enterpriseAuthentication.shtml'




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
		PERSONINFO_AUTH: '/mjPersonInfoAuthCtl/personInfoAuth.shtml'
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
		GET_ORDER_BID_LIST: '/carFindGoods/orderBidList.shtml'
		
		#仓库找货(搜索)
		WAREHOUSE_SEARCH_GOODS: '/warehouseSearchGoods/warehouseSearchGoodsList.shtml'


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
		# 车主订单列表
		carowner_order_list: '/ownerOrderCtl/ownerOrderlst.shtml'
		# 车主订单详情
		carowner_order_detail: '/ownerOrderCtl/ownerOrderDetail.shtml'
		# 货主订单列表
		goods_order_list: '/orderGoods/list.shtml'
		# 货主订单详情
		goods_order_detail: '/orderGoods/detail.shtml'
		# 仓库订单列表
		store_order_List: '/mjOrderWarhouse/queryWarhousefoundGoodsOrderList.shtml'
		# 仓库订单详情
		store_order_detail: '/mjOrderWarhouse/queryWarhousefoundGoodsOrderInfo.shtml'


	}
}
