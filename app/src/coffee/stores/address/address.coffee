'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
AddressModel = require 'model/address'
Constants = require 'constants/constants'
Immutable = require 'immutable'
Plugin = require 'util/plugin'
AddressAction = require 'actions/address/address'

UserStore = require 'stores/user/user'

DB = require 'util/storage'

_user = UserStore.getUser()

_addressList = Immutable.List()

cityData = DB.get 'cityList'

_cityList = Immutable.fromJS (cityData?.list or [])

localAddress = DB.get 'address'

_address = new AddressModel localAddress


addressList = ->
	console.log '请求网络数据', Constants.api.address_list
	Http.post Constants.api.address_list, {
		userId: _user?.id
	}, (result) ->
		_addressList = Immutable.List()
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
				tempAddress = tempAddress.set 'lati', info.latitude
				tempAddress = tempAddress.set 'longi', info.longitude
				_addressList = _addressList.push tempAddress if info.latitude
		AddressStore.emitChange 'list'
		DB.remove 'shouldReloadAddressList'

window.tryReloadAddressList = ->
	if (parseInt (DB.get 'shouldReloadAddressList')) is 1
		addressList()


delAddress = (addressId)->
	console.log '-----删除地址--', addressId
	Http.post Constants.api.del_address, {
		id: addressId
		userId: _user?.id
	}, (result) ->
		AddressStore.emitChange 'del_success'
	, (data) ->
		AddressStore.emitChange data.msg

editAddress = (params)->
	Http.post Constants.api.EDIT_ADDRESS, params, (result)->
		AddressStore.emitChange 'address:edit:success'

addAddress = (params)->
	Http.post Constants.api.ADD_ADDRESS, params, (result)->
		AddressStore.emitChange 'address:new:success'

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
	console.log 'updateAddress', _address
	DB.put 'address', _address.toJS()

	AddressStore.emitChange 'address:update'



updateStore = ->
	paths = window.location.href.split('/')
	page = paths[paths.length-1]
	switch page
		when 'addressList.html' then addressList()


window.updateAddress = updateAddress

window.reloadAddress = ->
	AddressAction.addressList()


window.updateAdd = (lat, lon)->	
	_address = _address.set 'lati', lat
	_address = _address.set 'longi', lon
	DB.put 'address', _address
	console.log '---------updateAddress--------', lon

selectListAddress = (address)->
	AddressStore.emitChange {
		msg: 'address:select'
		address: address
	}


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
		when Constants.actionType.EDIT_ADDRESS then editAddress(action.params)
		when Constants.actionType.NEW_ADDRESS then addAddress(action.params)
		when Constants.actionType.UPDATE_STORE then updateStore()
		when Constants.actionType.SELECT_LIST_ADDRESS then selectListAddress(action.address)

module.exports = AddressStore