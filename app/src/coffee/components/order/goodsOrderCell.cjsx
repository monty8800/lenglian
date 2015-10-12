# 货主订单Cell
React = require 'react'
OrderAction = require 'actions/order/order'
OrderStore = require 'stores/order/order'

DRIVER_LOGO = require 'user-01.jpg'

Helper = require 'util/helper'
Plugin = require 'util/plugin'

OrderDriverCell = require 'components/order/orderDriverCell'
OrderBidDriverList = require 'components/order/orderBidDriverList'

DB = require 'util/storage'

GoodsCell = React.createClass {

	getInitialState: ->
		{
			showBidList: false
			selectBid: null
		}

	_showBid: ->
		console.log 'show bid'
		if not @state.selectBid and @props.order?.priceType isnt '1'
			@setState {
				showBidList: not @state.showBidList
			}

	_goDetail: ->
		DB.put 'transData', {
			orderNo: @props.order?.orderNo
		}
		Plugin.nav.push ['goodsOrderDetail']

	render: ->
		console.log 'order----', @props.order, @state

		cls = 'g-item g-pad ll-font'
		if not @state.showBidList and not @state.selectBid and @props.order?.priceType isnt '1'
			cls += ' u-arrow-right'
		else if @state.showBidList and @props.order?.priceType isnt '1'
			cls += ' u-arrow-right g-pad-active'

		<div className="m-item01">
			{
				if parseInt(@props.order.priceType) is 1
					<OrderDriverCell order={@props.order} />
			}
			<div onClick={@_goDetail} className="g-item">
				<div className="g-adr-start ll-font g-adr-start-line">
					{@props.order.fromProvinceName + @props.order.fromCityName + @props.order.fromCountyName}
				</div>
				<div className="g-adr-end ll-font g-adr-end-line">
					{@props.order.toProvinceName + @props.order.toCityName + @props.order.toCountyName}
				</div>
			</div>

			<div onClick={@_showBid} className={cls}>
				{'价格类型 : ' + if @props.order.priceType is '1' then '一口价'  else '竞价'}
				<span>{@state.selectBid}</span>
			</div>

			<OrderBidDriverList order={@props.order} show={@state.showBidList} />

			<div onClick={@_goDetail} className="g-item g-item-des">
				<p>货物描述 : <span>{@props.order.goodsDesc}</span><span>{@props.order.goodsWeight + '吨'}</span></p>
				<p>支付方式 : <span>{Helper.payTypeMapper @props.order.payType}</span><span>{@props.order.price + '元'}</span></p>
			</div>
		</div>
}

module.exports = GoodsCell