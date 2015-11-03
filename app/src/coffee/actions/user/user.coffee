'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

UserAction = {
	info: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.USER_INFO
		}
	smsCode: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.SMS_CODE
			params: params
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

	resetPayPwd: (mobile, code, passwd)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.RESET_PAY_PWD
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
	setPayPwd: (payPwd, oldPwd)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.PAY_PWD
			payPwd: payPwd
			oldPwd: oldPwd
		}

	logout: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.LOGOUT
		}

	personalAuth: (params, files)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.PERSONAL_AUTH
			params: params
			files: files
		}

	clearAuthPic: (type)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CLEAR_AUTH_PIC
			type: type
		}

	updateUser: (properties)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.UPDATE_USER
			properties: properties
		}
	companyAuth: (params, files)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.COMPANY_AUTH
			params: params
			files: files
		}
	autoLogin: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.AUTO_LOGIN
		}
}

module.exports = UserAction