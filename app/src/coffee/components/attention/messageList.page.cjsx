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

Immutable = require 'immutable'

InfiniteScroll = require('react-infinite-scroll')(React)

_role = 2
_page = 1
_pageSize = 20
_hasMore = true
_busy = false
_count = 0

Item = React.createClass {
	render: ->
		<div className="m-item02">
			{ @props.items?.content }
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
			<Item items={item} index={index} key={index} />
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
