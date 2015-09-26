'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

CommonAction = {
	updateStore: ->
		console.log 'localstorage changed, update store!'
		Dispatcher.dispatch {
			actionType: Constants.actionType.UPDATE_STORE
		}
}

module.exports = CommonAction