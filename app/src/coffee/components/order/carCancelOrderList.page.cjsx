# 车主订单已取消
require 'components/common/common'
React = require 'react'
Plugin = require 'util/plugin'
Helper = require 'util/helper'
OrderAction = require 'actions/order/order'
OrderStore = require 'stores/order/order'
Constants = require 'constants/constants'
DB = require 'util/storage'
XeImage = require 'components/common/xeImage'
avatar = require 'user-01'
PureRenderMixin = React.addons.PureRenderMixin

Item = React.createClass {

	getInitialState: ->
		{				
			orderList: OrderStore.getOrderList().toJS()
		}

	componentDidMount: ->			
		OrderAction.getCarCancelOrderList(1)
		OrderStore.addChangeListener @resultCallBack

	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		if params[0] is 'cancel_car'
			newState = Object.create @state
			newState.orderList = OrderStore.getOrderList().toJS()
			@setState newState

	_detail: (item, i)->
		DB.put 'car_owner_order_detail', [item?.carPersonUserId, item?.orderNo, item?.goodsPersonUserId, i]
		Plugin.nav.push ['carOwnerOrderDetail']

	render: ->
		items = @state.orderList.map (item, i)->
			<div className="m-item01" key={item?.orderNo} onClick={@_detail.bind this, item, i}>
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<XeImage src={item?.goodsPersonHeadPic} size='130x130' type='avatar' />
						</div>	
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<div>{item?.carPersonName}</div>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<span>订单已取消</span>
						</div>
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-start ll-font g-adr-start-line">
						{item?.destination}
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						{item?.setOut}
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>价格类型：<span>{Helper.priceTypeMapper item?.priceType}</span><span>{item?.price}元</span></p>
					<p>货物描述 : <span>{item?.goodsDesc}</span></p>
					<p>支付方式 : <span>{Helper.payTypeMapper item?.payType}</span></p>
				</div>
			</div>
		, this
		<div>{items}</div>
}

React.render <Item />, document.getElementById('content')
