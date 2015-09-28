'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
AddressModel = require 'model/address'
Constants = require 'constants/constants'
Immutable = require 'immutable'
Plugin = require 'util/plugin'

UserStore = require 'stores/user/user'

DB = require 'util/storage'

_user = UserStore.getUser()

_addressList = Immutable.List()

cityData = DB.get 'cityList'

_cityList = Immutable.fromJS (cityData?.list or [])

localAddress = DB.get 'address'

_address = new AddressModel localAddress

addressList = ->
	console.log '请求网络数据'
	Http.post Constants.api.address_list, {
		userId: _user?.id
	}, (result) ->
		if result.length is 0
			Plugin.toast.err '没有相关数据呢!'
			return;
		for info in result
			do (info) ->
				tempAddress = new AddressModel
				tempAddress = tempAddress.set 'id', info.id
				tempAddress = tempAddress.set 'userId', info.userId
				tempAddress = tempAddress.set 'street', info.street
				tempAddress = tempAddress.set 'provinceId', info.province
				tempAddress = tempAddress.set 'cityId', info.city
				tempAddress = tempAddress.set 'areaId', info.area
				tempAddress = tempAddress.set 'provinceName', info.provinceName
				tempAddress = tempAddress.set 'cityName', info.cityName
				tempAddress = tempAddress.set 'areaName', info.areaName
				_addressList = _addressList.push tempAddress
		AddressStore.emitChange 'list'

delAddress = (addressId)->
	console.log '-----删除地址--', addressId
	Http.post Constants.api.del_address, {
		id: addressId
		userId: _user?.id
	}, (result) ->
		AddressStore.emitChange 'del_success'
	, (data) ->
		AddressStore.emitChange data.msg

cityList = ->
	now = new Date
	if cityData?.list?.length > 0 and now.getTime() - cityData?.updateTime < Constants.cache.CITY_LIST
		AddressStore.emitChange {msg: 'cityList:changed'}
	else
		Http.post Constants.api.CITY_LIST, {
		}, (result)->
			_cityList = Immutable.fromJS result
			DB.put 'cityList', {
				updateTime: now.getTime()
				list: result
			}
			AddressStore.emitChange {msg: 'cityList:changed'}

selectAddress = (address, type, item)->
	_address = _address.merge address
	DB.put 'address', _address.toJS()
	AddressStore.emitChange {msg: 'address:changed', type: type, item: item}

changeSelector = (status)->
	AddressStore.emitChange 'selector:' + status

locate = ->
	Plugin.run [6, 'locate']

updateAddress = (props)->
	_address = _address.merge props
	console.log '---------updateAddress', _address
	DB.put 'address', _address
	AddressStore.emitChange 'address:update'

window.updateAddress = updateAddress

window.updateAdd = (lat, lon)->	
	_address = _address.set 'lati', lat
	_address = _address.set 'longi', lon
	DB.put 'address', _address
	console.log '---------updateAddress--------', lon

AddressStore = assign BaseStore, {
	getAddressList: ->
		_addressList

	getCityList: ->
		_cityList

	getAddress: ->
		_address
}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.ADDRESS_LIST then addressList()
		when Constants.actionType.DEL_ADDRESS then delAddress(action.addressId)
		when Constants.actionType.CITY_LIST then cityList()
		when Constants.actionType.SELECT_ADDRESS then selectAddress(action.address, action.type, action.item)
		when Constants.actionType.CHANGE_SELECTOR then changeSelector(action.status)
		when Constants.actionType.LOCATE then locate()

module.exports = AddressStore