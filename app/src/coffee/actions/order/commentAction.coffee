'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'
UserStore = require 'stores/user/user'

CommentAction = {
	getCommentList:(status,startNo,pageSize) ->
		user = UserStore.getUser()
		console.log 'action: userId = ',user.id
		Dispatcher.dispatch {
			actionType:Constants.actionType.GET_COMMENT
			status:status
			pageSize:pageSize
			startNo:startNo
			userId:user.id
		}
	submitComment:(userRole,targetId,targetRole,startStage,orderNo,commentValue) ->
		user = UserStore.getUser()
		Dispatcher.dispatch {
			actionType:Constants.actionType.COMMENT_ADD
			#TODO: 用户角色待定
			userId:user.id		#评价人ID
			userRole:userRole				#评论人角色 1：货主 2:车主 3：仓库主
			targetId:targetId		#目标评价人ID
			targetRole:targetRole		#目标评论人角色 1：货主 2:车主 3：仓库主
			orderNo:orderNo		#订单号
			startStage:startStage		# 评分 5星=10 
			commentValue:commentValue		#内容
		}
}


module.exports = CommentAction