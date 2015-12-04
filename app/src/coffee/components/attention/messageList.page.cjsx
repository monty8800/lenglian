require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
CSSTransitionGroup = React.addons.CSSTransitionGroup
InfiniteScroll = require('react-infinite-scroll')(React)
MessageStore = require 'stores/attention/message'
MessageAction = require 'actions/attention/message'
Constants = require 'constants/constants'
UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'

Immutable = require 'immutable'

InfiniteScroll = require('react-infinite-scroll')(React)

_role = 2
_page = 1
_pageSize = 20
_hasMore = true
_busy = false
_count = 0

Item = React.createClass {

	orderDetail: ->
		index = @props.index
		return null if !@props.items.flag
		if index is 1
			console.log '-----------货'
			DB.put 'transData', {orderNo: @props.items?.orderId}
			Plugin.nav.push ['goodsOrderDetail']
		else if index is 2
			console.log '-----------车'
			DB.put 'car_owner_order_detail', ['', @props.items?.orderId, @props.items?.goodsPersonUserId, @props.items?.orderCarId]
			Plugin.nav.push ['carOwnerOrderDetail']
		else if index is 3
			console.log '-----------库'
			params = {
				orderNo: @props.items?.orderId,
				goodsPersonUserId: @props.items?.goodsPersonUserId
			}
			DB.put 'transData', params
			Plugin.nav.push ['warehouseOrderDetail']

	render: ->
		<div className="m-item02 m-item02-msg">
			{ @props.items?.content }
			<a style={{display: if @props.items.orderId is undefined or @props.items.orderId is null or @props.items.orderId is '' then 'none' else 'block' }} href="###" onClick={@orderDetail} className="u-btn02">去查看</a>
		</div>
}

Message = React.createClass {
	_selectRole: (role)->
		_role = role
		_page = 1
		_count = 0
		_hasMore = true
		@setState {
			msgList: Immutable.List()
		}
		@_requestData()


	getInitialState: ->
		{
			msgList: MessageStore?.getMsgList()
		}

	componentDidMount: ->
		MessageStore.addChangeListener @resultCallBack

	componentWillUnMount: ->
		MessageStore.removeChangeListener @resultCallBack

	resultCallBack: ->
		list = MessageStore?.getMsgList()
		_busy = false
		_hasMore = list.size - _count >= _pageSize
		_count = list.size
		_page++
		@setState {
			msgList: list
		}

	_requestData: ->
		return null if _busy
		_busy = true
		params = {
			userId: UserStore.getUser()?.id
			userRole: _role
			pageNow: _page
			pageSize: _pageSize
		}
		MessageAction.msgList params

	minxins: [PureRenderMixin]
	render: ->
		msgs = @state.msgList.map (item, index)->
			<Item items={item} index={_role} key={index} />
		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={ @_selectRole.bind this, 2 }>
						<span className={ if _role is 2 then "active" else ''}>司机</span>
					</li>
					<li onClick={ @_selectRole.bind this, 1 }>
						<span className={ if _role is 1 then "active" else ''}>货主</span>
					</li>
					<li onClick={ @_selectRole.bind this, 3 }>
						<span className={ if _role is 3 then "active" else ''}>仓库</span>
					</li>
				</ul>
			</div>	
			<InfiniteScroll pageStart=0 loadMore={@_requestData} hasMore={_hasMore and not _busy}>
			<CSSTransitionGroup transitionName="list">
				{msgs}
			</CSSTransitionGroup>
			</InfiniteScroll>
		</div>
}

React.render <Message />, document.getElementById('content')
