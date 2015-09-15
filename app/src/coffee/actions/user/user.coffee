'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

UserAction = {
	info: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.USER_INFO
		}
}

module.exports = UserAction