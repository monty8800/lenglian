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

_user = UserStore.getUser()

_addressList = Immutable.List()

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

AddressStore = assign BaseStore, {
	getAddressList: ->
		_addressList

}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.ADDRESS_LIST then addressList()
		when Constants.actionType.DEL_ADDRESS then delAddress(action.addressId)

module.exports = AddressStore