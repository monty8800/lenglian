require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

AttAction = require 'actions/attention/attention'
AttStore = require 'stores/attention/attention'

DRIVER_LOGO = require 'user-01.jpg'

Item = React.createClass {
	render: ->
		items = @props.items.map (item, i) ->
			<div>
				<div className="m-focus-item">
					<div className="item-pic"><img src={ DRIVER_LOGO } /></div>
					<div className="item-name">司机: { item?.companyName || item?.userName }</div>
					<div className="item-btn item-btn-color01 ll-font"></div>
				</div>
			</div>
		<div>{ items }</div>
}

Attention = React.createClass {

	attDriver: ->
		newStatus = Object.create @state
		newStatus.status = '1'
		@setState newStatus
		AttAction.attentionList('1')

	attGoodsOwner: ->
		newStatus = Object.create @state
		newStatus.status = '2'
		@setState newStatus
		AttAction.attentionList('2')
   
	attStoreOwner: ->
		newStatus = Object.create @state
		newStatus.status = '3'
		@setState newStatus
		AttAction.attentionList('3')

	getInitialState: ->
		{
			status: '1'
			attList: AttStore.getAttList()
		}

	componentDidMount: ->
		AttStore.addChangeListener @_resultCallBack
		AttAction.attentionList('1')

	componentWillUnmount: ->
		AttStore.removeChangeListener @_resultCallBack

	# 事件回调
	_resultCallBack: ->
		@setState {
			attList: AttStore.getAttList()
		}

	minxins: [PureRenderMixin]
	render: ->
		console.log 'attList -- ', @state.attList
		<div>
			<div className="m-tab01">
				<ul> 
					<li onClick={ @attDriver }><span className={ if @state.status is '1' then "active" else ''}>关注的司机</span></li>
					<li onClick={ @attGoodsOwner }><span className={ if @state.status is '2' then "active" else ''}>关注的货主</span></li>
					<li onClick={ @attStoreOwner }><span className={ if @state.status is '3' then "active" else ''}>关注的仓库</span></li>
				</ul>
			</div>
			<Item items={ @state.attList }/>
		</div>
}

React.render <Attention />, document.getElementById('content')

