React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

Plugin = require 'util/plugin'

UserStore = require 'stores/user/user'


OrderStore = require 'stores/order/order'
OrderAction = require 'actions/order/order'

Helper = require 'util/helper'

Image = require 'util/image'

BidList = React.createClass {
	mixins: [PureRenderMixin]
	componentDidMount: ->
		OrderStore.addChangeListener @_change
		@_getBidList()

	_getBidList: ->
		OrderAction.getBidList {
			userId: UserStore.getUser()?.id
			goodsResourceId: @props.goodsId
		}

	componentWillUnmount: ->
		OrderStore.removeChangeListener @_change

	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'get:bid:list:done'
			@setState {
				bidList: OrderStore.getBidList()
			}
		else if msg is 'car:bid:goods:done'
			Plugin.toast.success '竞价成功！'
			@_getBidList()

	getInitialState: ->
		{
			bidList: OrderStore.getBidList()
		}

	render: ->
		console.log 'state---', @state

		bidCells = @state.bidList.map (bid, i)->
			<li>
				<div><img src={Image.avatar} /></div>
				<p><span>{Helper.hideName bid.userName}</span><span>{'出价:' + bid.price + '元'}</span></p>
				<p>{bid.createTime}</p>
			</li>

		<div className="m-pri-more" style={{display: if @props.show then 'block' else 'none'}}>
			<ul>
				{bidCells}
			</ul>
		</div>
}


module.exports = BidList


