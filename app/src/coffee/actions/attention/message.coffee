'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

MessageAction = {
	msgList: (statu)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.MSG_LIST
			status: statu
		}
}

module.exports = MessageAction