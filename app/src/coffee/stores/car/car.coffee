'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
Car = require 'model/car'
Immutable = require 'immutable'
DB = require 'util/storage'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'

_user = UserStore.getUser()

_car = new Car

_carList = Immutable.List()

_freeCarList = Immutable.List()

_foundCarList = Immutable.List()

_carDetail = new Car

# 更新联系人
window.updateContact = (contact, phone)->
	console.log '------updateContact-', phone
	CarStore.emitChange ['updateContact', contact, phone]

window.setPicAuth = (picUrl, type)->
	_user = _user.set type, picUrl
	DB.put 'user', _user.toJS()
	UserStore.emitChange 'setPicDone'

# 更新地址  flag: startAddress, endAddress
window.updateAddress = (flag)->
	console.log '--------flag:', flag
	UserStore.emitChange [flag]

# 更新装货时间
window.updateDate = (startDate, endDate)->
	console.log '--------', endDate
	CarStore.emitChange ['updateDate', startDate, endDate]

carItemInfo = ->
	params = {
		startNo: 1
		pageSize: 10
		fromProvinceId: ''
		fromCityId: ''
		fromAreaId: ''
		toProvinceId: ''
		toCityId: ''
		toAreaId: ''
		vehicle: ''
		heavy: ''
		isInvoice: ''
		carType: ''
		id: ''
	}
	Http.post Constants.api.found_car, params, (result) ->
		console.log '我要找车--', result.length
		if result.length is 0
			Plugin.toast.err '没有相关数据呢!'
			return;
		for car in result
			do (car) ->
				tempCar = new Car
				tempCar = tempCar.set 'drivePic', car.userImgUrl
				tempCar = tempCar.set 'name', car.userName
				tempCar = tempCar.set 'remark', 5
				tempCar = tempCar.set 'startPoint', car.fromProvinceName + 
						car.fromCityName + car.fromAreaName
				tempCar = tempCar.set 'destination', car.toProvinceName + 
						car.toCityName + car.toAreaName
				tempCar = tempCar.set 'carDesc', car.heavy + '  ' + car.vehicle
				_foundCarList = _foundCarList.push tempCar
		CarStore.emitChange()
	, (data) ->
		Plugin.toast.err data.msg


# 我的车辆
carListInfo = (status)->
	# 请求网络获取数据
	params = {
		userId: _user?.id
		pageNow: 1
		pageSize: 10
		status: status 
	}
	Http.post Constants.api.my_car_list, params, (data)->
		tempList = data.myCarInfo; 
		_carList = _carList.clear() 
		if tempList.length is 0
			Plugin.toast.err '没有相关数据呢!'
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
carDetail = (carId)->
	Http.post Constants.api.car_detail, {
			carId: carId
			userId: _user?.id
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
			CarStore.emitChange()

# 发布车源
_releaeCar = (params)->
	Plugin.loading.show '正在发布...'
	console.log '发布车源---', params
	Http.post Constants.api.release_car, params, (result)->
		Plugin.loading.hide()
		Plugin.toast.success '发布成功'
		Plugin.nav.push ['release_success']
		CarStore.emitChange 'success'
	, (err)->
		Plugin.loading.hide()
		Plugin.toast.err err.msg

_addCar = (params, files)->
	console.log '----params -', params
	console.log '----files --', files
	Http.postFile Constants.api.add_car, params, files, (data)->
		console.log 'auth result', data
		UserStore.emitChange 'auth:done'

# 发布车源 -- 车辆列表
_freedomCar = ->
	Http.post Constants.api.my_car_list, {
		userId: _user?.id
		pageNow: 1
		pageSize: 100
		status: 1 # 空闲中
	}, (data)->
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
				_freeCarList = _freeCarList.push tempCar
		CarStore.emitChange ['free_car']
	, (data) ->
		Plugin.toast.err data.msg


CarStore = assign BaseStore, {
	getCar: ->
		_foundCarList

	getCarList: ->
		_carList

	getCarDetail: ->
		_carDetail

	getFreeCar: ->
		_freeCarList
}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.FOUND_CAR then carItemInfo()
		when Constants.actionType.CAR_LIST then carListInfo(action.status)
		when Constants.actionType.CAR_DETAIL then carDetail(action.carId)
		when Constants.actionType.RELEASE_CAR then _releaeCar(action.params)
		when Constants.actionType.ADD_CAR then _addCar(action.params, action.files)
		when Constants.actionType.FREEDOM_CAR then _freedomCar()

module.exports = CarStore



