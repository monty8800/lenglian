React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

Plugin = require 'util/plugin'

UserStore = require 'stores/user/user'


OrderStore = require 'stores/order/order'
OrderAction = require 'actions/order/order'

Helper = require 'util/helper'

avatar = require 'user-01'

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
				<div><img src={avatar} /></div>
				<p><span>{Helper.hideName bid.userName}</span><span>{'出价:' + bid.price + '元'}</span></p>
				<p>{bid.createTime}</p>
			</li>

		<div className="m-pri-more" style={{display: if @props.show then 'block' else 'none'}}>
			<ul>
				<li>
					<div><img src={avatar} /></div>
					<p><span>我是死数据</span><span>出价:4000元</span></p>
					<p>2015-10-01  10:02:00</p>
				</li>
				{bidCells}
			</ul>
		</div>
}


module.exports = BidList


