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

	getGoodsList: (pageNow,pageSize,status,priceType,createTime)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.GET_GOODS_LIST
			pageNow:pageNow
			pageSize:pageSize
			status:status
			priceType:priceType
			createTime:createTime
		}
	getGoodsDetail :(goodsId) ->
		Dispatcher.dispatch {
			actionType:Constants.actionType.GET_GOODS_DETAIL
			goodsId:goodsId
		}
	# bindWarehouseOrder:(warehouseId,goodsId) ->
	# 	Dispatcher.dispatch {
	# 		actionType:Constants.actionType.GOODS_BIND_WAREHOUSE_ORDER
	# 		warehouseId:warehouseId
	# 		goodsId:goodsId
	# 	}

	searchGoods: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.SEARCH_GOODS
			params: params
		}

	changeWidgetStatus: (show, bid)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CHANGE_WIDGET_STATUS
			show: show
			bid: bid
		}

	deleteGoods:(goodsId)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.DELETE_GOODS
			goodsId: goodsId
		}
	getSearchGoodsDetail: (goodsId,focusid)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.GET_SEARCH_GOODS_DETAIL
			goodsId:goodsId
			focusid:focusid
		}
		
	handleFallow:(focusid,focustype,type)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.attention
			focusid:focusid
			focustype:focustype
			type:type
		}
}

module.exports = GoodsAction
