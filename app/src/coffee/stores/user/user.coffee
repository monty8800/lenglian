'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
User = require 'model/user'
DB = require 'util/storage'
Immutable = require 'immutable'

localUser = DB.get 'user'
_user = new User localUser

_menus = Immutable.fromJS [
	[
		{cls: 'u-icon-message', title: '我的消息'},
		{cls: 'u-icon-goods', title: '我的货源'},
		{cls: 'u-icon-car', title: '我的车辆'},
		{cls: 'u-icon-store', title: '我的仓库'}
	],
	[
		{cls: 'u-icon-money', title: '我的钱包'},
		{cls: 'u-icon-adress', title: '我的地址'}
	],
	[
		{cls: 'u-icon-focus', title: '我的关注'},
		{cls: 'u-icon-judge', title: '我收到的评价'},
		{cls: 'u-icon-more', title: '更多'}
	]
]


requestInfo = ->
	#TODO 假数据
	_user = _user.set 'highPraiseRate', '80%'
	_user = _user.set 'orderDoneCount', 40
	_user = _user.set 'orderBreakCount', 2
	_user = _user.set 'name', '我是假数据哦'
	UserStore.emitChange()


UserStore = assign BaseStore, {
	getUser: ->
		_user

	getMenus: ->
		_menus

}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.USER_INFO then requestInfo()

module.exports = UserStore
