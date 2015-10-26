require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
CSSTransitionGroup = React.addons.CSSTransitionGroup
InfiniteScroll = require('react-infinite-scroll')(React)
MessageStore = require 'stores/attention/message'
MessageAction = require 'actions/attention/message'
Constants = require 'constants/constants'

_currentStatus = '2'

Item = React.createClass {
	render: ->
		<div className="m-item02">
			{ @props.items?.content }
		</div>
}

Message = React.createClass {

	attDriver: ->
		_currentStatus = '1'
		newState = Object.create @state
		newState.type = '1'
		pageNow: 1
		@setState newState
		MessageAction?.msgList('2', 1)

	attGoodsOwner: ->
		_currentStatus = '2'
		newState = Object.create @state
		newState.type = '2'
		pageNow: 1
		@setState newState
		MessageAction?.msgList('1', 1)

	attStoreOwner: ->
		_currentStatus = '3'
		newState = Object.create @state
		newState.type = '3'
		pageNow: 1
		@setState newState
		MessageAction?.msgList('3', 1)


	getInitialState: ->
		{
			type: '1'
			hasMore: true
			pageNow: 1
			dataCount: 0
			msgList: MessageStore?.getMsgList()
		}

	componentDidMount: ->
		MessageStore.addChangeListener @resultCallBack
		# MessageAction?.msgList('2')

	componentWillUnMount: ->
		MessageStore.removeChangeListener @resultCallBack

	resultCallBack: ->
		list = MessageStore?.getMsgList()
		pageNow = @state.pageNow + 1
		@setState {
			hasMore: list.size - @state.dataCount >= Constants.orderStatus.PAGESIZE
			pageNow: pageNow
			dataCount: list.size
			msgList: MessageStore?.getMsgList()
		}

	_loadMore: ->
		MessageAction.msgList(_currentStatus, @state.pageNow)

	minxins: [PureRenderMixin]
	render: ->
		msgs = @state.msgList.map (item, index)->
			<Item items={item} index={index} key={index} />
		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={ @attDriver }>
						<span className={ if @state.type is '1' then "active" else ''}>司机</span>
					</li>
					<li onClick={ @attGoodsOwner }>
						<span className={ if @state.type is '2' then "active" else ''}>货主</span>
					</li>
					<li onClick={ @attStoreOwner }>
						<span className={ if @state.type is '3' then "active" else ''}>仓库</span>
					</li>
				</ul>
			</div>	
			<InfiniteScroll pageStart=0 loadMore={@_loadMore} hasMore={@state.hasMore}>
			<CSSTransitionGroup transitionName="list">
				{msgs}
			</CSSTransitionGroup>
			</InfiniteScroll>
		</div>
}

React.render <Message />, document.getElementById('content')
