'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

GoodsAction = {
	addPassBy: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GOODS_ADD_PASS_BY
		}
}

module.exports = GoodsAction
