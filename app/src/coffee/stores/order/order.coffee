'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
CarModel = require 'model/order'
Immutable = require 'immutable'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'
OrderAction = require 'actions/order/order'
_user = UserStore.getUser()

_orderList = Immutable.List()
_orderDetail = new CarModel

# 0 货主订单  1 司机订单  2 仓库订单   
_page = -1

window.comeFromFlag = (page)->			
	#  禁止多次相同请求
	console.log page + '~~~~~~~~~~~~~~'
	if _page is page 
		return
	_page = page 
	OrderAction.getOrderList(Constants.orderStatus.st_01, 1)
				
# 订单列表
getOrderList = (status, currentPage)->
	console.log 'get order list from net -- ',currentPage 
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
	}, (success)->
		console.log '----请求成功--', success
		OrderStore.emitChange 'goods'
	, (err) ->
		console.log '----请求失败--', err

# 车主(司机)订单列表
getCarOwnerOrderList = (status, currentPage)->
	console.log 'getCarOwnerOrderList'
	Http.post Constants.api.carowner_order_list, {
		carPersonUserId: _user?.id # 用户id
		pageNow: currentPage # 当前页码
		pageSize: Constants.orderStatus.PAGESIZE
		orderState: status # 全部空 订单状态 1:洽谈中 2:待付款 3:已付款 4:待评价 5:已取消
	}, (success) ->
		console.log '----请求成功--', success
		OrderStore.emitChange 'car'
	, (err)->
		console.log '----请求失败--', err

# 仓库订单列表
getStoreOrderList = (status, currentPage)->
	console.log 'getStoreOrderList'
	Http.post Constants.api.store_order_List, {
		userId: _user?.id
		orderState: status
		pageNow: currentPage
		pageSize: Constants.orderStatus.PAGESIZE
	} ,(success)->
		console.log '----请求成功--', success
		OrderStore.emitChange 'store'
	, (err)->
		console.log '----请求失败--', err

getOrderDetail = (orderId)->
	console.log 'get order detail from net'

OrderStore = assign BaseStore, {
	getOrderList: ->
		_orderList

	getOrderDetail: ->
		_orderDetail
}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.ORDER_LIST then getOrderList(action.status, action.currentPage)
		when Constants.actionType.ORDER_DETAIL then getOrderDetail(action.orderId, action.currentPage)

module.exports = OrderStore
		
