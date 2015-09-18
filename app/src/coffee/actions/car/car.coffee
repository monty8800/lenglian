'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

CarAction = {
	info: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.FOUND_CAR
		}
	# 车辆列表
	carList: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_LIST
		}

	# 车辆详情
	carDetail: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_DETAIL
		}
}

module.exports = CarAction