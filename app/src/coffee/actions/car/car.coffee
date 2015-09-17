'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

CarAction = {
	info: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.FOUND_CAR
		}
}

module.exports = CarAction