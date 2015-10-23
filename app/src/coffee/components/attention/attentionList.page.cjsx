require 'components/common/common'
require 'index-style'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
InfiniteScroll = require('react-infinite-scroll')(React)
AttAction = require 'actions/attention/attention'
AttStore = require 'stores/attention/attention'
XeImage = require 'components/common/xeImage'
Constants = require 'constants/constants'
avatar = require 'user-01'

_currentStatus = '2'

Item = React.createClass {
	render: ->
		<div>
			<div className="m-focus-item">
				<div className="item-pic">
					<XeImage src={@props.items?.imgurl} size='130x130' type='avatar' />
				</div>
				<div className="item-name">{@props.role + ': ' + @props.items?.userName}</div>
				<div className={if @props.items?.wishlist is '1' then "item-btn item-btn-color03 ll-font" else if @props.items?.wishlist is '2' then 'item-btn item-btn-color01 ll-font'}></div>
			</div>
		</div>
}

Attention = React.createClass {

	attDriver: ->
		_currentStatus = '1'
		newStatus = Object.create @state
		newStatus.status = '1'
		@setState newStatus
		AttAction.attentionList('2', 1)

	attGoodsOwner: ->
		_currentStatus = '2'
		newStatus = Object.create @state
		newStatus.status = '2'
		@setState newStatus
		AttAction.attentionList('1', 1)
   
	attStoreOwner: ->
		_currentStatus = '3'
		newStatus = Object.create @state
		newStatus.status = '3'
		@setState newStatus
		AttAction.attentionList('3', 1)

	getInitialState: ->
		{
			status: '1'
			hasMore: true
			pageNow: 1
			dataCount: 0
			attList: AttStore.getAttList()
		}

	componentDidMount: ->
		AttStore.addChangeListener @_resultCallBack
		# AttAction.attentionList('1')

	componentWillUnmount: ->
		AttStore.removeChangeListener @_resultCallBack

	# 事件回调
	_resultCallBack: ->
		list = AttStore.getAttList()
		pageNow = @state.pageNow + 1
		@setState {
			hasMore: list.size - @state.dataCount >= Constants.orderStatus.PAGESIZE
			pageNow: pageNow
			dataCount: list.size
			attList: AttStore.getAttList()
		}

	_loadMore: ->
		AttAction.attentionList(_currentStatus, @state.pageNow)

	minxins: [PureRenderMixin]
	render: ->
		role = ''
		switch @state.status
			when '1' then role = '司机'
			when '2' then role = '货主'
			when '3' then role = '仓库'
		atts = @state.attList.map (item, index)->
			<Item items={item} role={role} index={index} key={index} />
		<div>
			<div className="m-tab01">
				<ul> 
					<li onClick={ @attDriver }><span className={ if @state.status is '1' then "active" else ''}>关注的司机</span></li>
					<li onClick={ @attGoodsOwner }><span className={ if @state.status is '2' then "active" else ''}>关注的货主</span></li>
					<li onClick={ @attStoreOwner }><span className={ if @state.status is '3' then "active" else ''}>关注的仓库</span></li>
				</ul>
			</div>
			<InfiniteScroll pageStart=0 loadMore={@_loadMore} hasMore={@state.hasMore}>
				{atts}
			</InfiniteScroll>
		</div>
}

React.render <Attention />, document.getElementById('content')

