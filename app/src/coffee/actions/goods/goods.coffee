'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

GoodsAction = {
	addPassBy: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GOODS_ADD_PASS_BY
		}
	addGoods: (params, files)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ADD_GOODS
			params: params
			files: files
		}

	clearPic: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CLEAR_GOODS_PIC
		}
	clearGoods: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CLEAR_GOODS
		}
}

module.exports = GoodsAction
