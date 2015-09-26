'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

CarAction = {
	info: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.FOUND_CAR
		}
	# 车辆列表
	carList: (statu)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_LIST
			status: statu
		}

	# 车辆详情
	carDetail: (carid)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_DETAIL
			carId: carid
		}

	# 发布车源
	releaseCar: ->
		console.log '--------action'
		Dispatcher.dispatch {
			actionType: Constants.actionType.RELEASE_CAR
		}
}

module.exports = CarAction
