'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Message = require 'model/message'
Constants = require 'constants/constants'
Immutable = require 'immutable'
DB = require 'util/storage'
Plugin = require 'util/plugin'

UserStore = require 'stores/user/user'

_user = UserStore.getUser()

_messageList = Immutable.List()

getMsgList = (params)->
	Http.post Constants.api.message_list, params, (result) ->
		_messageList = Immutable.List() if params.pageNow is 1
		for msg in result.myMessage
			do (msg) ->
				_msg = new Message
				_msg = _msg.set 'content', msg.content
				_msg = _msg.set 'createTime', msg.createTime
				_msg = _msg.set 'orderId', msg.orderId
				_msg = _msg.set 'flag', msg.flag
				_msg = _msg.set 'goodsPersonUserId', msg.goodsPersonUserId
				_messageList = _messageList.push _msg
		MessageStore.emitChange()


MessageStore = assign BaseStore, {
	getMsgList: ->
		_messageList
}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.MSG_LIST then getMsgList(action.params)

module.exports = MessageStore
