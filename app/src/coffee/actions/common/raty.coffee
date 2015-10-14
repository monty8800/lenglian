'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

RatyAction = {
	rate: (score)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.RATY_CHANGE
			score: score
		}
}

module.exports = RatyAction