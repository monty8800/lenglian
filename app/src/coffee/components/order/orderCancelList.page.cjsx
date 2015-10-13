# 车主、货主、仓库订单列表
require 'components/common/common'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
CSSTransitionGroup = React.addons.CSSTransitionGroup
Plugin = require 'util/plugin'
Helper = require 'util/helper'
Constants = require 'constants/constants'
OrderAction = require 'actions/order/order'
OrderStore = require 'stores/order/order'

CarItem = require 'components/order/carOrderCell'
GoodsItem = require 'components/order/goodsOrderCell'
StoreItem = require 'components/order/storeOrderCell'


#TODO: 分页
OrderCancelList = React.createClass {
	minxins: [PureRenderMixin]

	_getCancelList: ->
		OrderAction.getOrderList(Constants.orderStatus.st_05, 1)

	getInitialState: ->
		{				
			orderList: OrderStore.getOrderList().toJS()
		}

	componentDidMount: ->
		# 浏览器调试(临时)	
		# OrderAction.browerTemp(0)
		OrderStore.addChangeListener @resultCallBack

	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		# type: 'car'司机订单  'goods'货主订单  'store'仓库订单
		console.log 'params in order list', params
		if params[0] is 'car' || params[0] is 'goods' || params[0] is 'store'
			@setState {
				orderList: OrderStore.getOrderList().toJS()
				orderType: params[0]
			}

	render: ->
		console.log '___state', @state
		<div>
			<div className="m-tab01"> 
				{
					switch @state.orderType
						when 'car'
							<CarItem items=@state.orderList />
						when 'goods'
							goodsOrderList = @state.orderList.map (order, i)->
								<GoodsItem order={order} key={order.orderNo} />
							<div>
							
							{goodsOrderList}
							
							</div>
						when 'store'
							<StoreItem items=@state.orderList />
								
				}
			</div>
		</div>
}

React.render <OrderCancelList />, document.getElementById('content')
