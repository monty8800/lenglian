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

paths = window.location.href.split('/')
_htmlPage = paths[paths.length-1]

localUser = DB.get 'user'
_user = new User localUser

_needRegisterCode = DB.get 'need_register_code'


XeCrypto = require 'util/crypto'

#过期自动匿名登陆

autoLogin = ->
	console.log 'lastLogin', _user?.lastLogin
	result = (new Buffer(_user.passwd, 'base64')).toString('utf8')
	tmpPasswd = result[-16..]
	encryptPasswd = result[0...-16]
	plainPasswd = XeCrypto.aesDecrypt tmpPasswd, encryptPasswd
	console.log 'plainPasswd', plainPasswd


	Http.post Constants.api.LOGIN, {
		usercode: _user.mobile
		password: plainPasswd
	}, (data)->
		_user = _user.set 'carStatus', parseInt(data.carStatus) if parseInt(data.carStatus) isnt 0
		_user = _user.set 'certification', parseInt(data.certification) if parseInt(data.certification) isnt 0
		_user = _user.set 'goodsStatus', parseInt(data.goodsStatus) if parseInt(data.goodsStatus) isnt 0
		_user = _user.set 'avatar', data.imgurl
		_user = _user.set 'id', data.userId
		_user = _user.set 'lastLogin', (new Date).getTime()
		_user = _user.set 'warehouseStatus', parseInt(data.warehouseStatus) if parseInt(data.warehouseStatus) isnt 0
		if _user.hasPayPwd is 0
			_user = _user.set 'hasPayPwd', parseInt(data.isPayStatus)
		DB.put 'user', _user.toJS()
		Plugin.run [9, 'user:update', _user.toJS()]
	, (data)->
		console.log JSON.stringify(data)
		Plugin.toast.err '会话已过期，请重新登录'
		logout()
	, false

if _user.passwd and ((new Date).getTime() - _user.lastLogin > Constants.cache.KEEP_LOGIN_TIME)
	autoLogin()

needCheck = ->
	return _user.carStatus is 2 or _user.goodsStatus is 2 or _user.warehouseStatus is 2 or (not _user.name and not _user.company)

updateUser = ->
	localUser = DB.get 'user'
	_user = new User localUser
	console.log 'new user', _user
	now = new Date
	cacheTime = if needCheck() then Constants.cache.USER_INFO_MIN else Constants.cache.USER_INFO
	if _user.id and  (now.getTime() - _user.lastUpdate >  cacheTime)
		requestInfo()
	else
		UserStore.emitChange 'user:update'

window.updateUser = updateUser

updateStore = ->
	if _htmlPage is 'orderPay.html'
		localUser = DB.get 'user'
		_user = new User localUser
		console.log 'new user', _user
		UserStore.emitChange 'user:update'
	else
		updateUser()

window.updateStore = updateStore

window.setAuthPic = (picUrl, type)->
	console.log 'set auth pic', type, picUrl
	console.log '-------before----user:', _user.toJS()
	_user = _user.set type, picUrl
	console.log '-------after----user:', _user.toJS()
	DB.put 'user', _user.toJS()
	UserStore.emitChange 'setAuthPic:done'
	UserStore.emitChange ['setAuthPicType', type, picUrl]

window.authDone = ->
	UserStore.emitChange 'auth:done'


clearAuthPic = (type)->
	console.log 'clear auth pic ', type
	_user = _user.set type, null
	DB.put 'user', _user.toJS()
	UserStore.emitChange 'setAuthPic:done'

_menus = Immutable.fromJS [
	[
		{cls: 'u-icon-message', title: '我的消息', url: 'messageList'},
		{cls: 'u-icon-goods', title: '我的货源', url: 'myGoods'},
		{cls: 'u-icon-car', title: '我的车辆', url: 'myCar'},
		{cls: 'u-icon-store', title: '我的仓库', url: 'myWarehouse'}
	],
	[
		{cls: 'u-icon-money', title: '我的钱包', url: 'wallet'},
		{cls: 'u-icon-adress', title: '我的地址', url: 'addressList'}
	],
	[
		{cls: 'u-icon-focus', title: '我的关注', url: 'attentionList'},
		{cls: 'u-icon-judge', title: '我收到的评价', url: 'myComment'},
		{cls: 'u-icon-more', title: '更多', url: 'more'}
	]
]


requestPersonalAuthInfo = (type)->
	console.log 'request personalAuth info', type
	Http.post Constants.api.GET_PERSONAL_AUTH_INFO, {
		type: type
		userId: _user.id
	}, (data)->
		_user = _user.merge {
			idCardNo: data.cardno if data.cardno
			carNo: data.carno if data.carno
			license: data.drivingImg + '|certificates' if data.drivingImg
			vinNo: data.frameno if data.frameno
			idCard: data.idcardImg + '|certificates' if data.idcardImg
			operationLicense: data.taxiLicenseImg + '|certificates' if data.taxiLicenseImg
			name: data.username if data.username
		}
		DB.put 'user', _user.toJS()
		UserStore.emitChange 'user:update'



requestCompanyAuthInfo = (type)->
	console.log 'request company auth info', type
	Http.post Constants.api.GET_COMPANY_AUTH_INFO, {
		type: type
		userId: _user.id
	}, (data)->
		_user = _user.merge {
			transLicensePic: data.transportImg + '|certificates' if data.transportImg
			street: data.street if data.street
			address: data.provinceName + data.cityName + data.areaName if data.areaName
			businessLicense: data.businessLicenseImg  + '|certificates' if data.businessLicenseImg
			organizingCode: data.certifies if data.certifies
			company: data.name if data.name
			companyPic: data.doorImg + '|certificates' if data.doorImg
			businessLicenseNo: data.licenseno if data.licenseno
			transLicenseNo: data.permits if data.permits
			tel: data.phone if data.phone
			name: data.principalName if data.principalName
		}
		DB.put 'user', _user.toJS()
		UserStore.emitChange 'user:update'


requestInfo = ->
	if not _user?.id
		return
	Http.post Constants.api.USER_CENTER, {
		userId: _user.id
	}, (data)->
		now = new Date
		_user = _user.set 'lastUpdate', now.getTime()
		_user = _user.set 'orderDoneCount', parseInt(data.myOrderCount)
		# _user = _user.set 'orderBreakCount', 2   
		_user = _user.set 'mobile', data.usercode
		_user = _user.set 'carStatus', parseInt(data.carStatus)
		_user = _user.set 'certification', parseInt(data.certification)
		_user = _user.set 'goodsStatus', parseInt(data.goodsStatus)
		_user = _user.set 'goodsCause', data.goodsCause
		_user = _user.set 'avatar', data.imgurl
		_user = _user.set 'carCount', parseInt(data.myCarCount)
		_user = _user.set 'messageCount', parseInt(data.messageCount)
		_user = _user.set 'warehouseCount', parseInt(data.myWishlistCount)
		_user = _user.set 'id', data.userId
		_user = _user.set 'warehouseStatus', parseInt(data.warehouseStatus)
		_user = _user.set 'warehouseCause', data.warehouseCause
		_user = _user.set 'name', data.userName #个人名或者公司名，服务器合并到这个字段返回

		# 公司认证地址信息
		_user = _user.set 'warehouseAddress', data.warehouseAddress
		_user = _user.set 'warehouseStreet', data.warehouseStreet
		_user = _user.set 'goodsAddress', data.goodsAddress
		_user = _user.set 'goodsStreet', data.goodsStreet

		if _user.hasPayPwd is 0
			_user = _user.set 'hasPayPwd', parseInt(data.isPayStatus) 
		_user = _user.set 'balance', data.balance

		pGoodsStatus = parseInt(data?.personalGoodsStatus)
		pCarStatus = parseInt(data?.personalCarStatus)
		pWarehouseStatus = parseInt(data?.personalWarehouseStatus)

		cGoodsStatus = parseInt(data?.enterpriseGoodsStatus)
		cCarStatus = parseInt(data?.enterpriseCarStatus)
		cWarehouseStatus = parseInt(data?.enterpriseWarehouseStatus)

		if _user.certification is 0 #认证中的话，接口返回的不准，自己判断
			if 0 in [pGoodsStatus, pCarStatus, pWarehouseStatus]
				_user = _user.set 'certification', 1
			else if 0 in [cGoodsStatus, cCarStatus, cWarehouseStatus]
				_user = _user.set 'certification', 2

		# marked 🐶 🐻 🐷
		_user = _user.set 'personalGoodsStatus', pGoodsStatus if pGoodsStatus in [0..2]
		_user = _user.set 'personalGoodsCause', data?.personalGoodsCause
		_user = _user.set 'personalCarStatus', pCarStatus if pCarStatus in [0..2]
		_user = _user.set 'personalCarCause', data?.personalCarCause
		_user = _user.set 'personalWarehouseStatus', pWarehouseStatus if pWarehouseStatus in [0..2]
		_user = _user.set 'personalWarehouseCause', data?.personalWarehouseCause
		_user = _user.set 'enterpriseGoodsStatus', cGoodsStatus if cGoodsStatus in [0..2]
		_user = _user.set 'enterpriseGoodsCause', data?.personalWarehouseCause
		_user = _user.set 'enterpriseCarStatus', cCarStatus if cCarStatus in [0..2]
		_user = _user.set 'enterpriseCarCause', data?.personalWarehouseCause
		_user = _user.set 'enterpriseWarehouseStatus', cWarehouseStatus if cWarehouseStatus in [0..2]
		_user = _user.set 'enterpriseWarehouseCause', data?.personalWarehouseCause

		#兼容以前代码
		codeMap = {
			'goodsStatus': [pGoodsStatus, cGoodsStatus]
			'carStatus': [pCarStatus, cCarStatus]
			'warehouseStatus': [pWarehouseStatus, cWarehouseStatus]
		}

		for k in Object.keys(codeMap)
			v = codeMap[k]
			console.log 'k is ', k, 'v is ', v
			if _user.certification is 0
				_user = _user.set k, 0
			else
				value = v[_user.certification - 1]
				switch value
					when 0 then _user = _user.set k, 2
					when 1 then _user = _user.set k, 1
					when 2 then _user = _user.set k, 3
					else _user = _user.set k, 0
				
			

		DB.put 'user', _user.toJS()
		Plugin.run [9, 'user:update', _user.toJS()]

		#跨手机，跨账号同步数据
		#个人数据
		if _user.certification is 1
			if _user.carStatus is 1
				requestPersonalAuthInfo 2
			else if _user.goodsStatus is 1
				requestPersonalAuthInfo 1
			else if _user.warehouseStatus is 1
				requestPersonalAuthInfo 3
			else
				UserStore.emitChange 'user:update'
		else if _user.certification is 2
			if _user.carStatus is 1
				requestCompanyAuthInfo 2
			else if _user.goodsStatus is 1
				requestCompanyAuthInfo 1
			else if _user.warehouseStatus is 1
				requestCompanyAuthInfo 3
			else
				UserStore.emitChange 'user:update'
		else
			UserStore.emitChange 'user:update'
		# checkPayPwd() if _user.hasPayPwd isnt 1

smsCode = (params)->
	Http.post Constants.api.SMS_CODE, params, (data)->
		console.log '验证码', data[-7..-1]
		UserStore.emitChange 'sms:done'
	, (data)->
		Plugin.toast.err data.msg
		UserStore.emitChange 'sms:failed'

register = (mobile, code, passwd, inviteCode)->
	Http.post Constants.api.REGISTER, {
		usercode: mobile
		mobileCode: code
		password: passwd
		inviteCode: inviteCode if inviteCode?.length > 0
	}, (data)->
		tmpPasswd = (Math.random() + '')[-16..]
		encryptPasswd = XeCrypto.aesEncrypt tmpPasswd, passwd
		result = (new Buffer(encryptPasswd + tmpPasswd)).toString('base64')
		_user = _user.set 'id', data.userId
		_user = _user.set 'mobile', mobile
		_user = _user.set 'passwd', result
		DB.put 'user', _user.toJS()
		DB.put 'LAST_LOGIN_MOBILE', mobile
		Plugin.run [9, 'user:update', _user.toJS()]
		autoLogin()
		UserStore.emitChange 'register:done'

login = (mobile, passwd)->
	console.log 'do login', mobile, passwd
	Http.post Constants.api.LOGIN, {
		usercode: mobile
		password: passwd
	}, (data)->
		tmpPasswd = (Math.random() + '')[-16..]
		encryptPasswd = XeCrypto.aesEncrypt tmpPasswd, passwd
		result = (new Buffer(encryptPasswd + tmpPasswd)).toString('base64')
		console.log 'tmpPasswd:', tmpPasswd, ' encryptPasswd:', encryptPasswd, ' result:', result
		_user = _user.set 'carStatus', parseInt(data.carStatus) if parseInt(data.carStatus) isnt 0
		_user = _user.set 'certification', parseInt(data.certification) if parseInt(data.certification) isnt 0
		_user = _user.set 'goodsStatus', parseInt(data.goodsStatus) if parseInt(data.goodsStatus) isnt 0
		_user = _user.set 'avatar', data.imgurl
		_user = _user.set 'id', data.userId
		_user = _user.set 'mobile', data.usercode
		_user = _user.set 'passwd', result
		_user = _user.set 'lastLogin', (new Date).getTime()
		_user = _user.set 'warehouseStatus', parseInt(data.warehouseStatus) if parseInt(data.warehouseStatus) isnt 0
		if _user.hasPayPwd is 0
			_user = _user.set 'hasPayPwd', parseInt(data.isPayStatus)
		DB.put 'user', _user.toJS()
		DB.put 'LAST_LOGIN_MOBILE', mobile
		UserStore.emitChange 'login:done'
		Plugin.run [9, 'user:update', _user.toJS()]
	, null
	, true

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

checkPayPwd = ->
	if not _user?.id
		return
	Http.post Constants.api.HAS_PAY_PWD, {
		userId: _user?.id
	}, (data)->
		_user = _user.set 'hasPayPwd', data.status
		DB.put 'user', _user.toJS()

setPayPwd = (payPwd, oldPwd)->
	Http.post Constants.api.PAY_PWD, {
		userId: _user.id
		payPassword: payPwd
		oldPayPwd: oldPwd if oldPwd
	}, (result)->
		console.log '-------setPayPwd--------', result
		if result.status is 1
			_user = _user.set 'hasPayPwd', 1
			DB.put 'user', _user.toJS()
			UserStore.emitChange 'setPayPwd:done'
		else
			UserStore.emitChange 'setPayPwd:failed'

resetPayPwd = (mobile, code, passwd)->
	Http.post Constants.api.RESET_PAY_PWD, {
		usercode: mobile
		mobileCode: code
		userId: _user?.id
		password: passwd
	}, (result)->
		if result is 1
			_user = _user.set 'hasPayPwd', 1
			DB.put 'user', _user.toJS()
			UserStore.emitChange 'resetPayPwd:done'
		else
			UserStore.emitChange 'resetPayPwd:failed'

logout = ->
	DB.remove 'user'
	DB.remove 'lastBankCard'
	_user = new User
	UserStore.emitChange 'logout'
	Plugin.run [9, 'user:update', '{}']

personalAuth = (params, files)->
	Http.postFile Constants.api.PERSONAL_AUTH, params, files, (data)->
		console.log 'auth result', data
		UserStore.emitChange 'auth:done'

companyAuth = (params, files)->
	Http.postFile Constants.api.COMPANY_AUTH, params, files, (data)->
		console.log 'auth result', data
		UserStore.emitChange 'auth:done'

updateUserProps = (properties)->
	console.log 'set properties to user', properties
	_user = _user.merge properties
	DB.put 'user', _user.toJS()
	UserStore.emitChange 'user:update'
	Plugin.run [9, 'user:update', _user.toJS()]

window.updateUserProps = updateUserProps

needRegisterCode = ->
	Http.post Constants.api.NEED_REGISTER_CODE, {}, (data)->
		console.log 'needRegisterCode', data
		DB.put 'need_register_code', data.flag
		_needRegisterCode = parseInt data.flag
		UserStore.emitChange 'need_register_code'
UserStore = assign BaseStore, {
	getUser: ->
		new User (DB.get 'user')

	getMenus: ->
		_menus

	needRegisterCode: ->
		_needRegisterCode is 1
}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.USER_INFO then requestInfo()
		when Constants.actionType.SMS_CODE then smsCode(action.params)
		when Constants.actionType.REGISTER then register(action.mobile, action.code, action.passwd, action.inviteCode)
		when Constants.actionType.LOGIN then login(action.mobile, action.passwd)
		when Constants.actionType.RESET_PWD then resetPwd(action.mobile, action.code, action.passwd)
		when Constants.actionType.CHANGE_PWD then changePwd(action.oldPasswd, action.newPasswd)
		when Constants.actionType.PAY_PWD then setPayPwd(action.payPwd, action.oldPwd)
		when Constants.actionType.RESET_PAY_PWD then resetPayPwd(action.mobile, action.code, action.passwd)
		when Constants.actionType.LOGOUT then logout()
		when Constants.actionType.PERSONAL_AUTH then personalAuth(action.params, action.files)
		when Constants.actionType.CLEAR_AUTH_PIC then clearAuthPic(action.type)
		when Constants.actionType.UPDATE_USER then updateUserProps(action.properties)
		when Constants.actionType.COMPANY_AUTH then companyAuth(action.params, action.files)
		when Constants.actionType.AUTO_LOGIN then autoLogin()
		when Constants.actionType.UPDATE_STORE then updateStore()
		when Constants.actionType.NEED_REGISTER_CODE then needRegisterCode()

module.exports = UserStore
