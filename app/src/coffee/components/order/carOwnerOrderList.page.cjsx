# 车主订单列表
require 'components/common/common'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
Plugin = require 'util/plugin'
Helper = require 'util/helper'

CarOrderAction = require 'actions/order/carOrder'
CarOrderStore = require 'stores/order/carOrder'

DRIVER_LOGO = require 'user-01.jpg'

CAROWNER = require 'actions/order/carOrder'

st_01 = '1'
st_02 = '2'
st_03 = '3'
st_04 = '4'
st_05 = '5'

OrderItem = React.createClass {
	render: ->
		items = @props.items.map (item, i)->
			<div className="m-item01">
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<img src={ DRIVER_LOGO } />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{item.carPersonName}</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<a href="#" className="u-btn02">接受</a>
						</div>
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-start ll-font g-adr-start-line">
						{ item.destination}
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						{ item.setOut }
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>价格类型：<span>{Helper.payTypeMapper item.priceType}</span><span>{item.price}元</span></p>
					<p>货物描述 : <span>{ item.goodsDesc }</span></p>
					<p>支付方式 : <span>{ Helper.priceTypeMapper item.priceType }</span><span>{ item.advance }元</span></p>
				</div>
			</div>
		<div>{ items }</div>
}

OrderList = React.createClass {

	# 洽谈中
	status_01: ->
		newState = Object.create @state
		newState.type = st_01
		@setState newState
		CarOrderAction.orderList(st_01);

	# 待付款
	status_02: ->
		newState = Object.create @state
		newState.type = st_02
		@setState newState
		CarOrderAction.orderList(st_02);

	# 已付款
	status_03: ->
		newState = Object.create @state
		newState.type = st_03
		@setState newState
		CarOrderAction.orderList(st_03);

	# 待评价
	status_04: ->
		newState = Object.create @state
		newState.type = st_04
		@setState newState
		CarOrderAction.orderList(st_04);

	getInitialState: ->
		{
			type: st_01
			carOrderList: CarOrderStore.getCarOrderList().toJS()
		}

	componentDidMount: ->
		CarOrderStore.addChangeListener @resultCallBack
		CarOrderAction.orderList(st_01);

	componentWillUnmount: ->
		CarOrderStore.removeChangeListener @resultCallBack

	resultCallBack: ->
		@setState {
			carOrderList: CarOrderStore.getCarOrderList()
		}


	minxins: [PureRenderMixin]
	render: ->
		console.log 'carOrderList --- ', @state.carOrderList
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
						<span className={ if @state.type is '4' then "active" else ""}>待评价</span>
					</li>
				</ul>
			</div>
			<OrderItem items={@state.carOrderList} />
		</div>
}

React.render <OrderList />, document.getElementById('content')
