'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

OrderAction = {
	# 获取订单列表
	getOrderList: (statu, pageNo)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_LIST
			status: statu
			currentPage: pageNo
		}

	# 订单详情
	getOrderDetail: (orderid)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_DETAIL
			orderId: orderid
		}

}

module.exports = OrderAction
