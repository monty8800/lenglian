React = require 'react'

XeImage = require 'components/common/xeImage'

OrderAction = require 'actions/order/order'

UserStore = require 'stores/user/user'

OrderStore = require 'stores/order/order'

#TODO: 评分

#为了优化性能，这里发请求前注册监听，收到后销毁监听，因为列表可能很大，一直监听对性能伤害大
OrderBidDriverList = React.createClass {
	_select: ->
		console.log 'select this!'

	_getBidList: ->
		console.log 'get bid list---'
		OrderStore.addOneTimeListener @resultCallBack, 'request:bid:list'
		OrderAction.getBidList {
			userId: UserStore.getUser()?.id
			goodsResourceId: @props.order.goodsSourceId
		}
		
	getInitialState: ->
		{
			bidList: null
		}

	resultCallBack: (params)->
		console.log 'event------', params
		@setState {
			bidList: OrderStore.getBidList()
		}

	componentWillReceiveProps: (nextProps)->
		@_getBidList() if nextProps.show and not @state.bidList

	render: ->
		console.log 'bid list state---', @state
		bidCells = @state.bidList?.map (bid, i)->
			<div className="g-order">				
				<div className="g-order-pic">
					<XeImage src={bid.userHeadPic} size='130x130' type='avatar' />
				</div>
				<div className="g-order-msg">
					<div className="g-order-name">
						<span>{bid.userName + ' '}</span>
						<span>{bid.price + '元'}</span>
					</div>
					<div className="g-order-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
				</div>
				<div className="g-order-btn">
					<a onClick={@_select} className="u-btn02">选择该司机</a>
				</div>
			</div>
		, this


		<div className="g-item-order" style={{height: if @props.show then 'auto' else '0px'}}>
			{bidCells}
		</div>
}

module.exports = OrderBidDriverList