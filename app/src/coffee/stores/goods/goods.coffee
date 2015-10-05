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
_goodsDetail = new Goods
_myGoodsList = []

_from = new Address DB.get('from')
_to = new Address DB.get('to')
_passBy = Immutable.Map DB.get('passBy')

GoodsStore = require 'stores/goods/goods'
UserStore = require 'stores/user/user'

GoodsStore = assign BaseStore, {
	getGoods: ->
		_goods
	getFrom: ->
		_from
	getTo: ->
		_to
	getPassBy: ->
		_passBy
	getMyGoodsList: ->
		_myGoodsList
	getGoodsDetail:->
		_goodsDetail
}

window.setGoodsPic = (picUrl)->
	console.log 'set goods pic',  picUrl
	GoodsStore.emitChange {
		msg: 'set:goods:photo:done'
		url: picUrl
	}
clearPic = ->
	console.log 'clear goods pic'
	GoodsStore.emitChange 'clear:goods:photo'

clearGoods = ->
	DB.remove 'goods'
	DB.remove 'from'
	DB.remove 'to'
	DB.remove 'passBy'
	_goods = new Goods
	_from = new Address
	_to = new Address
	_passBy = Immutable.Map()

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

window.updateTime = (start, end, type)->
	console.log 'update time', start, end, type
	GoodsStore.emitChange {
		msg: 'goods:time:' + type
		start: start
		end: end
	}

window.updateContact = (name, mobile, type)->
	console.log 'update contact', name, mobile, type
	GoodsStore.emitChange {
		msg: type
		name: name
		mobile: mobile
	}


addPassBy = ->
	console.log 'goods', _goods
	_passBy = _passBy.set 'passBy' + _passBy.size, new Address
	DB.put 'passBy', _passBy.toJS()
	GoodsStore.emitChange 'goods:update'

addGoods = (params, files)->
	Http.postFile Constants.api.ADD_GOODS, params, files

getUserGoodsList = (pageNow,pageSize,status)->
	user = UserStore.getUser()
	params = {
		#TODO:
		userId:'50819ab3c0954f828d0851da576cbc31'  #user.id
		pageNow:pageNow
		pageSize:pageSize
		resourceStatus:status
	}
	Http.post Constants.api.GET_GOODS_LIST,params,(data)->
		console.log data
		if pageNow is '1'
			_myGoodsList = []
		for goodsObj in data.GoodsResource
			aGoodsModel = new Goods
			aGoodsModel = aGoodsModel.set 'id',goodsObj.id
			aGoodsModel = aGoodsModel.set 'name',goodsObj.name
			aGoodsModel = aGoodsModel.set 'fromProvinceName',goodsObj.fromProvinceName
			aGoodsModel = aGoodsModel.set 'fromCityName',goodsObj.fromCityName
			aGoodsModel = aGoodsModel.set 'fromAreaName',goodsObj.fromAreaName
			aGoodsModel = aGoodsModel.set 'fromStreet',goodsObj.fromStreet
			aGoodsModel = aGoodsModel.set 'toProvinceName',goodsObj.toProvinceName
			aGoodsModel = aGoodsModel.set 'toCityName',goodsObj.toCityName
			aGoodsModel = aGoodsModel.set 'toAreaName',goodsObj.toAreaName
			aGoodsModel = aGoodsModel.set 'toStreet',goodsObj.toStreet
			aGoodsModel = aGoodsModel.set 'weight',goodsObj.weight
			aGoodsModel = aGoodsModel.set 'packType',goodsObj.packType
			aGoodsModel = aGoodsModel.set 'type',goodsObj.type
			aGoodsModel = aGoodsModel.set 'status',goodsObj.status
			aGoodsModel = aGoodsModel.set 'imageUrl',goodsObj.imageUrl
			_myGoodsList.push aGoodsModel	
		GoodsStore.emitChange 'getUserGoodsListSucc'
	,(data)->
		Plugin.toast.show 'faile'

getGoodsDetail = (goodsId)->
	console.log  goodsId,'---------------'
	user = UserStore.getUser()
	params = {
		#TODO:
		userId:'50819ab3c0954f828d0851da576cbc31'  #user.id
		id:goodsId
		resourceStatus:''
	}
	Http.post Constants.api.GET_GOODS_DETAIL,params,(data)->
		resource = data.mjGoodsResource
		if !resource
			Plugin.toast.show 'kong'
			return
		_goodsDetail = _goodsDetail.set 'name',resource.name
		_goodsDetail = _goodsDetail.set 'fromProvinceName',resource.fromProvinceName
		_goodsDetail = _goodsDetail.set 'fromCityName',resource.fromCityName
		_goodsDetail = _goodsDetail.set 'fromAreaName',resource.fromAreaName
		_goodsDetail = _goodsDetail.set 'fromStreet',resource.fromStreet
		_goodsDetail = _goodsDetail.set 'toProvinceName',resource.toProvinceName
		_goodsDetail = _goodsDetail.set 'toCityName',resource.toCityName
		_goodsDetail = _goodsDetail.set 'toAreaName',resource.toAreaName
		_goodsDetail = _goodsDetail.set 'toStreet',resource.toStreet
		_goodsDetail = _goodsDetail.set 'weight',resource.weight
		_goodsDetail = _goodsDetail.set 'packType',resource.packType
		_goodsDetail = _goodsDetail.set 'type',resource.type
		_goodsDetail = _goodsDetail.set 'status',resource.status
		_goodsDetail = _goodsDetail.set 'imageUrl',resource.imageUrl
		_goodsDetail = _goodsDetail.set 'installStime',resource.installStime
		_goodsDetail = _goodsDetail.set 'installEtime',resource.installEtime
		_goodsDetail = _goodsDetail.set 'arrivalStime',resource.arrivalStime
		_goodsDetail = _goodsDetail.set 'arrivalEtime',resource.arrivalEtime
		_goodsDetail = _goodsDetail.set 'sender',resource.contacts
		_goodsDetail = _goodsDetail.set 'senderMobile',resource.phone
		_goodsDetail = _goodsDetail.set 'receiver',resource.receiver
		_goodsDetail = _goodsDetail.set 'receiverMobile',resource.receiverMobile
		_goodsDetail = _goodsDetail.set 'remark',resource.remark
		_goodsDetail = _goodsDetail.set 'mjGoodsRoutes',resource.mjGoodsRoutes
		_goodsDetail = _goodsDetail.set 'priceType',resource.priceType
		_goodsDetail = _goodsDetail.set 'invoice',resource.isinvoice
		
		GoodsStore.emitChange 'getGoodsDetailSucc'
		Plugin.toast.show 'success'
	,(data)->
		console.log 'faile'

bindWarehouseOrder: (warehouseId,goodsId)->
	user = UserStore.getUser()
	params = {
		#TODO:
		userId:user.id
		warehouseId:warehouseId
		orderGoodsId:goodsId
	}
	Http.post Constants.api.GOODS_BIND_WAREHOUSE_ORDER,params,(data)->
		
		GoodsStore.emitChange 'goods_bind_warehouse_order_succ'



Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.UPDATE_STORE then updateStore()
		when Constants.actionType.GOODS_ADD_PASS_BY then addPassBy()
		when Constants.actionType.ADD_GOODS then addGoods(action.params, action.files)
		when Constants.actionType.CLEAR_GOODS_PIC then clearPic()
		when Constants.actionType.CLEAR_GOODS then clearGoods()
		when Constants.actionType.GET_GOODS_LIST then getUserGoodsList(action.pageNow,action.pageSize,action.status)
		when Constants.actionType.GET_GOODS_DETAIL then getGoodsDetail(action.goodsId)
		when Constants.actionType.GOODS_BIND_WAREHOUSE_ORDER then bindWarehouseOrder(actionType.warehouseId,actionType.goodsId)

module.exports = GoodsStore
