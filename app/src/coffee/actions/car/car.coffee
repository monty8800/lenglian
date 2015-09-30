'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

CarAction = {
	info: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.FOUND_CAR
		}

	carList: (statu)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_LIST
			status: statu
		}

	carDetail: (carid)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_DETAIL
			carId: carid
		}

	addCar: (params, files)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.ADD_CAR
			params: params
			files: files
		}

	releaseCar: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.RELEASE_CAR
			params: params
		}

	getFreedomCar: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.FREEDOM_CAR
		}

}

module.exports = CarAction
