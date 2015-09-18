'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

UserAction = {
	info: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.USER_INFO
		}
	smsCode: (mobile, type)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.SMS_CODE
			mobile: mobile
			type: type
		}
	register: (mobile, code, passwd)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.REGISTER
			mobile: mobile
			code: code
			passwd: passwd
		}
}

module.exports = UserAction