'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
Comment = require 'model/comment'
CommentStore = require 'stores/user/commentStore'
Immutable = require 'immutable'
DB = require 'util/storage'
Plugin = require 'util/plugin'

_commentList = []

getCommentList = (userId,status,startNo,pageSize)->
	Http.post Constants.api.GET_COMMENT,{
		targetId:userId
		onsetRole:status
		startNo:startNo
		pageSize:pageSize
	},(data)->
		comment = new Comment
		if startNo is '0'
			_commentList = [];
		for aComment in data
			comment = comment.set 'onsetId', aComment.onsetId
			comment = comment.set 'onsetRole', aComment.onsetRole
			comment = comment.set 'onsetUsercode', aComment.onsetUsercode
			comment = comment.set 'targetId', aComment.targetId
			comment = comment.set 'targetRole', aComment.targetRole
			comment = comment.set 'targetUsercode', aComment.targetUsercode
			comment = comment.set 'content', aComment.content
			comment = comment.set 'createTime', aComment.createTime
			comment = comment.set 'orderNo', aComment.orderNo
			comment = comment.set 'score', aComment.score
			comment = comment.set 'id', aComment.id
			comment = comment.set 'onsetName', aComment.onsetName
			comment = comment.set 'onsetName', aComment.onsetName
			_commentList.push comment

		console.log '__ _评价列表__',_commentList
		CommentStore.emitChange 'getCommentList'
	,null,true

CommentStore = assign BaseStore, {
	getCommentList: ()->
		_commentList
}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_COMMENT then getCommentList(action.userId,action.status,action.startNo,action.pageSize)


module.exports = CommentStore
