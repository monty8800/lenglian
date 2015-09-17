'use strict'

Dispatcher = require 'dispatch/dispatcher'
Constants = require 'constants/contants'

CarAction = {
	info: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.FOUND_CAR
		}
}

module.exports = CarAction