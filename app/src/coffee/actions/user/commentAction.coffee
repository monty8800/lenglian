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
}


module.exports = CommentAction