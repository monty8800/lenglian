'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

CarOrderAction = {
	# 车主订单列表
	orderList: (state)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CARORDERLIST
			status: state
		}

	# 车主订单详情
	orderDetail: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CARORDER_DETAIL
		}

}

module.exports = CarOrderAction