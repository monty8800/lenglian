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
	DELETE_WAREHOUSE:null
	UPDATE_WAREHOUSE:null
	WAREHOUSE_DETAIL:null
	WAREHOUSE_SEARCH_DETAIL:null
	WAREHOUSE_ADD:null
	RELEASE_WAREHOUSE:null
	CHANGE_PWD: null
	LOGOUT: null

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
	GET_GOODS_LIST:null
	GET_GOODS_DETAIL:null
	GET_SEARCH_GOODS_DETAIL:null
	WAREHOUSE_ACCEPT_ORDER:null
	WAREHOUSE_CANCLE_ORDER:null
	GOODS_BIND_WAREHOUSE_ORDER:null

	GET_WALLET_IN_OUT:null
	ADD_BANK_CARD_COMMPANY:null
	ADD_BANK_CARD_PRIVET:null
	VERITY_PHONE_FOR_BANK:null
	GET_BANK_CARD_INFO:null
	GET_BANK_LIST:null
	REMOVE_BANK_CARD:null
	DELETE_GOODS:null

	PERSONAL_AUTH: null
	COMPANY_AUTH: null
	CLEAR_AUTH_PIC: null
	
	WAREHOUSE_SEARCH_GOODS:null

	UPDATE_USER: null

	CARORDERLIST: null
	CARORDER_DETAIL: null

	ORDER_LIST: null
	ORDER_DETAIL: null

	CITY_LIST: null
	SELECT_ADDRESS: null
	CHANGE_SELECTOR: null
	RELEASE_CAR: null

	UPDATE_STORE: null

	LOCATE: null
	ADD_CAR:null

	EDIT_ADDRESS: null
	NEW_ADDRESS: null
	SELECT_LIST_ADDRESS: null

	GOODS_ADD_PASS_BY: null

	FREEDOM_CAR: null

	CHECKED_LEN_ALL: null
	UNCHECKED_LEN_ALL: null
	CHECKED_LEN_ST: null
	UNCHECKED_LEN_ST: null
	CLOSE_CAR_LEN: null
	CHECKED_HEA_ALL: null
	UNCHECKED_HEA_ALL: null
	CHECKED_HEA_ST: null
	UNCHECKED_HEA_ST:null
	HAHAHA: null
	CLOSE_CAR_HEA: null
	CLOSE_INVOINCE: null
	NEEDINV: null
	NOTNEEDINV: null

	ADD_GOODS: null
	CLEAR_GOODS_PIC: null
	CLEAR_GOODS: null

	DEL_CAR: null
	MODIFY_CAR:null


	UPDATE_SELECTION: null

	CAR_OWNER_DETAIL: null

	ATTENTION_DETAIL: null

	UPDATE_INV_STATUS: null

	SEARCH_GOODS: null

	ORDER_SELECT_CAR_LIST: null

	CHANGE_WIDGET_STATUS: null

	ORDER_CAR_SELECT_GOODS: null
	ORDER_CAR_BID_GOODS: null

	GET_BID_LIST: null

	GET_BID_GOODS_DETAIL: null

	ADD_CAR_SELECTION: null

	BROWSER_TEMP: null
	
	GET_BIDDING_LIST: null
	CAR_OWNER_CONFIRM_ORDER: null
	CAR_OWNER_CONFIRM_ORDER2: null
	CAR_OWNER_CANCEL_ORDER: null
	CAR_OWNER_ORDER_DETAIL: null
	ORDER_FINISH: null
	ATTENTION: null
	ORDER_SELECT_BID_CAR: null
	ORDER_GOODS_AGREE: null
	ORDER_GOODS_FINISH: null
	ORDER_GOODS_DETAIL: null
	ORDER_WAREHOUSE_DETAIL:null

	ORDER_GOODS_CANCEL: null

	ORDER_GOODS_REPUB: null

	FOLLOW: null

	CANCEL_CAR_ORDER_LIST: null


	GET_PAY_INFO: null
	HIDE_PAY_SMS: null

	PAY_NOTI: null
	DO_PAY: null
	RATY_CHANGE: null
	INVST: null
	INVNOTST: null

	GET_SUPPORT_BANK_LIST: null
	GOODS_MINUS_PASS_BY: null

	SELECT_PAY_CARD: null

	WITHDRAW: null

	SELECT_WITHDRAW_CARD: null
	CHARGE: null

}

								
api = {
	#TODO: api列表
	hello: 'http://www.baidu.com'
	#服务器地址

	
	server: 'http://192.168.26.177:7080/llmj-app/'

	#注意！⚠️浏览器里请去gulpfile里面改接口地址，这里改不起作用

	# server: 'http://192.168.29.176:8072/'		
	# server: 'http://192.168.29.149:8072/'
	# server: 'http://192.168.29.203:8072/'	
	# server:'http://192.168.27.160:8080/llmj-app/' #高
	# server:'http://192.168.28.12:8080/llmj-app/' #高

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

	#修改头像
	SET_AVATAR: '/loginCtl/changHeadPic.shtml'

	#个人认证
	PERSONAL_AUTH: '/mjPersonInfoAuthCtl/personInfoAuth.shtml'
	#公司认证
	COMPANY_AUTH: '/enterprise/enterpriseAuthentication.shtml'

	#城市列表
	CITY_LIST: '/dictionaryCtl/provinceList.shtml'

	#编辑地址
	EDIT_ADDRESS: '/userInfo/updateMjUserAddress.shtml'
	#添加地址
	ADD_ADDRESS: '/userInfo/addMjUserAddress.shtml'

	#添加货源
	ADD_GOODS: '/mjGoodsResource/addGoodsResource.shtml'

	#竞价页面数据
	BID_GOODS_DETAIL: '/carFindGoods/orderBidDetail.shtml'

	#选择竞价司机
	SELECT_BID_CAR: '/orderGoods/selectBidCar.shtml'

	#货主接受订单
	ORDER_GOODS_AGREE: '/orderGoods/accept.shtml'

	#货主取消订单
	ORDER_GOODS_CANCEL: '/orderGoods/cancel.shtml'

	#货主重新发布订单
	ORDER_GOODS_REPUB: '/orderGoods/rePublish.shtml'

	#获取支付页面数据
	GET_PAY_INFO: '/orderPay/toPay.shtml'

	#支付订单
	PAY_ORDER: '/orderPay/pay.shtml'

	#获取个人认证信息
	GET_PERSONAL_AUTH_INFO: '/mjPersonInfoAuthCtl/queryMjPersonInfo.shtml'

	#获取公司认证信息
	GET_COMPANY_AUTH_INFO: '/enterprise/queryEnterpriseInfo.shtml'

	#获取支持的银行列表
	GET_SUPPORT_BANK_LIST: '/mjUserBankCard/queryBankInfo.shtml'

	#提现
	WITHDRAW: '/mjTransferCtl/transferCash.shtml'

#YYQ
	# 查询我的仓库
	GET_WAREHOUSE: '/mjWarehouseCtl/queryMjWarehouse.shtml'
	#删除我的仓库
	DELETE_WAREHOUSE:'/mjWarehouseCtl/deleteMjWarehouse.shtml'
	#修改我的仓库
	UPDATE_WAREHOUSE:'/mjWarehouseCtl/updateMjWarehouse.shtml'
	#我的仓库详情
	WAREHOUSE_DETAIL: '/mjWarehouseCtl/queryMjWarehouseLoad.shtml'
	#通过搜索进入仓库详情
	WAREHOUSE_SEARCH_DETAIL: '/mjWarehouseCtl/queryMjWarehouseLoad.shtml'
	#添加仓库
	WAREHOUSE_ADD: '/mjWarehouseCtl/addMjWarehouse.shtml'
	#发布库源
	RELEASE_WAREHOUSE: '/mjWarehouseCtl/addMjWarehouseResource.shtml'
	#我要找库
	SEARCH_WAREHOUSE: '/searchWarehouseCtl/searchWarehouse.shtml'
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

	#仓库找货(搜索)
	WAREHOUSE_SEARCH_GOODS: '/warehouseSearchGoods/warehouseSearchGoodsList.shtml'

	#货找库下单
	GOODS_BIND_WAREHOUSE_ORDER:'/mjOrderWarhouse/addGoodsFoundWarhouseOrder.shtml'



	# 查询我的货源
	GET_GOODS_LIST: '/mjGoodsResource/queryMjGoodsResourceList.shtml'
	#查询货源详情
	GET_GOODS_DETAIL: '/mjGoodsResource/queryMjGoodsResource.shtml'
	#搜索货源时进入货源详情
	GET_SEARCH_GOODS_DETAIL: '/mjGoodsResource/queryMjGoodsResource.shtml'
	#仓库接受订单
	WAREHOUSE_ACCEPT_ORDER: '/mjOrderWarhouse/warehouseConfirmOrder.shtml'
	# 仓库拒绝订单 (取消)
	WAREHOUSE_CANCLE_ORDER: 'mjOrderWarhouse/warehouseCancelOrder.shtml'

#支付相关 钱包
	#我的收入和支出
	GET_WALLET_IN_OUT: '/myWalletCtl/queryPayIncomeOrOut.shtml'
	#添加企业银行卡
	ADD_BANK_CARD_COMMPANY: '/mjUserBankCard/addMjEnterPriseUserBankCard.shtml'
	#添加个人银行卡及绑定
	ADD_BANK_CARD_PRIVET: '/mjUserBankCard/addMjUserBankCard.shtml'
	#验证预留手机号码
	VERITY_PHONE_FOR_BANK: '/mjUserBankCard/validateMjUserBankCard.shtml'
	#根据银行卡号查询银行
	GET_BANK_CARD_INFO: '/mjUserBankCard/queryBankType.shtml'
	#查询银行列表
	GET_BANK_LIST: '/mjUserBankCard/queryBankCardList.shtml'
	#解绑银行卡
	REMOVE_BANK_CARD: '/mjUserBankCard/deleteMjUserBankCard.shtml'

#货相关
	#删除货源
	DELETE_GOODS: 'mjGoodsResource/delGoodsResource.shtml'

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
	# 发布车源
	release_car: '/mjCarinfoCtl/addCarResource.shtml'
	# 添加车源
	add_car: '/mjCarinfoCtl/addMjCarinfo.shtml'
	# 车辆详情
	detail_car: '/mjCarinfoCtl/deleteMjCarinfo.shtml'
	# 编辑车辆
	modify_car: '/mjCarinfoCtl/updateMjCarinfo.shtml'
	# 我的车辆---空闲中
	car_free_list: '/mjCarinfoCtl/queryMjCarinfoFree.shtml'
	# 关注
	attention: '/userInfo/addDeleteMjWishlst.shtml'
	# 车主确认订单
	car_owner_confirm_order: '/ownerOrderCtl/ownerConfirmOrder.shtml'
	# 车主取消订单
	car_owner_cancel_order: '/ownerOrderCtl/ownerCancelOrder.shtml'
	# 车主订单详情
	car_owner_order_detail: '/ownerOrderCtl/ownerOrderDetail.shtml'
	# 完成订单
	order_finish: '/orderGoods/orderFinish.shtml'
	# 车主订单状态改变
	order_state_change: '/ownerOrderCtl/ownerOrderState.shtml'

	charge_bank: '/mjUserRechargeOrderCtl/addMjUserRechargeOrder.shtml'

}

smsType = {
	register: 1 #注册
	resetPwd: 2 #重置密码
	resetPayPwd: 3 #重置支付密码
	payOrder: 5 #订单支付
}

authType = {
	GOODS: 1 #货主
	CAR: 2 #车主
	WAREHOUSE: 3 #仓库
}

orderStatus = {
	st_01: '1' # 洽谈中
	st_02: '2' # 待付款
	st_03: '3' # 已付款
	st_04: '4' # 待评价
	st_05: '5' # 已取消
	PAGESIZE: '10' # 每页记录数
}

cache = {
	CITY_LIST: 7 * 24 * 60 * 60 * 1000
	USER_INFO: 3 * 60 * 1000 #更新用户信息的间隔
	USER_INFO_MIN: 30 * 1000 #更新用户信息最小间隔
	SUPPORT_BANK_LIST: 7 * 24 * 60 * 60 * 1000 #支持银行列表
}

carPicSize = '200x200'

imageServer = 'http://qa-pic.lenglianmajia.com/'

module.exports = 
	api: api
	actionType: keymirror actionType
	debug: true
	inBrowser: not window.cordova
	smsType: smsType
	smsGapTime: 120
	authType: authType
	orderStatus: orderStatus
	cache: cache
	imageServer: imageServer
	carPicSize: carPicSize
