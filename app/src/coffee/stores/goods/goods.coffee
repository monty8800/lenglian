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

UserStore = require 'stores/user/user'

_user = UserStore.getUser()

localGoods = DB.get 'goods'

_goods = new Goods localGoods
_goodsDetail = new Goods
_searchGoodsDetail = new Goods
_myGoodsList = []

_goodsList = Immutable.List()

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

	getGoodsList: ->
		_goodsList
	getSearchGoodsDetail:->
		_searchGoodsDetail

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

window.updateGoods = updateGoods

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

minusPassBy = (index)->
	console.log 'minus index', index, _passBy 
	_passBy = _passBy.remove index
	console.log 'after minus', _passBy
	DB.put 'passBy', _passBy.toJS()
	GoodsStore.emitChange 'goods:update'

addGoods = (params, files)->
	Http.postFile Constants.api.ADD_GOODS, params, files

window.addGoodsSucc = ->
	DB.put 'shouldMyGoodsListReload',1

window.tryReloadMyGoodsList = ()->
	shouldReloadMyGoodsList = DB.get 'shouldMyGoodsListReload'
	if (parseInt shouldReloadMyGoodsList) is 1
		GoodsStore.emitChange 'myGoodsList:reloaded'
		getUserGoodsList 1,10
		console.log '货源__列表刷新......'


getUserGoodsList = (pageNow,pageSize,status,priceType,createTime)->
	params = {
		userId: _user?.id
		pageNow:pageNow
		pageSize:pageSize
		resourceStatus:status
		priceType:priceType
		createTime:createTime
	}
	Http.post Constants.api.GET_GOODS_LIST,params,(data)->

		DB.remove 'shouldMyGoodsListReload'
		if pageNow is 1
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
			aGoodsModel = aGoodsModel.set 'imageUrl',goodsObj.imgurl
			aGoodsModel = aGoodsModel.set 'resourceStatus',goodsObj.resourceStatus
			aGoodsModel = aGoodsModel.set 'goodsType',goodsObj.goodsType
			aGoodsModel = aGoodsModel.set 'createTime',goodsObj.createTime
			aGoodsModel = aGoodsModel.set 'cube',goodsObj.cube
			aGoodsModel = aGoodsModel.set 'refrigeration', goodsObj.coldStoreFlag

			_myGoodsList.push aGoodsModel	
		GoodsStore.emitChange 'getUserGoodsListSucc'
	,(data)->
		Plugin.toast.err data.msg

getGoodsDetail = (goodsId)->
	params = {
		userId: _user?.id
		id:goodsId
		resourceStatus:''
	}
	Http.post Constants.api.GET_GOODS_DETAIL,params,(data)->
		resource = data.mjGoodsResource
		if !resource
			Plugin.toast.show 'kong'
			return
		_goodsDetail = _goodsDetail.set 'name',resource.name
		_goodsDetail = _goodsDetail.set 'id',resource.id
		_goodsDetail = _goodsDetail.set 'fromProvinceName',resource.fromProvinceName
		_goodsDetail = _goodsDetail.set 'fromCityName',resource.fromCityName
		_goodsDetail = _goodsDetail.set 'fromAreaName',resource.fromAreaName
		_goodsDetail = _goodsDetail.set 'fromStreet',resource.fromStreet
		_goodsDetail = _goodsDetail.set 'toProvinceName',resource.toProvinceName
		_goodsDetail = _goodsDetail.set 'toCityName',resource.toCityName
		_goodsDetail = _goodsDetail.set 'toAreaName',resource.toAreaName
		_goodsDetail = _goodsDetail.set 'toStreet',resource.toStreet
		_goodsDetail = _goodsDetail.set 'weight',resource.weight
		_goodsDetail = _goodsDetail.set 'cube',resource.cube
		_goodsDetail = _goodsDetail.set 'packType',resource.packType
		_goodsDetail = _goodsDetail.set 'type',resource.type
		_goodsDetail = _goodsDetail.set 'imageUrl',resource.imgurl
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
		_goodsDetail = _goodsDetail.set 'resourceStatus',resource.resourceStatus
		_goodsDetail = _goodsDetail.set 'goodsType',resource.goodsType
		_goodsDetail = _goodsDetail.set 'price',resource.price
		_goodsDetail = _goodsDetail.set 'payType',resource.payType
		_goodsDetail = _goodsDetail.set 'prePay',resource.advance
		_goodsDetail = _goodsDetail.set 'refrigeration', resource.coldStoreFlag

		GoodsStore.emitChange 'getGoodsDetailSucc'
	,(data)->
		Plugin.toast.err data.msg

searchGoods = (params)->
	Http.post Constants.api.DRIVER_FIND_GOODS, params, (data)->
		console.log 'search goods result', data
		_goodsList = Immutable.List() if params.startNo is 0
		_goodsList = _goodsList.concat(Immutable.List().merge data.goods)
		GoodsStore.emitChange 'search:goods:done'


changeWidget = (show, bid)->
	GoodsStore.emitChange {
		msg: 'change:widget:status'
		show: show
		bid: bid
	}

window.doCarSearchGoods = ->
	GoodsStore.emitChange 'do:car:search:goods'

deleteGoodsWithID = (goodsId) ->
	user = UserStore.getUser()
	params = {
		userId:user.id
		id:goodsId
	}
	Http.post Constants.api.DELETE_GOODS,params,(data)->
		DB.put 'shouldMyGoodsListReload',1
		GoodsStore.emitChange 'deleteGoodsSucc'
	,(data)->
		Plugin.toast.err data.msg


getSearchGoodsDetail = (goodsId,focusid)->
	user = UserStore.getUser()
	params = {
		userId:user.id
		id:goodsId
		focusid:focusid
	}
	Http.post Constants.api.GET_SEARCH_GOODS_DETAIL,params,(data)->
		resource = data.mjGoodsResource
		if !resource
			# Plugin.toast.show 'kong'
			return
		_searchGoodsDetail = _searchGoodsDetail.set 'userName',data.name	
		_searchGoodsDetail = _searchGoodsDetail.set 'certification',data.certification
		_searchGoodsDetail = _searchGoodsDetail.set 'stars',data.goodScore
		_searchGoodsDetail = _searchGoodsDetail.set 'userHeaderImageUrl',data.imgurl
		_searchGoodsDetail = _searchGoodsDetail.set 'wishlst',data.wishlst
		_searchGoodsDetail = _searchGoodsDetail.set 'name',resource.name
		_searchGoodsDetail = _searchGoodsDetail.set 'id',resource.id
		_searchGoodsDetail = _searchGoodsDetail.set 'fromProvinceName',resource.fromProvinceName
		_searchGoodsDetail = _searchGoodsDetail.set 'fromCityName',resource.fromCityName
		_searchGoodsDetail = _searchGoodsDetail.set 'fromAreaName',resource.fromAreaName
		_searchGoodsDetail = _searchGoodsDetail.set 'fromStreet',resource.fromStreet
		_searchGoodsDetail = _searchGoodsDetail.set 'toProvinceName',resource.toProvinceName
		_searchGoodsDetail = _searchGoodsDetail.set 'toCityName',resource.toCityName
		_searchGoodsDetail = _searchGoodsDetail.set 'toAreaName',resource.toAreaName
		_searchGoodsDetail = _searchGoodsDetail.set 'toStreet',resource.toStreet
		_searchGoodsDetail = _searchGoodsDetail.set 'weight',resource.weight
		_searchGoodsDetail = _searchGoodsDetail.set 'cube',resource.cube
		_searchGoodsDetail = _searchGoodsDetail.set 'packType',resource.packType
		_searchGoodsDetail = _searchGoodsDetail.set 'type',resource.type
		_searchGoodsDetail = _searchGoodsDetail.set 'imageUrl',resource.imgurl
		_searchGoodsDetail = _searchGoodsDetail.set 'installStime',resource.installStime
		_searchGoodsDetail = _searchGoodsDetail.set 'installEtime',resource.installEtime
		_searchGoodsDetail = _searchGoodsDetail.set 'arrivalStime',resource.arrivalStime
		_searchGoodsDetail = _searchGoodsDetail.set 'arrivalEtime',resource.arrivalEtime
		_searchGoodsDetail = _searchGoodsDetail.set 'sender',resource.contacts
		_searchGoodsDetail = _searchGoodsDetail.set 'senderMobile',resource.phone
		_searchGoodsDetail = _searchGoodsDetail.set 'receiver',resource.receiver
		_searchGoodsDetail = _searchGoodsDetail.set 'receiverMobile',resource.receiverMobile
		_searchGoodsDetail = _searchGoodsDetail.set 'remark',resource.remark
		_searchGoodsDetail = _searchGoodsDetail.set 'mjGoodsRoutes',resource.mjGoodsRoutes
		_searchGoodsDetail = _searchGoodsDetail.set 'priceType',resource.priceType
		_searchGoodsDetail = _searchGoodsDetail.set 'invoice',resource.isinvoice
		_searchGoodsDetail = _searchGoodsDetail.set 'resourceStatus',resource.resourceStatus
		_searchGoodsDetail = _searchGoodsDetail.set 'goodsType',resource.goodsType	
		_searchGoodsDetail = _searchGoodsDetail.set 'payType',resource.payType
		_searchGoodsDetail = _searchGoodsDetail.set 'refrigeration', resource.coldStoreFlag
		GoodsStore.emitChange 'getSearchGoodsDetailSucc'
	,(data)->
		Plugin.toast.err data.msg

handleFallow = (focusid,focustype,type)->
	user = UserStore.getUser()
	Http.post Constants.api.attention, {
		focusid:focusid
		userId:user.id
		focustype:focustype
		type:type
	},(data)->
		GoodsStore.emitChange "fallowOrUnFallowHandleSucc"
	,(data)->
		Plugin.toast.err data.msg

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.UPDATE_STORE then updateStore()
		when Constants.actionType.GOODS_ADD_PASS_BY then addPassBy()
		when Constants.actionType.GOODS_MINUS_PASS_BY then minusPassBy(action.index)
		when Constants.actionType.ADD_GOODS then addGoods(action.params, action.files)
		when Constants.actionType.CLEAR_GOODS_PIC then clearPic()
		when Constants.actionType.CLEAR_GOODS then clearGoods()

		when Constants.actionType.GET_GOODS_LIST then getUserGoodsList(action.pageNow,action.pageSize,action.status,action.priceType,action.createTime)
		when Constants.actionType.GET_GOODS_DETAIL then getGoodsDetail(action.goodsId)

		when Constants.actionType.SEARCH_GOODS then searchGoods(action.params)
		when Constants.actionType.CHANGE_WIDGET_STATUS then changeWidget(action.show, action.bid)
		when Constants.actionType.DELETE_GOODS then deleteGoodsWithID(action.goodsId)
		when Constants.actionType.GET_SEARCH_GOODS_DETAIL then getSearchGoodsDetail(action.goodsId,action.focusid)
		when Constants.actionType.attention then handleFallow(action.focusid,action.focustype,action.type)
module.exports = GoodsStore
