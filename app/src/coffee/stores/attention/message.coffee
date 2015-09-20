'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Message = require 'model/message'
Constants = require 'constants/constants'
Immutable = require 'immutable'
DB = require 'util/storage'

user = DB.get 'user'

_messageList = Immutable.List()

getMsgList = (status)->

	Http.post Constants.api.message_list, {
		userId: user.id
		userRole: status
	}, (result) ->
		_messageList = _messageList.clear()
		for msg in result.myMessage
			do (msg) ->
				_msg = new Message
				_msg = _msg.set 'content', msg.content
				_msg = _msg.set 'createTime', msg.createTime
				_messageList = _messageList.push _msg
		MessageStore.emitChange()


MessageStore = assign BaseStore, {
	getMsgList: ->
		_messageList
}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.MSG_LIST then getMsgList(action.status)

module.exports = MessageStore
