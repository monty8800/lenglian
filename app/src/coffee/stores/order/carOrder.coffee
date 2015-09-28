'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
CarOrderModel = require 'model/carOrder'
Immutable = require 'immutable'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'


_user = UserStore.getUser()

CarOrderList = Immutable.List()

carDetail = new CarOrderModel

window.temp = ->
	Plugin.debug 'aaa'

# 车主订单列表
CarOrderListMethod = (status)->
	console.log '----CarOrderListMethod--',status 				
	Http.post Constants.api.carowner_order_list, {
		carPersonUserId: _user?.id
		pageNow: 1
		pageSize: 10
		orderState: status
	}, (data)->
		console.log '请求结果--data: ', data.myCarInfo.length
		if data.myCarInfo.length is 0
			Plugin.toast.err '没有相关数据'

		for carInfo in data.myCarInfo
			do (carInfo) ->
				car = new CarOrderModel
				car = car.set 'carPersonName', carInfo.carPersonName
				car = car.set 'goodsPersonHeadPic', carInfo.goodsPersonHeadPic
				car = car.set 'destination', carInfo.destination
				car = car.set 'setOut', carInfo.setOut
				car = car.set 'priceType', carInfo.priceType
				car = car.set 'goodsDesc', carInfo.goodsName + carInfo.goodsWeight + carInfo.goodsType
				car = car.set 'payType', carInfo.payType
				car = car.set 'price', carInfo.price
				car = car.set 'advance', carInfo.advance
				CarOrderList.push car
		CarOrderStore.emitChange()

	, (result)->
		Plugin.toast.success result.msg

# 车主订单详情
CarOrderDetailMethod = ->
	console.log '----CarOrderDetailMethod'


CarOrderStore = assign BaseStore, {
	getCarOrderList: ->
		CarOrderList

	getCarOrderDetail: ->
		carDetail

}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.CARORDERLIST then CarOrderListMethod(action.status)
		when Constants.actionType.CARORDER_DETAIL then CarOrderDetailMethod()

module.exports = CarOrderStore

