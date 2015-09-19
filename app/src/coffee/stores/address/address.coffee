'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
AddressModel = require 'model/address'
Constants = require 'constants/constants'
Immutable = require 'immutable'


_addressList = Immutable.List()

addressList = ->
	console.log '请求网络数据'
	Http.post Constants.api.address_list, {
		# TODO 固定的userId
		userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
	}, (result) ->
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
		userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
	}, (result) ->
		AddressStore.emitChange 'del_success'
	, (data) ->
		AddressStore.emitChange 'del_fail'

AddressStore = assign BaseStore, {
	getAddressList: ->
		_addressList

}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.ADDRESS_LIST then addressList()
		when Constants.actionType.DEL_ADDRESS then delAddress(action.addressId)

module.exports = AddressStore