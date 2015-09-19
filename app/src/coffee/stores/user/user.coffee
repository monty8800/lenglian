'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
User = require 'model/user'
DB = require 'util/storage'
Immutable = require 'immutable'
Plugin = require 'util/plugin'


localUser = DB.get 'user'
_user = new User localUser

_menus = Immutable.fromJS [
	[
		{cls: 'u-icon-message', title: '我的消息', url: 'home'},
		{cls: 'u-icon-goods', title: '我的货源', url: 'home'},
		{cls: 'u-icon-car', title: '我的车辆', url: 'myCar'},
		{cls: 'u-icon-store', title: '我的仓库', url: 'home'}
	],
	[
		{cls: 'u-icon-money', title: '我的钱包', url: 'home'},
		{cls: 'u-icon-adress', title: '我的地址', url: 'home'}
	],
	[
		{cls: 'u-icon-focus', title: '我的关注', url: 'home'},
		{cls: 'u-icon-judge', title: '我收到的评价', url: 'home'},
		{cls: 'u-icon-more', title: '更多', url: 'home'}
	]
]


requestInfo = ->
	#TODO 假数据
	Http.post Constants.api.USER_CENTER, {
		userId: '7714d0d83c7f47f4bcfac62b9a1bf101'
	}, (data)->
		_user = _user.set 'orderDoneCount', 40
		_user = _user.set 'orderBreakCount', 2   
		_user = _user.set 'mobile', data.usercode
		_user = _user.set 'carStatus', data.carStatus
		_user = _user.set 'certification', data.certification
		_user = _user.set 'goodsStatus', data.goodsStatus
		_user = _user.set 'goodsCause', data.goodsCause
		_user = _user.set 'avatar', data.imgurl
		_user = _user.set 'carCount', data.myCarCount
		_user = _user.set 'messageCount', data.messageCount
		_user = _user.set 'warehouseCount', data.myWishlistCount
		_user = _user.set 'id', data.userId
		_user = _user.set 'warehouseStatus', data.warehouseStatus
		_user = _user.set 'warehouseCause', data.warehouseCause
		DB.put 'user', _user.toJS()
		UserStore.emitChange()

smsCode = (mobile, type)->
	Http.post Constants.api.SMS_CODE, {
		mobile: mobile
		type: type
	}, (data)->
		console.log '验证码', data[-6..]
		UserStore.emitChange 'sms:done'
	, (data)->
		Plugin.alert data.msg
		UserStore.emitChange 'sms:failed'

register = (mobile, code, passwd)->
	Http.post Constants.api.REGISTER, {
		usercode: mobile
		mobileCode: code
		password: passwd
	}, (data)->
		UserStore.emitChange 'register:done'


UserStore = assign BaseStore, {
	_smsCB: null
	getUser: ->
		_user

	getMenus: ->
		_menus
}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.USER_INFO then requestInfo()
		when Constants.actionType.SMS_CODE then smsCode(action.mobile, action.type)
		when Constants.actionType.REGISTER then register(action.mobile, action.code, action.passwd)

module.exports = UserStore
