
'use strict'

Dispatcher = require 'dispatcher/dispatcher'
Constants = require 'constants/constants'

OrderAction = {
	# 获取订单列表
	getOrderList: (statu, pageNo)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_LIST
			status: statu
			currentPage: pageNo
		}

	# 订单详情
	getOrderDetail: (orderid)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_DETAIL
			orderId: orderid
		}

	carSelectGoods: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_CAR_SELECT_GOODS
			params: params
		}

	getBidList: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_BID_LIST
			params: params
		}

	getBidGoodsDetail: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_BID_GOODS_DETAIL
			params: params
		}

	carBidGoods: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_CAR_BID_GOODS
			params: params
		}
	# browertemp
	browerTemp: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.BROWSER_TEMP
			params: params
		}
	getBiddingList: (goodsResourceId)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.GET_BIDDING_LIST
			goodsResourceId: goodsResourceId
		}

	selectBidCar: (params, orderId)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_SELECT_BID_CAR
			params: params
			orderId: orderId
		}

	goodsAgree: (params, orderId)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_GOODS_AGREE
			params: params
			orderId: orderId
		}

	carOwnercomfitOrder: (carPersonUserId, orderNo, version, orderCarId, index)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_OWNER_CONFIRM_ORDER
			carPersonUserId: carPersonUserId
			orderNo: orderNo
			version: version
			orderCarId: orderCarId
			index: index
		}	

	carOwnercomfitOrder2: (carPersonUserId, orderNo, version, orderCarId, index)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_OWNER_CONFIRM_ORDER2
			carPersonUserId: carPersonUserId
			orderNo: orderNo
			version: version
			orderCarId: orderCarId
			index: index
		}		
	carOwnerCancelOrder: (carPersonUserId, orderNo, version, orderCarId, index)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_OWNER_CANCEL_ORDER
			carPersonUserId: carPersonUserId
			orderNo: orderNo
			version: version
			orderCarId: orderCarId
			index: index			
		}	
	carOwnerOrderDetail: (carPersonUserId, orderNo, goodsPersonUserId, orderCarId)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CAR_OWNER_ORDER_DETAIL
			carPersonUserId: carPersonUserId
			orderNo: orderNo
			goodsPersonUserId: goodsPersonUserId
			orderCarId: orderCarId
		}
	carOwnerOrderFinish: (orderNo, version, carPersonUserId)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_FINISH
			orderNo: orderNo
			version: version
			carPersonUserId: carPersonUserId
		}

	attention: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ATTENTION
			params: params
		}

	goodsOrderDone: (params, orderId)->	
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_GOODS_FINISH
			params: params
			orderId: orderId
		}

	goodsOrderDetail: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_GOODS_DETAIL
			params: params
		}

	getCancelOrderList: ->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CANCEL_CAR_ORDER_LIST
		}

	getWarehouseOrderDetail:(params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_WAREHOUSE_DETAIL
			params: params
		}
	warehouseAcceptOrder:(params,index)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.WAREHOUSE_ACCEPT_ORDER
			params:params
			index:index
		}
		
	warehouseCancleOrder:(params,index)->
		Dispatcher.dispatch {
			actionType:Constants.actionType.WAREHOUSE_CANCLE_ORDER
			params:params
			index:index
		}


	cancelGoodsOrder: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_GOODS_CANCEL
			params: params
		}

	repubGoodsOrder: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ORDER_GOODS_REPUB
			params: params
		}
		
	getCarCancelOrderList: (pageNo)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.CANCEL_CAR_ORDER_LIST
			currentPage: pageNo
		}

	postAlreadyStatus: (params)->
		Dispatcher.dispatch {
			actionType: Constants.actionType.ALREADLY_STATUS
			params: params
		}
				
}

module.exports = OrderAction
