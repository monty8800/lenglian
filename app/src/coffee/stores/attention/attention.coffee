'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
AttentionModel = require 'model/attention'
Constants = require 'constants/constants'
Immutable = require 'immutable'
Plugin = require 'util/plugin'

UserStore = require 'stores/user/user'

_user = UserStore.getUser()


AttList = Immutable.List()

# 关注列表
AttentionList = (status)->
	console.log '--关注列表'  
	Http.post Constants.api.attention_list, {
		userId: _user?.id,
		focustype: status # 1:司机 2：货主 3：仓库
		pageNo: 0
		pageSize: 10
	}, (data) ->
		AttList = AttList.clear() 
		for att in data
			do (att)->
				tempAtt = new AttentionModel
				tempAtt = tempAtt.set 'companyName', att.companyName
				tempAtt = tempAtt.set 'userName', att.userName
				tempAtt = tempAtt.set 'imgurl', att.imgurl
				tempAtt = tempAtt.set 'focusid', att.focusid
				tempAtt = tempAtt.set 'id', att.id
				tempAtt = tempAtt.set 'wishlist', att.wishlist
				AttList = AttList.push tempAtt
		AttStore.emitChange()
	, (data) ->
		console.log 'err'

follow = (params)->
	Http.post Constants.api.attention, params, (data)->
		msg = if parseInt(params.type) is 1 then '关注成功！' else '已取消关注!'
		Plugin.toast.success msg
	AttStore.emitChange {
		msg: 'follow:done'
		followed: parseInt(params.type) is 1
	}

AttStore = assign BaseStore, {
	getAttList: ->
		AttList

}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.ATTENTION_LIST then AttentionList(action.status)
		when Constants.actionType.FOLLOW then follow(action.params)

module.exports = AttStore
