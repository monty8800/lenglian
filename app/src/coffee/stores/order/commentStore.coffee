'use strict'

BaseStore = require 'stores/common/base'
Http = require 'util/http'
assign = require 'object-assign'
Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
Comment = require 'model/comment'
CommentStore = require 'stores/order/commentStore'
Immutable = require 'immutable'
DB = require 'util/storage'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'

_commentList = []

getCommentList = (userId,status,startNo,pageSize)->
	Http.post Constants.api.GET_COMMENT,{
		targetId:userId
		onsetRole:status
		startNo:startNo
		pageSize:pageSize	
		userId: UserStore.getUser()?.id
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

submitComment = (userId,userRole,targetId,targetRole,startStage,orderNo,commentValue) ->
	Http.post Constants.api.COMMENT_ADD,{
		onsetId:userId				#评价人ID
		onsetRole:userRole			#评论人角色 1：货主 2:车主 3：仓库主
		targetId:targetId			#目标评价人ID
		targetRole:targetRole		#目标评论人角色 1：货主 2:车主 3：仓库主
		orderNo:orderNo				#订单号
		score:startStage			# 评分 5星=10 
		content:commentValue		#内容
	},(data)->
		console.log '__ _评价成功__'
		DB.put 'transData', {
			del: orderNo
		}
		CommentStore.emitChange 'addNewCommentSucc'
	,(data)->
		console.log '__ _添加评价失败__'
		CommentStore.emitChange 'addNewCommentFaile'
	,true

CommentStore = assign BaseStore, {
	getCommentList: ()->
		_commentList
}

Dispatcher.register (action)->
	switch action.actionType
		when Constants.actionType.GET_COMMENT then getCommentList(action.userId,action.status,action.startNo,action.pageSize)
		when Constants.actionType.COMMENT_ADD then submitComment(action.userId,action.userRole,action.targetId,action.targetRole,action.startStage,action.orderNo,action.commentValue)


module.exports = CommentStore
