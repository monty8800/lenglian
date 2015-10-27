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


OrderDoc = React.createClass {
	minxins: [PureRenderMixin]

	# 洽谈中
	status_01: ->
		newState = Object.create @state
		newState.type = Constants.orderStatus.st_01
		@setState newState
		OrderAction.getOrderList(Constants.orderStatus.st_01, 1)

	# 待付款
	status_02: ->
		newState = Object.create @state
		newState.type = Constants.orderStatus.st_02
		@setState newState
		OrderAction.getOrderList(Constants.orderStatus.st_02, 1)

	# 已付款
	status_03: ->
		newState = Object.create @state
		newState.type = Constants.orderStatus.st_03
		@setState newState
		OrderAction.getOrderList(Constants.orderStatus.st_03, 1)

	# 待评价
	status_04: ->
		newState = Object.create @state
		newState.type = Constants.orderStatus.st_04
		@setState newState
		OrderAction.getOrderList(Constants.orderStatus.st_04, 1)

	getInitialState: ->
		{				
			orderType: ''
			type: Constants.orderStatus.st_01
			orderList: OrderStore.getOrderList().toJS()
		}

	componentDidMount: ->
		# 浏览器调试(临时)	
		OrderAction.browerTemp(1)
		OrderStore.addChangeListener @resultCallBack

	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		# type: 'car'司机订单  'goods'货主订单  'store'仓库订单
		console.log 'params in order list', params
		if params[0] is 'car' or params[0] is 'goods' or params[0] is 'store'
			newState = Object.create @state
			newState.orderType = params[0]
			newState.orderList = OrderStore.getOrderList().toJS()
			@setState newState

	render: ->
		console.log '___state', @state
		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={@status_01}>
						<span className={ if @state.type is '1' then "active" else ""}>洽谈中</span>
					</li>
					<li onClick={@status_02}>
						<span className={ if @state.type is '2' then "active" else ""}>待付款</span>
					</li>
					<li onClick={@status_03}>
						<span className={ if @state.type is '3' then "active" else ""}>已付款</span>
					</li>
					<li onClick={@status_04}>
						<span className={ if @state.type is '4' then "active" else ""}>已完成</span>
					</li>
				</ul>
			</div> 
			{
				switch @state.orderType
					when 'car'
						<CarItem items=@state.orderList />
					when 'goods'
						goodsOrderList = @state.orderList.map (order, i)->
							<GoodsItem order={order} key={order.orderNo} />
						<div>
						<CSSTransitionGroup transitionName="list">
						{goodsOrderList}
						</CSSTransitionGroup>
						
						</div>
					when 'store'
						<StoreItem items=@state.orderList />
							
			}
		</div>
}

React.render <OrderDoc />, document.getElementById('content')
