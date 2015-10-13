'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

PayAction = {
	getPayInfo: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_PAY_INFO
			params: params
		}
	hidePaySms: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.HIDE_PAY_SMS
		}
	payNoti: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.PAY_NOTI
		}
	doPay: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.DO_PAY
			params: params
		}
}

module.exports = PayAction