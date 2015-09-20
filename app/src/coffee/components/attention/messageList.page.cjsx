require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

MessageStore = require 'stores/attention/message'
MessageAction = require 'actions/attention/message'

Item = React.createClass {
	render: ->
		items = @props.items.map (item, i) ->
			<div className="m-item02" key={ i }>
				{ item.content }
			</div>
		<div>{ items }</div>
}

Message = React.createClass {

	attDriver: ->
		newState = Object.create @state
		newState.type = '1'
		@setState newState
		MessageAction.msgList('1')

	attGoodsOwner: ->
		newState = Object.create @state
		newState.type = '2'
		@setState newState
		MessageAction.msgList('2')

	attStoreOwner: ->
		newState = Object.create @state
		newState.type = '3'
		@setState newState
		MessageAction.msgList('3')


	getInitialState: ->
		{
			type: '1'
			msgList: MessageStore.getMsgList()
		}

	componentDidMount: ->
		MessageStore.addChangeListener @resultCallBack
		MessageAction.msgList('1')

	componentWillUnMount: ->
		MessageStore.removeChangeListener @resultCallBack

	resultCallBack: ->
		console.log 'callback-------'
		@setState {
			msgList: MessageStore.getMsgList()
		}

	minxins: [PureRenderMixin]
	render: ->
		console.log 'msg------', @state.msgList
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
			<Item items={ @state.msgList }/>
		</div>
}

React.render <Message />, document.getElementById('content')
