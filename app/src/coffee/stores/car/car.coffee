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
CarAction = require 'actions/car/car'
UserStore = require 'stores/user/user'
_user = UserStore.getUser()

_car = new Car

_carList = Immutable.List()

_freeCarList = Immutable.List()

_foundCarList = Immutable.List()

_carDetail = new Car

_carLenList = []

_carLenListTemp = []

_carLenListAll = ['3.8', '4.2', '4.8', '5.8', '6.2', '6.8', '7.4', '7.8', '8.6', '9.6', '13', '15']

_carHeaList = []

_carHeaListTemp = []

_carHeaListAll = ['2', '3', '4', '5', '6', '8', '10', '12', '15', '18', '20', '25', '28', '30', '40']

_isInvoice = ''

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

# 更新我的车辆列表
window.updateMyCarList = ->
	CarAction.carList('1')
	Plugin.toast.show 'update'

# 编辑车辆
window.editorCar = ->
	CarStore.emitChange ['editor_car']	

window.editorCarDone = ->
	CarStore.emitChange ['editor_car_done']		

# 我要找车
carItemInfo = (param)->
	console.log '-------para:', param
	params = {
		userId: _user?.id
		startNo: 1
		pageSize: 10
		fromProvinceId: ''
		fromCityId: ''
		fromAreaId: ''
		toProvinceId: ''
		toCityId: ''
		toAreaId: ''
		vehicle: _carLenList
		heavy: _carHeaList
		isInvoice: param[0]
		carType: ''
		id: ''
	}
	Http.post Constants.api.found_car, params, (result) ->
		console.log '我要找车--', result.length
		if result.length is 0
			Plugin.toast.err '没有相关数据呢!'
		_foundCarList = _foundCarList.clear() 
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
		CarStore.emitChange ['found_car']
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
		CarStore.emitChange ['my_car_list']
  
# 车辆详情
carDetail = (carId)->
	Http.post Constants.api.car_detail, {
			carId: carId
			userId: _user?.id
		}, (data) ->
			console.log '车辆详情----', data
			td = data.carInfoLoad;
			_carDetail = _carDetail.set 'id', td.id
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
			CarStore.emitChange ['car_detail']

# 发布车源
_releaeCar = (params)->
	Plugin.loading.show '正在发布...'
	console.log '发布车源-------', params
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

# 车辆长度
_checkedLenAll = ->
	_carLenListTemp = _carLenListAll
	_carLenList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
	console.log '--------------_carHeaList:', _carLenList
	CarStore.emitChange ['checked_len_all']

_unCheckedLenAll = ->
	_carLenList = []
	_carLenListTemp = []
	console.log '--------------_carHeaList:', _carLenList
	CarStore.emitChange ['unchecked_len_all']	

_checkedLenST = (params, p2)->

	_carLenListTemp.push p2
	index = _carLenListAll.indexOf p2
	_carLenList.push index
	console.log '--------------_carHeaList:', _carLenList
	CarStore.emitChange ['lencheck', 'lenCheck' + params, _carLenList.length]

_uncheckedLenST = (params, p2)->
	index = _carLenListTemp.indexOf p2
	_carLenListTemp.splice index, 1
	_carLenList.splice index, 1
	console.log '--------------_carHeaList:', _carLenList
	CarStore.emitChange ['unlencheck', 'lenCheck' + params]

# 关闭下拉菜单
_close_car_len = ->
	CarStore.emitChange ['close_car_len']

# 可在货重全选
_checkedHeaAll = ->
	_carHeaListTemp = _carHeaListAll
	_carHeaList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
	console.log '--------------_carHeaList:', _carHeaList
	CarStore.emitChange ['checked_hea_all']

# 可在货重取消全选
_unCheckedHeaAll = ->
	_carHeaList = []
	_carHeaListTemp = []
	console.log '--------------_carHeaList:', _carHeaList
	CarStore.emitChange ['unchecked_hea_all']

_checkedHeaST = (params, p2)->
	_carHeaListTemp.push p2
	index = _carHeaListAll.indexOf p2
	_carHeaList.push index
	console.log '--------------_carHeaList:', _carHeaList
	CarStore.emitChange ['heacheck', 'heaCheck' + params, _carHeaList.length]

_haha = (params, p2)->
	index = _carHeaListTemp.indexOf p2
	_carHeaListTemp.splice index, 1
	_carHeaList.splice index, 1
	console.log '--------------_carHeaList:', _carHeaList
	CarStore.emitChange ['unheacheck', 'heaCheck' + params]

# 关闭下拉菜单
_close_car_hea = ->
	CarStore.emitChange ['close_car_hea']

_close_car_invoince = ->
	CarStore.emitChange ['close_car_inv']

_needInv = (type)->
	console.log '------type:', type
	if type is 1
		_isInvoice = '1'
		CarStore.emitChange ['one_need']
	else
		_isInvoice = '2'
		CarStore.emitChange ['one_not_need']

_notNeedInv = (type)->
	console.log '------type:', type
	if type is 1
		_isInvoice = '1'
		CarStore.emitChange ['one_not_need']
	else
		_isInvoice = '2'
		CarStore.emitChange ['one_need']

# 删除车辆
_carDel = (carId)->
	Plugin.loading.show '正在删除...'
	console.log '-------delCar:', carId
	Http.post Constants.api.detail_car, {
		userId: _user?.id
		carId: carId
	}, (data)->				
		Plugin.loading.hide()
		console.log '--------delSuccess:', data
		Plugin.toast.err '删除成功'
		Plugin.nav.push ['del_success']
	, (data)->
		Plugin.loading.hide()
		Plugin.toast.err err.msg

# 编辑车辆
_modifyCar = (params)->
	Http.post Constants.api.modify_car, params, (data)->
		 console.log '------success'
		 Plugin.toast.err '编辑成功'
		 Plugin.nav.push ['modify_success']
	, (data)->
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
		when Constants.actionType.FOUND_CAR then carItemInfo(action.params)
		when Constants.actionType.CAR_LIST then carListInfo(action.status)
		when Constants.actionType.CAR_DETAIL then carDetail(action.carId)
		when Constants.actionType.RELEASE_CAR then _releaeCar(action.params)
		when Constants.actionType.ADD_CAR then _addCar(action.params, action.files)
		when Constants.actionType.FREEDOM_CAR then _freedomCar()
		when Constants.actionType.CHECKED_LEN_ALL then _checkedLenAll()
		when Constants.actionType.UNCHECKED_LEN_ALL then _unCheckedLenAll()
		when Constants.actionType.CHECKED_LEN_ST then _checkedLenST(action.params, action.param)
		when Constants.actionType.UNCHECKED_LEN_ST then _uncheckedLenST(action.params, action.param)
		when Constants.actionType.CLOSE_CAR_LEN then _close_car_len()
		when Constants.actionType.CHECKED_HEA_ALL then _checkedHeaAll()
		when Constants.actionType.UNCHECKED_HEA_ALL then _unCheckedHeaAll()
		when Constants.actionType.CHECKED_HEA_ST then _checkedHeaST(action.params, action.param)
		when Constants.actionType.UNCHECKED_HEA_ST then _uncheckedHeaST(action.params, action.param)
		when Constants.actionType.HAHAHA then _haha(action.params, action.param)
		when Constants.actionType.CLOSE_CAR_HEA then _close_car_hea()
		when Constants.actionType.CLOSE_INVOINCE then _close_car_invoince()
		when Constants.actionType.NEEDINV then _needInv(action.type)
		when Constants.actionType.NOTNEEDINV then _notNeedInv(action.type)
		when Constants.actionType.DEL_CAR then _carDel(action.carId)
		when Constants.actionType.MODIFY_CAR then _modifyCar(action.param)

module.exports = CarStore



