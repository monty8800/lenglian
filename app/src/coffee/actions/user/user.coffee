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

	login: (mobile, passwd)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.LOGIN
			mobile: mobile
			passwd: passwd
		}
	resetPasswd: (mobile, code, passwd)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.RESET_PWD
			mobile: mobile
			code: code
			passwd: passwd
		}

	changePasswd: (oldPasswd, newPasswd)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CHANGE_PWD
			oldPasswd: oldPasswd
			newPasswd: newPasswd
		}
}

module.exports = UserAction