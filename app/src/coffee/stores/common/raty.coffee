'use strict'

BaseStore = require 'stores/common/base'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

_score = 8
rate = (score)->
	_score = score
	RatyStore.emitChange 'rate:change' 

RatyStore = assign BaseStore, {
	getScore: ->
		_score
}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.RATY_CHANGE then rate(action.score)

module.exports = RatyStore

