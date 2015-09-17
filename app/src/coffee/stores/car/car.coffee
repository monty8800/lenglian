'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
Car = require 'model/car'
Immutable = require 'immutable'
DB = require 'util/storage'

localCar = db.get 'car'
_car = new Car localCar

carItemInfo = ->
	_car = _car.set 'pic', ''
	_car = _car.set 'name', 'sk'
	_car = _car.set 'remark', 5
	_car = _car.set 'startPoint', '泰鹏大厦'
	_car = _car.set 'destination', '永泰庄'
	_car = _car.set 'carDesc', '低调奢华有内涵' 
	CarStore.emitChange()

CarStore = assign BaseStore, {
	getCar: ->
		_car
}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.FOUND_CAR then carItemInfo()

module.exports = CarStore



