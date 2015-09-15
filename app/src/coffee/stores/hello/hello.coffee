'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

_helloText = 'hello，点击我请求百度'
_hello = {}

requestBaidu = ()->
	Http.get Constants.api.hello,  (data)->
		console.log 'data from baidu:', data
		_helloText = '百度返回的数据:' + data
		_hello.name = 'ywen' + Math.random()
		_hello.age = 18
		HelloStore.emitChange()

HelloStore = assign BaseStore, {
	getText: ->
		_helloText
	getHello: ->
		_hello
}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.APP_HELLO then requestBaidu()

module.exports = HelloStore