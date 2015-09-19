'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
AttentionModel = require 'model/attention'
Constants = require 'constants/constants'
Immutable = require 'immutable'


AttList = Immutable.List()

# 关注列表
AttentionList = (status)->
	console.log '--关注列表'  
	Http.post Constants.api.attention_list, {
		userId: '4671d0d8c37f47f4bcfa2323222bf102',
		focustype: status # 1:司机 2：货主 3：仓库
	}, (data) ->
		console.log '---- ', data
		AttList = AttList.clear() 
		for att in data
			do (att)->
				tempAtt = new AttentionModel
				tempAtt = tempAtt.set 'companyName', att.companyName
				tempAtt = tempAtt.set 'userName', att.userName
				tempAtt = tempAtt.set 'imgurl', att.imgurl
				tempAtt = tempAtt.set 'focusid', att.focusid
				tempAtt = tempAtt.set 'id', att.id
				AttList = AttList.push tempAtt
		AttStore.emitChange()
	, (data) ->
		console.log 'err'


AttStore = assign BaseStore, {
	getAttList: ->
		AttList

}

Dispatcher.register (action) ->
	switch action.actionType
		when Constants.actionType.ATTENTION_LIST then AttentionList(action.status)

module.exports = AttStore