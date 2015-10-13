# 车主订单Cell
require 'components/common/common'
React = require 'react'
Plugin = require 'util/plugin'
Helper = require 'util/helper'
OrderAction = require 'actions/order/order'
OrderStore = require 'stores/order/order'
DB = require 'util/storage'
XeImage = require 'components/common/xeImage'
avatar = require 'user-01'

CarItem = React.createClass {

	# 接受
	_receiver: (type, item, i, e)->
		Plugin.alert '确认接受吗?', '提示', (index)->
			if index is 1
				if type is 1 # 接受
					OrderAction.carOwnercomfitOrder(item?.carPersonUserId, item?.orderNo, item.version, i)
				else if type is 2 # 取消
					OrderAction.carOwnerCancelOrder(item?.carPersonUserId, item?.orderNo, item.version, i)
		, ['确定', '取消']
		e.stopPropagation()

	comment: (targetId, orderNo, e)->
		DB.put 'transData', {
			userRole: '2'
			targetId: targetId
			targetRole: '1'
			orderNo: orderNo
		}
		Plugin.nav.push ['doComment']
		e.stopPropagation()
		

	_detail: (item, i)->
		DB.put 'car_owner_order_detail', [item?.carPersonUserId, item?.orderNo, item?.goodsPersonUserId, i]
		Plugin.nav.push ['carOwnerOrderDetail']

	componentDidMount: ->			
		OrderStore.addChangeListener @resultCallBack

	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		if params[0] is 'car_owner_confirm_order_success'
			# 车主确认订单成功
			orderList = @props.items.splice params[1], 1
			newState = Object.create @state
			newState.orderList = orderList
			@setState newState
		else if params[0] is 'car_owner_cancel_order_success'
			#车主取消订单成功
			orderList = @props.items.splice params[1], 1
			newState = Object.create @state
			newState.orderList = orderList
			@setState newState
		else if params[0] is 'car_fresh'
			index = DB.get 'detailCallBackFlag'
			console.log '------hahahha:', index
			if index not ''
				orderList = @props.items.splice index, 1
				newState = Object.create @state
				newState.orderList = orderList
				@setState newState
				DB.put 'detailCallBackFlag', ''

	render: ->
		items = @props.items.map (item, i)->
			<div className="m-item01" key={item?.orderNo} onClick={@_detail.bind this, item, i}>
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<XeImage src={item?.goodsPersonHeadPic} size='130x130' type='avatar' />
						</div>	
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<div>{item?.carPersonName}</div>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							{
								if item?.orderState is '1'
									if item?.orderType is 'CG'
										<span>等待货主确认</span>
									else if item?.orderType is 'GC'
										<a href="###" onClick={@_receiver.bind this, 1, item, i} className="u-btn02">接受</a>
										#<a href="###" onClick={@_receiver.bind this, 2, item, i} className="u-btn02">取消</a>
								else if item?.orderState is '2'
									# 1：货到付款（线下）2：回单付款（线下） 3：预付款（线上）
									if item?.payType is '3'
										<span>等待货主付款</span>				
									else
										<span>货物运输中</span>
								else if item?.orderState is '3'
									<span>货物运输中</span>
								else if item?.orderState is '4'
									<a href="###" onClick={@comment.bind this, item?.goodsPersonUserId, item?.orderNo} className="u-btn02">评价货主</a>
							}
						</div>
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-start ll-font g-adr-start-line">
						{item?.destination}
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						{item?.setOut}
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>价格类型：<span>{Helper.priceTypeMapper item?.priceType}</span><span>{item?.price}元</span></p>
					<p>货物描述 : <span>{item?.goodsDesc}</span></p>
					<p>支付方式 : <span>{Helper.payTypeMapper item?.payType}</span></p>
				</div>
			</div>
		, this
		<div>{items}</div>
}

module.exports = CarItem
