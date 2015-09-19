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
		{cls: 'u-icon-more', title: '更多', url: 'more'}
	]
]


requestInfo = ->
	if not _user?.id
		return
	Http.post Constants.api.USER_CENTER, {
		userId: _user.id
	}, (data)->
		_user = _user.set 'orderDoneCount', data.myOrderCount
		# _user = _user.set 'orderBreakCount', 2   
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
		_user = _user.set 'name', data.userName #个人名或者公司名，服务器合并到这个字段返回
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

login = (mobile, passwd)->
	console.log 'do login', mobile, passwd
	Http.post Constants.api.LOGIN, {
		usercode: mobile
		password: passwd
	}, (data)->
		_user = _user.set 'carStatus', data.carStatus
		_user = _user.set 'certification', data.certification
		_user = _user.set 'goodsStatus', data.goodsStatus
		_user = _user.set 'avatar', data.imgurl
		_user = _user.set 'id', data.userId
		_user = _user.set 'mobile', data.usercode
		_user = _user.set 'warehouseStatus', data.warehouseStatus
		DB.put 'user', _user.toJS()
		UserStore.emitChange 'login:done'

resetPwd = (mobile, code, passwd)->
	Http.post Constants.api.RESET_PWD, {
		usercode: mobile
		mobileCode: code
		password: passwd
	}, (data)->
		UserStore.emitChange 'resetPasswd:done'

changePwd = (oldPasswd, newPasswd)->
	Http.post Constants.api.CHANGE_PWD, {
		userId: _user?.id
		oldpwd: oldPasswd
		newpwd: newPasswd
	}, (data)->
		UserStore.emitChange 'changePasswd:done'

UserStore = assign BaseStore, {
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
		when Constants.actionType.LOGIN then login(action.mobile, action.passwd)
		when Constants.actionType.RESET_PWD then resetPwd(action.mobile, action.code, action.passwd)
		when Constants.actionType.CHANGE_PWD then changePwd(action.oldPasswd, action.newPasswd)

module.exports = UserStore
