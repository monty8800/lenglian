# 货主订单Cell
React = require 'react'
OrderAction = require 'actions/order/order'
OrderStore = require 'stores/order/order'

DRIVER_LOGO = require 'user-01.jpg'

Helper = require 'util/helper'
Plugin = require 'util/plugin'

GoodsCell = React.createClass {

	getInitialState: ->
		{
			index: 0
			isShow: 2
		}

	componentDidMount: ->
		OrderStore.addChangeListener @resultCallBack

	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		if params[0] is 'bindding_list'
			newState = Object.create @state
			newState.isShow = 1
			newState.index = params
			@setState newState

	_show: (params, priceType, goodsSourceId)->
		if @state.isShow is 2
			if priceType is '2'
				# 竞价列表
				OrderAction.getBiddingList(goodsSourceId)
		else 
			newState = Object.create @state
			newState.isShow = 2
			newState.index = params
			@setState newState

	render: ->
		console.log '------------orderList:', @props.items
		items = @props.items.map (item, i)->
			<div className="m-item01" key={i}>

				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<img src={DRIVER_LOGO}/>
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{item?.userName}</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							{	
								if item?.orderState is 1
									if item?.acceptMode is 1
										<a href="###" onClick={@_receiver} className="u-btn02">接受</a>
										<a href="###" onClick={@_receiver} className="u-btn02">取消</a>
									else if item?.acceptMode is 2
										<span>等待司机同意</span>
									else if item?.acceptMode is 3
										<span>等待仓库同意</span>	
								else if item?.orderState is 2
									<a href="###" onClick={@_receiver} className="u-btn02">确认付款</a>
								else if item?.orderState is 3
									<a href="###" onClick={@_receiver} className="u-btn02">订单完成</a>
								else if item?.orderState is 4
									if item?.acceptMode is 2
										<a href="###" onClick={@_receiver} className="u-btn02">评价司机</a>
									else if item?.acceptMode is 3
										<a href="###" onClick={@_receiver} className="u-btn02">评价仓库</a>
							}			
						</div>
					</div>
				</div>

				<div className="g-item">
					<div className="g-adr-start ll-font g-adr-start-line">
						{item?.toProvinceName}{item?.toCityName}{item?.toCountyName}
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						{item?.fromProvinceName}{item?.fromCityName}{item?.fromCountyName}
					</div> 
				</div>
				<div onClick={@_show.bind this, i, item.priceType, item.goodsSourceId} className={ if item?.priceType is '1' then 'g-item g-pad ll-font' else if @state.index is i and @state.isShow is 1 then "g-item g-pad ll-font u-arrow-right g-pad-active" else "g-item g-pad ll-font u-arrow-right" }>
					价格类型 : {Helper.priceTypeMapper item?.priceType} {item?.price}元
				</div>
				<div className="g-item-order" style={{ height: if item?.priceType is '1' then '0' else if @state.index is i and @state.isShow is 1 then 'auto' else '0' }}>
					<div className="g-order">
						<div className="g-order-pic">
							<img src={ DRIVER_LOGO } />
						</div>
						<div className="g-order-msg">
							<div className="g-order-name">
								<span>柠静</span>
								<span>4000元</span>
							</div>
							<div className="g-order-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-order-btn">
							<a href="#" className="u-btn02">选择该司机</a>
						</div>
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>货物描述 : <span>{item?.goodsDesc}</span></p>
					<p>支付方式 : <span>{Helper.payTypeMapper item?.payType}</span></p>
				</div>
			</div>
		, this
		<div>{items}</div>
}

module.exports = GoodsCell
