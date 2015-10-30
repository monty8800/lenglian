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

InfiniteScroll = require('react-infinite-scroll')(React)

_status = Constants.orderStatus.st_01
_page = 1
_pageSize = Constants.orderStatus.PAGESIZE
_busy = true
_hasMore = true
_count = 0


OrderDoc = React.createClass {
	minxins: [PureRenderMixin]

	_changeStatus: (status)->
		_status = status
		_page = 1
		_count = 0
		_hasMore = true
		@setState {
			orderList: []
		}
		@_requestData()

	getInitialState: ->
		{				
			orderType: ''
			orderList: OrderStore.getOrderList().toJS()
		}

	_requestData: ->
		return null if _busy
		_busy = true
		OrderAction.getOrderList _status, _page

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
			orderList = OrderStore.getOrderList()
			newState.orderList = orderList.toJS()
			_page++
			_busy = false
			_hasMore = orderList.size - _count >= _pageSize
			_count = orderList.size
			@setState newState

	render: ->
		console.log '___state', @state
		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={@_changeStatus.bind this, Constants.orderStatus.st_01}>
						<span className={ if _status is '1' then "active" else ""}>洽谈中</span>
					</li>
					<li onClick={@_changeStatus.bind this, Constants.orderStatus.st_02}>
						<span className={ if _status is '2' then "active" else ""}>待付款</span>
					</li>
					<li onClick={@_changeStatus.bind this, Constants.orderStatus.st_03}>
						<span className={ if _status is '3' then "active" else ""}>已付款</span>
					</li>
					<li onClick={@_changeStatus.bind this, Constants.orderStatus.st_04}>
						<span className={ if _status is '4' then "active" else ""}>已完成</span>
					</li>
				</ul>
			</div> 
			<InfiniteScroll pageStart=0 loadMore={@_requestData} hasMore={_hasMore and not _busy}>
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
			</InfiniteScroll>
		</div>
}

React.render <OrderDoc />, document.getElementById('content')
