'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
OrderModel = require 'model/order'
Immutable = require 'immutable'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'
OrderAction = require 'actions/order/order'
Goods = require 'model/goods'
DB = require 'util/storage'
Auth = require 'util/auth'
paths = window.location.href.split('/')
_htmlPage = paths[paths.length-1]

_orderList = Immutable.List()
_orderDetail = new OrderModel

_bidGoods = new Goods

_bidList = Immutable.List()

# 0 货主订单  1 司机订单  2 仓库订单   
_page = -1

paths = window.location.href.split('/')
_htmlPage = paths[paths.length-1]

window.comeFromFlag = (page, status)->	
	Auth.needLogin ->	
		# 禁止多次相同请求
		if _page is page 
			return
		_page = page 
		OrderAction.getOrderList(status or Constants.orderStatus.st_01, 1)
	
# 浏览器临时测试
browser_temp = (params)->
	_page = params
	getOrderList 1, 1

# 订单列表
getOrderList = (status, currentPage)->
	switch parseInt(_page)
		when 0 then getGoodsOrderList(status, currentPage)
		when 1 then getCarOwnerOrderList(status, currentPage)
		when 2 then getStoreOrderList(status, currentPage)

# 货主订单列表
getGoodsOrderList = (status, currentPage)->
	console.log 'getGoodsOrderList-----', status, currentPage
	Http.post Constants.api.goods_order_list, {
		userId: UserStore.getUser()?.id
		pageNo: currentPage
		pageSize: Constants.orderStatus.PAGESIZE
		state: status # 订单状态 1:洽谈中 2:待付款 3:已付款 4:待评价 5:已取消 空表示查询所有订单
	}, (data)->
		console.log 'goods order list result', data
		orderList = data.pv.records
		_orderList = _orderList.clear()
		for order in orderList
			do (order) ->
				tempOrder = new OrderModel
				tempOrder = tempOrder.set 'fromCityName', order.fromCityName
				tempOrder = tempOrder.set 'fromCountyName', order.fromCountyName
				tempOrder = tempOrder.set 'fromProvinceName', order.fromProvinceName
				tempOrder = tempOrder.set 'toCityName', order.toCityName
				tempOrder = tempOrder.set 'toCountyName', order.toCountyName
				tempOrder = tempOrder.set 'toProvinceName', order.toProvinceName
				tempOrder = tempOrder.set 'priceType', order.priceType
				tempOrder = tempOrder.set 'goodsDesc', order.goodsDesc
				tempOrder = tempOrder.set 'payType', order.payType			
				tempOrder = tempOrder.set 'orderNo', order.orderNo
				tempOrder = tempOrder.set 'orderType', order.orderType
				tempOrder = tempOrder.set 'orderState', order.orderState
				tempOrder = tempOrder.set 'userHeadPic', order.userHeadPic
				tempOrder = tempOrder.set 'userName', order.userName
				tempOrder = tempOrder.set 'acceptMode', order.acceptMode
				tempOrder = tempOrder.set 'price', order.price
				tempOrder = tempOrder.set 'userId', order.userId
				tempOrder = tempOrder.set 'mjRateflag', order.mjRateflag
				tempOrder = tempOrder.set 'goodsWeight', order.goodsWeight
				tempOrder = tempOrder.set 'goodsCubic', order.goodsCubic
				tempOrder = tempOrder.set 'goodsSourceId', order.goodsSourceId
				tempOrder = tempOrder.set 'goodsPersonUserId', order.goodsPersonUserId
				tempOrder = tempOrder.set 'goodsName',order.goodsName
				tempOrder = tempOrder.set 'goodsType',order.goodsType
				tempOrder = tempOrder.set 'advance',order.advance
				_orderList = _orderList.push tempOrder
		OrderStore.emitChange ['goods']
	, (err) ->
		Plugin.toast.err err.msg

# 车主(司机)订单列表
getCarOwnerOrderList = (status, currentPage)->
	console.log 'getCarOwnerOrderList'
	Http.post Constants.api.carowner_order_list, {
		# carPersonUserId: UserStore.getUser()?.id # 用户id
		userId: UserStore.getUser()?.id
		pageNow: currentPage # 当前页码
		pageSize: Constants.orderStatus.PAGESIZE
		orderState: status # 全部空 订单状态 1:洽谈中 2:待付款 3:已付款 4:待评价 5:已取消
	}, (data) ->
		orderList = data.myCarInfo
		_orderList = _orderList.clear()
		for order in orderList
			do (order) ->
				tempOrder = new OrderModel
				tempOrder = tempOrder.set 'orderNo', order.orderNo
				tempOrder = tempOrder.set 'orderState', order.orderState
				tempOrder = tempOrder.set 'orderType', order.orderType
				tempOrder = tempOrder.set 'goodsDesc', order.goodsDesc
				tempOrder = tempOrder.set 'goodsPersonHeadPic', order.goodsPersonHeadPic
				tempOrder = tempOrder.set 'carPersonName', order.carPersonName
				tempOrder = tempOrder.set 'goodsPersonScore', order.goodsPersonScore
				tempOrder = tempOrder.set 'destination', order.destination
				tempOrder = tempOrder.set 'setOut', order.setOut
				tempOrder = tempOrder.set 'priceType', order.priceType
				tempOrder = tempOrder.set 'goodsName', order.goodsName
				tempOrder = tempOrder.set 'goodsType', order.goodsType
				tempOrder = tempOrder.set 'payType', order.payType
				tempOrder = tempOrder.set 'price', order.price
				tempOrder = tempOrder.set 'carPersonUserId', order.carPersonUserId
				tempOrder = tempOrder.set 'goodSsourceId', order.goodSsourceId
				tempOrder = tempOrder.set 'goodsPersonUserId', order.goodsPersonUserId
				tempOrder = tempOrder.set 'version', order.version
				tempOrder = tempOrder.set 'mjRateflag', order.mjRateflag
				tempOrder = tempOrder.set 'orderCarId', order.orderCarId
				tempOrder = tempOrder.set 'goodsWeight', order.goodsWeight
				tempOrder = tempOrder.set 'goodsCubic', order.goodsCubic
				tempOrder = tempOrder.set 'bidPrice', order.bidPrice
				tempOrder = tempOrder.set 'goodsCubic', order.goodsCubic
				tempOrder = tempOrder.set 'goodsPersonName', order.goodsPersonName
				tempOrder = tempOrder.set 'advance', order.advance

				_orderList = _orderList.push tempOrder
		OrderStore.emitChange ['car']
	, (err)->
		Plugin.toast.err err.msg

# 仓库订单列表
getStoreOrderList = (status, currentPage)->
	console.log 'getStoreOrderList'
	Http.post Constants.api.store_order_List, {
		userId: UserStore.getUser()?.id
		orderState: status
		pageNow: currentPage
		pageSize: Constants.orderStatus.PAGESIZE
	} ,(data)->
		orderList = data.orderList
		_orderList = _orderList.clear()
		for order in orderList
			do (order)->
				tempOrder = new OrderModel
				tempOrder = tempOrder.set 'goodsPersonHeadPic', order.goodsPersonHeadPic
				tempOrder = tempOrder.set 'goodsPersonName', order.goodsPersonName
				tempOrder = tempOrder.set 'goodsPersonScore', order.goodsPersonScore
				tempOrder = tempOrder.set 'warehousePlace', order.warehousePlace
				tempOrder = tempOrder.set 'priceType', order.priceType
				tempOrder = tempOrder.set 'goodsDesc', order.goodsName + order.goodsType
				tempOrder = tempOrder.set 'goodsName', order.goodsName
				tempOrder = tempOrder.set 'goodsType', order.goodsType
				tempOrder = tempOrder.set 'payType', order.payType
				tempOrder = tempOrder.set 'advance',order.advance
				tempOrder = tempOrder.set 'price', order.price
				tempOrder = tempOrder.set 'orderState', order.orderState
				tempOrder = tempOrder.set 'orderType', order.orderType
				tempOrder = tempOrder.set 'warehouseId', order.warehouseId
				tempOrder = tempOrder.set 'orderNo', order.orderNo
				tempOrder = tempOrder.set 'warehousePersonUserId', order.warehousePersonUserId
				tempOrder = tempOrder.set 'version', order.version
				tempOrder = tempOrder.set 'goodsPersonUserId', order.goodsPersonUserId
				tempOrder = tempOrder.set 'warehouseSourceMode', order.warehouseSourceMode
				tempOrder = tempOrder.set 'mjRateflag', order.mjRateflag
				tempOrder = tempOrder.set 'goodsWeight', order.goodsWeight
				tempOrder = tempOrder.set 'goodsCubic', order.goodsCubic

				console.log '_________________________________________________',order.goodsPersonUserId
				_orderList = _orderList.push tempOrder
		OrderStore.emitChange ['store']
	, (err)->
		Plugin.toast.err data.msg

# 竞价列表
getBinddingList = (goodsResourceId) ->
	Http.post Constants.api.GET_BID_ORDER_LIST, {
		userId: UserStore.getUser()?.id
		goodsResourceId: goodsResourceId
	}, (data)->
		OrderStore.emitChange ['bindding_list']
	, (data)->
		Plugin.toast.err data.msg

getOrderDetail = (orderId)->
	console.log 'get order detail from net'

carSelectGoods = (params)->
	Http.post Constants.api.DRIVER_BIND_ORDER, params, (data)->
		console.log 'car select goods result', data
		Plugin.run [3, 'order:car:select:goods:done']
		# OrderStore.emitChange 'order:car:select:goods:done'
	, null
	, true

getBidList = (params)->
	Http.post Constants.api.GET_BID_ORDER_LIST, params, (data)->
		console.log 'get bind list result', data
		_bidList = Immutable.List data
		OrderStore.emitChange 'get:bid:list:done'
		OrderStore.emit 'request:bid:list', 'get:bid:list:done'

carBidGoods = (params)->
	Http.post Constants.api.DRIVER_BID_FOR_GOODS, params, (data)->
		console.log 'car bid goods result ', data
		OrderStore.emitChange 'car:bid:goods:done'
	, (data)->
		Plugin.toast.err data.msg
		# if data.code is '0002'
		# 	Plugin.toast.err '已经竞价3次，不能继续竞价了！'
		# else if data.code is '0001'
		# 	Plugin.toast.err '已经有5个车源参与竞价，不能继续竞价了！'
		# else
		# 	Plugin.toast.err data.msg
	, true

selectBidCar = (params, orderId)->
	Http.post Constants.api.SELECT_BID_CAR, params, (data)->
		Plugin.toast.success '接受订单成功！'
		console.log 'select bid car', data
		console.log '_orderList before', _orderList
		_orderList = _orderList.filterNot (order)->
			console.log order.get('orderNo'), orderId
			order.get('orderNo') is orderId

		console.log '_orderList after', _orderList
		OrderStore.emitChange ['goods']

goodsAgree = (params, orderId)->
	Http.post Constants.api.ORDER_GOODS_AGREE, params, (data)->
		Plugin.toast.success '接受订单成功！'
		console.log 'goods agree', data
		if _htmlPage is 'orderList.html'
			console.log '_orderList before', _orderList
			_orderList = _orderList.filterNot (order)->
				order.get('orderNo') is orderId
			console.log '_orderList after', _orderList
			OrderStore.emitChange ['goods']
		else
			DB.put 'transData', {
				del: orderId
			}
			Plugin.nav.pop()

orderGoodsFinish = (params, orderId)->
	Http.post Constants.api.order_finish, params, (data)->
		Plugin.toast.success '订单已完成！'
		console.log 'order finish', data

		if _htmlPage is 'orderList.html'
			_orderList = _orderList.filterNot (order)->
				order.get('orderNo') is orderId
			OrderStore.emitChange ['goods']
		else
			DB.put 'transData', {
				del: orderId
			}
			Plugin.nav.pop()

# 车主确认订单
_carOwnerConfirmOrder = (carPersonUserId, orderNo, version, orderCarId, index)->
	Plugin.loading.show '正在确认...'
	Http.post Constants.api.car_owner_confirm_order, {
		# carPersonUserId: carPersonUserId
		userId: UserStore.getUser()?.id
		orderNo: orderNo
		version: version
		orderCarId: orderCarId
	}, (data)->
		Plugin.loading.hide()
		Plugin.toast.success '接受订单成功'
		DB.put 'transData', {
			del: orderNo
		}
		OrderStore.emitChange ['car_owner_confirm_order_success', index]
	, (data)->
		Plugin.loading.hide()
		Plugin.toast.err data.msg

_carOwnerConfirmOrder2 = (carPersonUserId, orderNo, version, orderCarId, index)->
	Plugin.loading.show '正在确认...'
	Http.post Constants.api.car_owner_confirm_order, {
		# carPersonUserId: carPersonUserId
		userId: UserStore.getUser()?.id
		orderNo: orderNo
		version: version
		orderCarId: orderCarId
	}, (data)->
		Plugin.loading.hide()
		Plugin.toast.success '接受订单成功'
		DB.put 'detailCallBackFlag', index
		DB.put 'transData', {
			del: orderNo
		}
		Plugin.nav.pop()
	, (data)->
		Plugin.loading.hide()
		Plugin.toast.err data.msg

# 车主取消订单
_carOwnerCancelOrder = (carPersonUserId, orderNo, version, orderCarId, index)->
	Plugin.loading.show '正在取消...'
	Http.post Constants.api.car_owner_cancel_order, {
		# carPersonUserId: carPersonUserId
		userId: UserStore.getUser()?.id
		orderNo: orderNo
		version: version
		orderCarId: orderCarId
	}, (data)->
		DB.put 'detailCallBackFlag', index
		DB.put 'transData', {
			del: orderNo
		}
		Plugin.loading.hide()
		Plugin.toast.success '取消成功'
		Plugin.nav.pop()
	, (data)->
		Plugin.loading.hide()
		Plugin.toast.err data.msg
	

carOwnerOrderDetail = (carPersonUserId, orderNo, goodsPersonUserId, orderCarId)->
	Http.post Constants.api.car_owner_order_detail, {
		carPersonUserId: carPersonUserId
		orderNo: orderNo
		goodsPersonUserId: goodsPersonUserId
		userId: UserStore.getUser()?.id
		orderCarId: orderCarId
	}, (data)->
		temp = data.ownerOrder
		_orderDetail = _orderDetail.set 'orderNo', temp.orderNo
		_orderDetail = _orderDetail.set 'orderState', temp.orderState
		_orderDetail = _orderDetail.set 'orderType', temp.orderType
		_orderDetail = _orderDetail.set 'goodsPersonHeadPic', temp.goodsPersonHeadPic
		_orderDetail = _orderDetail.set 'carPersonName', temp.carPersonName
		_orderDetail = _orderDetail.set 'goodsPersonScore', temp.goodsPersonScore
		_orderDetail = _orderDetail.set 'destination', temp.destination
		_orderDetail = _orderDetail.set 'setOut', temp.setOut
		_orderDetail = _orderDetail.set 'priceType', temp.priceType
		_orderDetail = _orderDetail.set 'goodsDesc', temp.goodsName + temp.goodsType
		_orderDetail = _orderDetail.set 'payType', temp.payType
		_orderDetail = _orderDetail.set 'price', temp.price
		_orderDetail = _orderDetail.set 'carPersonUserId', temp.carPersonUserId
		_orderDetail = _orderDetail.set 'goodsSourceId', temp.goodsSourceId
		_orderDetail = _orderDetail.set 'goodsPersonUserId', temp.goodsPersonUserId
		_orderDetail = _orderDetail.set 'loadingEdate', temp.loadingEdate
		_orderDetail = _orderDetail.set 'loadingSdate', temp.loadingSdate
		_orderDetail = _orderDetail.set 'arrivalSdate', temp.arrivalSdate
		_orderDetail = _orderDetail.set 'arrivalEdate', temp.arrivalEdate
		_orderDetail = _orderDetail.set 'goodsName', temp.goodsName
		_orderDetail = _orderDetail.set 'goodsPackingType', temp.goodsPackingType
		_orderDetail = _orderDetail.set 'goodsType', temp.goodsType
		_orderDetail = _orderDetail.set 'goodsWeight', temp.goodsWeight
		_orderDetail = _orderDetail.set 'goodsPic', temp.goodsPic
		_orderDetail = _orderDetail.set 'shipper', temp.shipper
		_orderDetail = _orderDetail.set 'receiver', temp.receiver
		_orderDetail = _orderDetail.set 'isInvoice', temp.isInvoice
		_orderDetail = _orderDetail.set 'version', temp.version
		_orderDetail = _orderDetail.set 'goodsPersonName', temp.goodsPersonName
		_orderDetail = _orderDetail.set 'certification', data.certification
		_orderDetail = _orderDetail.set 'goodScore', data.goodScore
		_orderDetail = _orderDetail.set 'wishlst', data.wishlst
		_orderDetail = _orderDetail.set 'shipperMobile', temp.shipperMobile
		_orderDetail = _orderDetail.set 'receiverMobile', temp.receiverMobile	
		_orderDetail = _orderDetail.set 'goodsPersonMobile', temp.goodsPersonMobile
		_orderDetail = _orderDetail.set 'createTime', temp.createTime
		_orderDetail = _orderDetail.set 'mjRateflag', temp.mjRateflag
		_orderDetail = _orderDetail.set 'orderCarId', temp.orderCarId
		_orderDetail = _orderDetail.set 'advance', temp.advance
		_orderDetail = _orderDetail.set 'goodsCubic', temp.goodsCubic
		OrderStore.emitChange ['car_owner_order_detail']		
	, (data)->
		Plugin.toast.err data.msg
		Plugin.nav.pop()
	, true

cancel_car_orderlist = (page)->
	Http.post Constants.api.carowner_order_list, {
		carPersonUserId: UserStore.getUser()?.id # 用户id
		pageNow: page # 当前页码
		pageSize: Constants.orderStatus.PAGESIZE
		orderState: '5' # 全部空 订单状态 1:洽谈中 2:待付款 3:已付款 4:待评价 5:已取消
	}, (data) ->
		orderList = data.myCarInfo
		_orderList = _orderList.clear()
		for order in orderList
			do (order) ->
				tempOrder = new OrderModel
				tempOrder = tempOrder.set 'orderNo', order.orderNo
				tempOrder = tempOrder.set 'orderState', order.orderState
				tempOrder = tempOrder.set 'orderType', order.orderType
				tempOrder = tempOrder.set 'goodsPersonHeadPic', order.goodsPersonHeadPic
				tempOrder = tempOrder.set 'carPersonName', order.carPersonName
				tempOrder = tempOrder.set 'goodsPersonScore', order.goodsPersonScore
				tempOrder = tempOrder.set 'destination', order.destination
				tempOrder = tempOrder.set 'setOut', order.setOut
				tempOrder = tempOrder.set 'priceType', order.priceType
				tempOrder = tempOrder.set 'goodsDesc', order.goodsName + order.goodsType
				tempOrder = tempOrder.set 'payType', order.payType
				tempOrder = tempOrder.set 'price', order.price
				tempOrder = tempOrder.set 'carPersonUserId', order.carPersonUserId
				tempOrder = tempOrder.set 'goodSsourceId', order.goodSsourceId
				tempOrder = tempOrder.set 'goodsPersonUserId', order.goodsPersonUserId
				tempOrder = tempOrder.set 'version', order.version
				tempOrder = tempOrder.set 'advance', order.advance

				_orderList = _orderList.push tempOrder
		OrderStore.emitChange ['cancel_car']
	, (err)->
		Plugin.toast.err err.msg

# 完成订单
_orderFinish = (orderNo, version, carPersonUserId)->
	console.log '------orderNo:', orderNo
	Http.post Constants.api.order_state_change, {
		userId: UserStore.getUser()?.id
		orderNo: orderNo			
		version: version
		carPersonUserId: carPersonUserId
	}, (data)->
		Plugin.toast.success '确认订单成功'
		OrderStore.emitChange ['car_owner_cancel_order_success', index]
	, (err)->
		Plugin.toast.err err.msg

# 关注取消关注
_attention = (params)->
	# Plugin.loading.show '正在确认...'
	Http.post Constants.api.attention, params, (data)->
		if params.type is 1
			OrderStore.emitChange ['attention_success']
			Plugin.toast.success '关注成功'
		else 
			OrderStore.emitChange ['nattention_success']
			Plugin.toast.success '取消关注成功'
		# Plugin.loading.hide()
	, (data)->
		# Plugin.loading.hide()
		Plugin.toast.err data.msg

getBidGoodsDetail = (params)->
	Http.post Constants.api.BID_GOODS_DETAIL, params, (data)->
		data.type = data.goodsType
		data.installMinTime = data.installStime
		data.installMaxTime = data.installEtime
		_bidGoods = new Goods data
		console.log  'bid goods', _bidGoods
		OrderStore.emitChange 'bid:goods:detail:done'

orderGoodsDetail = (params)->
	Http.post Constants.api.goods_order_detail, params, (data)->
		console.log 'goods order detail', data
		OrderStore.emitChange {
			msg: 'goods:order:detail:done'
			detail: Immutable.Map data
		}
	, (data)->
		Plugin.toast.err data.msg
		Plugin.nav.pop()
	, true
#TODO:  从列表删除
cancelGoodsOrder = (params)->
	Http.post Constants.api.ORDER_GOODS_CANCEL, params, (data)->
		console.log 'cancelGoodsOrder result', data
		Plugin.toast.success '取消订单成功！'
		DB.put 'transData', {
			del: params.orderNo
		}
		Plugin.nav.pop()

repubGoodsOrder = (params)->
	Http.post Constants.api.ORDER_GOODS_REPUB, params, (data)->
		console.log 'repubGoodsOrder result', data
		Plugin.toast.success '发布成功！'
		Plugin.nav.pop()

getWarehouseOrderDetail = (params) ->
	Http.post Constants.api.store_order_detail, params, (data)->
		console.log 'warehouse order detail _______', data
		OrderStore.emitChange {
			msg: 'warehouse:order:detail:done'
			detail: data
		}

updateStore = ->
	transData = DB.get 'transData'
	if _htmlPage is 'orderList.html'
		if transData?.del
			_orderList = _orderList.filterNot (order)->
				order.get('orderNo') is transData.del
		else if transData?.modify
			_orderList = _orderList.map (order)->
				if order.get('orderNo') is transData.modify
					return order.merge transData.props
				else
					return order
		DB.remove 'transData'
		switch _page
			when 0 then OrderStore.emitChange ['goods']
			# when 1 then OrderStore.emitChange ['car_fresh']
			when 1 then OrderStore.emitChange ['car']
			when 2 then OrderStore.emitChange ['store']
	else
		# 如果是详情页的话，收到消息直接更改状态
		if transData?.props?.mjRateflag is true
			OrderStore.emitChange ['orderDetailCommentUpdate']

window.updateStore = updateStore


warehouseAcceptOrder = (params,index)->
	Http.post Constants.api.WAREHOUSE_ACCEPT_ORDER, params, (data)->
		OrderStore.emitChange ['warehouse:accept:order:done',index]

warehouseCancleOrder = (params,index)->
	Http.post Constants.api.WAREHOUSE_CANCLE_ORDER, params, (data)->
		OrderStore.emitChange ['warehouse:cancle:order:done',index]
		Plugin.toast.success '订单取消成功'
		DB.put 'transData', {
			del: params.orderNo
		}

OrderStore = assign BaseStore, {
	getOrderList: ->
		_orderList

	getOrderDetail: ->
		_orderDetail

	getBidList: ->
		_bidList

	getBidGoods: ->
		_bidGoods
}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.ORDER_LIST then getOrderList(action.status, action.currentPage)
		when Constants.actionType.ORDER_DETAIL then getOrderDetail(action.orderId, action.currentPage)
		when Constants.actionType.ORDER_CAR_SELECT_GOODS then carSelectGoods(action.params)
		when Constants.actionType.GET_BID_LIST then getBidList(action.params)
		when Constants.actionType.ORDER_CAR_BID_GOODS then carBidGoods(action.params)
		when Constants.actionType.BROWSER_TEMP then browser_temp(action.params)
		when Constants.actionType.GET_BIDDING_LIST then getBinddingList(action.goodsResourceId)
		when Constants.actionType.CAR_OWNER_CONFIRM_ORDER then _carOwnerConfirmOrder(action.carPersonUserId, action.orderNo, action.version, action.orderCarId, action.index) 
		when Constants.actionType.CAR_OWNER_CONFIRM_ORDER2 then _carOwnerConfirmOrder2(action.carPersonUserId, action.orderNo, action.version, action.orderCarId, action.index) 
		when Constants.actionType.CAR_OWNER_CANCEL_ORDER then _carOwnerCancelOrder(action.carPersonUserId, action.orderNo, action.version, action.orderCarId, action.index)
		when Constants.actionType.CAR_OWNER_ORDER_DETAIL then carOwnerOrderDetail(action.carPersonUserId, action.orderNo, action.goodsPersonUserId, action.orderCarId)
		when Constants.actionType.ORDER_FINISH then _orderFinish(action.orderNo, action.version, action.carPersonUserId)
		when Constants.actionType.ATTENTION then _attention(action.params)
		when Constants.actionType.GET_BID_GOODS_DETAIL then getBidGoodsDetail(action.params)
		when Constants.actionType.ORDER_SELECT_BID_CAR then selectBidCar(action.params, action.orderId)
		when Constants.actionType.ORDER_GOODS_AGREE then goodsAgree(action.params, action.orderId)
		when Constants.actionType.ORDER_GOODS_FINISH then orderGoodsFinish(action.params, action.orderId)
		when Constants.actionType.ORDER_GOODS_DETAIL then orderGoodsDetail(action.params)
		when Constants.actionType.CANCEL_CAR_ORDER_LIST then cancel_car_orderlist(action.currentPage)
		when Constants.actionType.CANCEL_CAR_ORDER_LIST then cancel_car_orderlist()
		when Constants.actionType.ORDER_WAREHOUSE_DETAIL then getWarehouseOrderDetail(action.params)
		when Constants.actionType.WAREHOUSE_ACCEPT_ORDER then warehouseAcceptOrder(action.params,action.index)
		when Constants.actionType.WAREHOUSE_CANCLE_ORDER then warehouseCancleOrder(action.params,action.index)
		when Constants.actionType.ORDER_GOODS_CANCEL then cancelGoodsOrder(action.params)
		when Constants.actionType.ORDER_GOODS_REPUB then repubGoodsOrder(action.params)


module.exports = OrderStore
		
