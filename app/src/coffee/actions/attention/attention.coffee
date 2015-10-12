'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

AttentionAction = {
	# 关注列表
	attentionList: (statu)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ATTENTION_LIST
			status: statu
		}

	#关注
	follow: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.FOLLOW
			params: params
		}
}

module.exports = AttentionAction