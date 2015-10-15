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
			data: Immutable.Map data
		}

hidePaySms = ->
	PayStore.emitChange 'hide:pay:sms'

payNoti = ->
	PayStore.emitChange 'do:pay'

doPay = (params)->
	Http.post Constants.api.PAY_ORDER, params, (data)->
		console.log 'pay order result', data
		switch parseInt(data)
			when 10 then Plugin.toast.err '余额不足！'
			when 11 then Plugin.toast.err '支付失败，请稍后再试'
			when 12 then Plugin.toast.err '充值失败，请稍后再试'
			when 13
				DB.put 'transData', {
					del: params.orderNo
				}
				PayStore.emitChange 'pay:done'
			when 14 then Plugin.toast.err '支付异常，请稍后再试'
			when 0
				DB.put 'transData', {
					del: params.orderNo
				}
				PayStore.emitChange 'pay:success'

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_PAY_INFO then getPayInfo(action.params)
		when Constants.actionType.HIDE_PAY_SMS then hidePaySms()
		when Constants.actionType.PAY_NOTI then payNoti()
		when Constants.actionType.DO_PAY then doPay(action.params)


module.exports = PayStore
