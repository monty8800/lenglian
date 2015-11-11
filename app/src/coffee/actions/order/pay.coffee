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
	payNoti: (smsCode)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.PAY_NOTI
			smsCode: smsCode
		}
	doPay: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.DO_PAY
			params: params
		}
	selectCard: (card)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.SELECT_PAY_CARD
			card: card
		}
}

module.exports = PayAction