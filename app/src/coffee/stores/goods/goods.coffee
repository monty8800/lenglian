'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'

Constants = require 'constants/constants'
Immutable = require 'immutable'
DB = require 'util/storage'
Plugin = require 'util/plugin'

Goods = require 'model/goods'
Address = require 'model/address'

localGoods = DB.get 'goods'

_goods = new Goods localGoods

_from = new Address DB.get('from')
_to = new Address DB.get('to')
_passBy = Immutable.Map DB.get('passBy')

GoodsStore = require 'stores/goods/goods'

GoodsStore = assign BaseStore, {
	getGoods: ->
		_goods
	getFrom: ->
		_from
	getTo: ->
		_to
	getPassBy: ->
		_passBy
}

updateStore = ->
	paths = window.location.href.split('/')
	page = paths[paths.length-1]
	switch page
		when 'addGoods.html' then updateGoods()

updateGoods = ->
	localGoods = DB.get 'goods'
	transData = DB.get 'transData'
	console.log 'transData', transData
	_goods = _goods.merge localGoods

	if transData and transData?.constructor isnt String
		key = Object.keys(transData)[0]
		console.log 'key--', key
		if transData.to
			_to =  new Address transData.to
			DB.put 'to', _to.toJS()
		else if transData.from
			_from = new Address transData.from
			DB.put 'from', _from.toJS()
		else if /^passBy\d*$/.test key
			console.log 'merge ' + key, transData[key]
			_passBy = _passBy.set key, (new Address transData[key])
			DB.put 'passBy', _passBy.toJS()

	DB.remove 'transData'

	DB.put 'goods', _goods.toJS()
	GoodsStore.emitChange 'goods:update'

addPassBy = ->
	console.log 'goods', _goods
	_passBy = _passBy.set 'passBy' + _passBy.size, new Address
	DB.put 'passBy', _passBy.toJS()
	GoodsStore.emitChange 'goods:update'

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.UPDATE_STORE then updateStore()
		when Constants.actionType.GOODS_ADD_PASS_BY then addPassBy()

module.exports = GoodsStore
