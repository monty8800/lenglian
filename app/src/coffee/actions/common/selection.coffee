'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

SelectionAction = {
	updateSelection: (type, list)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.UPDATE_SELECTION
			type: type
			list: list
		}
}

module.exports = SelectionAction