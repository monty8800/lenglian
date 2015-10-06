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
_user = UserStore.getUser()

_orderList = Immutable.List()
_orderDetail = new OrderModel

_bidList = Immutable.List()

# 0 货主订单  1 司机订单  2 仓库订单   
_page = -1

window.comeFromFlag = (page)->			
	# 禁止多次相同请求
	if _page is page 
		return
	_page = page 
	OrderAction.getOrderList(Constants.orderStatus.st_01, 1)

# 浏览器临时测试
browser_temp = (params)->
	_page = params
	getOrderList 1, 1

# 订单列表
getOrderList = (status, currentPage)->
	switch _page
		when 0 then getGoodsOrderList(status, currentPage)
		when 1 then getCarOwnerOrderList(status, currentPage)
		when 2 then getStoreOrderList(status, currentPage)

# 货主订单列表
getGoodsOrderList = (status, currentPage)->
	console.log 'getGoodsOrderList'
	Http.post Constants.api.goods_order_list, {
		userId: _user?.id
		pageNo: currentPage
		pageSize: Constants.orderStatus.PAGESIZE
		state: status # 订单状态 1:洽谈中 2:待付款 3:已付款 4:待评价 5:已取消 空表示查询所有订单
	}, (data)->
		orderList = data.records
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
				tempOrder = tempOrder.set 'goodsDesc', order.goodsName + order.goodsType
				tempOrder = tempOrder.set 'payType', order.payType
				tempOrder = tempOrder.set 'orderNo', order.orderNo
				tempOrder = tempOrder.set 'orderType', order.orderType
				tempOrder = tempOrder.set 'orderState', order.orderState
				tempOrder = tempOrder.set 'userHeadPic', order.userHeadPic
				tempOrder = tempOrder.set 'userName', order.userName
				tempOrder = tempOrder.set 'acceptMode', order.acceptMode
				tempOrder = tempOrder.set 'price', order.price
				tempOrder = tempOrder.set 'goodsSourceId', order.goodsSourceId
				_orderList = _orderList.push tempOrder
		OrderStore.emitChange ['goods']
	, (err) ->
		Plugin.toast.err err.msg

# 车主(司机)订单列表
getCarOwnerOrderList = (status, currentPage)->
	console.log 'getCarOwnerOrderList'
	Http.post Constants.api.carowner_order_list, {
		carPersonUserId: _user?.id # 用户id
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
				tempOrder = tempOrder.set 'goodsPersonHeadPic', order.goodsPersonHeadPic
				tempOrder = tempOrder.set 'carPersonName', order.carPersonName
				tempOrder = tempOrder.set 'goodsPersonScore', order.goodsPersonScore
				tempOrder = tempOrder.set 'destination', order.destination
				tempOrder = tempOrder.set 'setOut', order.setOut
				tempOrder = tempOrder.set 'priceType', order.priceType
				tempOrder = tempOrder.set 'goodsDesc', order.goodsName + order.goodsType
				tempOrder = tempOrder.set 'payType', order.payType
				tempOrder = tempOrder.set 'carPersonUserId', order.carPersonUserId
				tempOrder = tempOrder.set 'goodSsourceId', order.goodSsourceId
				tempOrder = tempOrder.set 'goodsPersonUserId', order.goodsPersonUserId
				_orderList = _orderList.push tempOrder
		OrderStore.emitChange ['car']
	, (err)->
		Plugin.toast.err err.msg

# 仓库订单列表
getStoreOrderList = (status, currentPage)->
	console.log 'getStoreOrderList'
	Http.post Constants.api.store_order_List, {
		userId: _user?.id
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
				tempOrder = tempOrder.set 'payType', order.payType
				tempOrder = tempOrder.set 'price', order.price
				tempOrder = tempOrder.set 'orderState', order.orderState
				tempOrder = tempOrder.set 'orderType', order.orderType
				_orderList = _orderList.push tempOrder
		OrderStore.emitChange ['store']
	, (err)->
		Plugin.toast.err data.msg

# 竞价列表
getBinddingList = (goodsResourceId) ->
	Http.post Constants.api.GET_BID_ORDER_LIST, {
		userId: _user?.id
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

carBidGoods = (params)->
	Http.post Constants.api.DRIVER_BID_FOR_GOODS, params, (data)->
		console.log 'car bid goods result ', data
		OrderStore.emitChange 'car:bid:goods:done'

OrderStore = assign BaseStore, {
	getOrderList: ->
		_orderList

	getOrderDetail: ->
		_orderDetail

	getBidList: ->
		_bidList
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

module.exports = OrderStore
		
