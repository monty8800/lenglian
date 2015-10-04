'use strict'

BaseStore = require 'stores/common/base'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'


updateSelection = (type, list)->
	SelectionStore.emitChange {
		type: type
		list: list
	}

SelectionStore = assign BaseStore, {
}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.UPDATE_SELECTION then updateSelection(action.type, action.list)

module.exports = SelectionStore
