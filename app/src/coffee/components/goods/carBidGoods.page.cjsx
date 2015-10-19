require 'components/common/common'
require 'index-style'

React = require 'react/addons'


PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'


Helper = require 'util/helper'

UserStore = require 'stores/user/user'

FromTo = require 'components/common/fromTo'
InfoList = require 'components/common/InfoList'

OrderStore = require 'stores/order/order'

OrderAction = require 'actions/order/order'

BidList = require 'components/goods/bidList'

DB = require 'util/storage'

transData = DB.get 'transData'


CarBidGoods = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	componentDidMount: ->
		console.log 'componentDidMount++++++'
		OrderStore.addChangeListener @_change
		getBidGoods = (carId, goodsId)->
			transData = {
				carId: carId
				goodsId: goodsId
			}
			@setState {
				carId: carId
				goodsId: goodsId
			}
			@_getGoodsDetail()
		window.getBidGoods = getBidGoods.bind this
		@_getGoodsDetail() if transData?.goodsId

	_getGoodsDetail: ->
		console.log 'get bid goods detail--'
		OrderAction.getBidGoodsDetail {
			userId: UserStore.getUser()?.id
			goodsResourceId: transData?.goodsId
		}

	componentWillUnmount: ->
		OrderStore.removeChangeListener @_change

	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'bid:goods:detail:done'
			@setState {
				goods: OrderStore.getBidGoods()
			}
		

	_showBidList: ->
		newState = Object.create @state
		newState.showBidList = not @state.showBidList
		@setState newState

	_bid: ->
		console.log 'bid'
		if not Validator.price @state.price
			Plugin.toast.err '请输入正确的金额，最多两位小数'
		else
			carId = @state.carId
			goodsId = @state.goodsId
			price = @state.price
			Plugin.alert '确认提交竞价?一辆车仅有3次竞价机会', '提醒', (index)->
				console.log 'click index', index
				if index is 1
					OrderAction.carBidGoods {
						userId: UserStore.getUser()?.id
						carResourceId: carId
						goodsResourceId: goodsId
						price: price
					}
			, ['竞价', '取消']



	getInitialState: ->
		{
			showBidList: false
			carId: transData?.carId
			goodsId: transData?.goodsId
			price: null
			goods: OrderStore.getBidGoods()
		}

	render: ->
		console.log 'state', @state
		cls = 'll-font u-arrow-right'
		cls += ' active' if @state.showBidList
		from = @state.goods.fromProvinceName + @state.goods.fromCityName + @state.goods.fromAreaName
		to = @state.goods.toProvinceName + @state.goods.toCityName + @state.goods.toAreaName

		<section>
		<div className="m-item01 m-item03">
			<FromTo from={from} to={to} />
			<InfoList goods={@state.goods} />
		</div>

		<div className="m-nav03">
			<ul>
				<li>
					<div className="g-div01">
						<em>出价 :</em>
						<input valueLink={@linkState 'price'} type="number" placeholder="请输入金额" />
					</div>
				</li>
			</ul>
		</div>

		<div onClick={@_bid} className="m-btn-con">
			<a className="u-btn">确认</a>
		</div>

		<div className="b-btn-more">
			<span onClick={@_showBidList} className={cls}>查看全部出价</span>
		</div>

		{
			if @state.goodsId
				<BidList show={@state.showBidList} goodsId={@state.goodsId} />
		}
		</section>
}


React.render <CarBidGoods  />, document.getElementById('content')


