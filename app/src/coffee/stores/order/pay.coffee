'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

Immutable = require 'immutable'
DB = require 'util/storage'
Plugin = require 'util/plugin'


PayStore = assign BaseStore, {
}

getPayInfo = (params)->
	Http.post Constants.api.GET_PAY_INFO, params, (data)->
		console.log 'get pay info result', data
		PayStore.emitChange {
			msg: 'pay:info'
			data: data
		}

hidePaySms = ->
	PayStore.emitChange 'hide:pay:sms'

payNoti = ->
	PayStore.emitChange 'do:pay'

doPay = (params)->
	Http.post Constants.api.PAY_ORDER, params, (data)->
		console.log 'pay order result', data
		PayStore.emitChange 'pay:success'

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_PAY_INFO then getPayInfo(action.params)
		when Constants.actionType.HIDE_PAY_SMS then hidePaySms()
		when Constants.actionType.PAY_NOTI then payNoti()
		when Constants.actionType.DO_PAY then doPay(action.params)


module.exports = PayStore
