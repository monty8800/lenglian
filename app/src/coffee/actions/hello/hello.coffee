'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

HelloAction = {
	hello: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.APP_HELLO
		}
}

module.exports = HelloAction