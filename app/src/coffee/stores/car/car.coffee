'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
Car = require 'model/car'
Immutable = require 'immutable'
DB = require 'util/storage'

_car = new Car

_carList = Immutable.List()

_carDetail = new Car

carItemInfo = ->
	_car = _car.set 'drivePic', ''
	_car = _car.set 'name', 'sk'
	_car = _car.set 'remark', 5
	_car = _car.set 'startPoint', '泰鹏大厦'
	_car = _car.set 'destination', '永泰庄'
	_car = _car.set 'carDesc', '10米 低调奢华有内涵' 
	CarStore.emitChange()

# 我的车辆
carListInfo = ->
	# 请求网络获取数据
	console.log 'my_car_list'
	params = {
		userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
		pageNow: 1,
		pageSize: 10,
		status: ''  
	}
	Http.post Constants.api.my_car_list, params, (data)->
		console.log 'data: ' + data 
		tempList = data.myCarInfo; 
		for car in tempList
			do (car) ->
				tempCar = new Car
				tempCar = tempCar.set 'name', car.driver
				tempCar = tempCar.set 'carNo', car.carno
				tempCar = tempCar.set 'carPic', car.imgurl
				tempCar = tempCar.set 'mobile', car.phone
				tempCar = tempCar.set 'carType', car.category
				tempCar = tempCar.set 'carVehicle', car.vehicle
				tempCar = tempCar.set 'carId', car.id
				_carList = _carList.push tempCar
		CarStore.emitChange()

# 车辆详情
carDetail = ->
	Http.post Constants.api.car_detail, {
			carId: '9f5d91332ea14017a6c406f9649fb1e1'
		}, (data) ->
			console.log '车辆详情----', data
			td = data.carInfoLoad;
			_carDetail = _carDetail.set 'carNo', td.carno
			_carDetail = _carDetail.set 'status', td.status
			_carDetail = _carDetail.set 'carType', td.type
			_carDetail = _carDetail.set 'carPic', td.imgurl
			_carDetail = _carDetail.set 'category', td.category
			_carDetail = _carDetail.set 'heavy', td.heavy
			_carDetail = _carDetail.set 'bulky', td.bulky
			_carDetail = _carDetail.set 'carVehicle', td.vehicle
			_carDetail = _carDetail.set 'name', td.driver
			_carDetail = _carDetail.set 'mobile', td.phone
			_carDetail = _carDetail.set 'drivingImg', td.drivingImg
			_carDetail = _carDetail.set 'transportImg', td.transportImg
			console.log '_carDetail -- ', _carDetail
			CarStore.emitChange()


CarStore = assign BaseStore, {
	getCar: ->
		_car

	getCarList: ->
		_carList

	getCarDetail: ->
		_carDetail

}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.FOUND_CAR then carItemInfo()
		when Constants.actionType.CAR_LIST then carListInfo()
		when Constants.actionType.CAR_DETAIL then carDetail()

module.exports = CarStore



