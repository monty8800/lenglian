'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

MessageAction = {
	msgList: (statu, pageNow)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.MSG_LIST
			status: statu
			pageNow: pageNow
		}
}

module.exports = MessageAction