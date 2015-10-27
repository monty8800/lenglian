'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

MessageAction = {
	msgList: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.MSG_LIST
			params: params
		}
}

module.exports = MessageAction