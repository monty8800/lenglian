# 仓库订单Cell
React = require 'react'
Plugin = require 'util/plugin'
Helper = require 'util/helper'
DRIVER_LOGO = require 'user-01.jpg'
DB = require 'util/storage'
OrderAction = require 'actions/order/order'
OrderStore = require 'stores/order/order'
XeImage = require 'components/common/xeImage'
Raty = require 'components/common/raty'

StoreCell = React.createClass {

	componentDidMount: ->			
		OrderStore.addChangeListener @_onChange

	componentWillNotMount: ->
		OrderStore.removeChangeListener @_onChange

	_onChange: (mark)->
		if mark[0] is 'warehouse:accept:order:done'
			orderList = @props.items.splice mark[1], 1
			newState = Object.create @state
			newState.orderList = orderList
			@setState newState
		


	_toWarehouseDetail:(item)->
		console.log item,'++++++____++++++'
		DB.put 'transData',item
		Plugin.nav.push ['warehouseOrderDetail']

	_receiver:(orderState,item,e )->
		if orderState is 1
			console.log '接受货主的用库请求 调接口生成订单'
			OrderAction.warehouseAcceptOrder {
				orderNo:item.orderNo
				warehousePersonUserId:item.warehousePersonUserId
				version:item.version
			}
		else if orderState is 4
			console.log '货库交易尾声  库主 评价 货主'

		else
			console.log 'XXXXXXXXXXXXXXXXX'
		e.stopPropagation()


	render: ->
		items = @props.items.map (item, i)->	
			<div onClick={@_toWarehouseDetail.bind this, item} className="m-item01 m-item05" key={i}>
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<XeImage src={item?.goodsPersonHeadPic} size='130x130' type='avatar' />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{item?.goodsPersonName}</span>
							</div>		
							<div className="g-dirver-dis ll-font">
								{
									<Raty score={ item?.goodsPersonScore } />
								}
							</div>
						</div>
						<div className="g-dirver-btn">
							{
								switch parseInt(item?.orderState)
									when 1
										if item?.orderType is 'WG'
											<span>等待货主确认</span>
										else if item?.orderType is 'GW'
											<a onClick={@_receiver.bind this,1,item} className="u-btn02">接受</a>
									when 2
										if item?.payType is '3'
											<span>等待货主付款</span>
										else
											<span>货物存储中</span>
									when 3
										<span>货物存储中</span>

									when 4
										<a onClick={@_receiver.bind this,4,item} className="u-btn02">评价货主</a>

								# if item?.orderState is '1'
								# 	if item?.orderType is 'WG'
								# 		<span>等待货主确认</span>
								# 	else if item?.orderType is 'GW'
								# 		<a onClick={@_receiver.bind this,1,item} className="u-btn02">接受</a>
								# else if item?.orderState is '2'
								# 	if item?.payType is '3'
								# 		<span>等待货主付款</span>
								# 	else
								# 		<span>货物存储中</span>
								# 		# <a href="###" onClick={@_receiver} className="u-btn02">完成订单</a>
								# else if item?.orderState is '3'
								# 	#if item?.payType is '3'
								# 	#	<a href="###" onClick={@_receiver.bind this, 3, item} className="u-btn02">完成订单</a>
								# 	#else
								# 	<span>货物存储中</span>
								# else if item?.orderState is '4'
								# 	<a onClick={@_receiver.bind this,4,item} className="u-btn02">评价货主</a>
							}
						</div>
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-store ll-font">
						{item?.warehousePlace}
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

module.exports = StoreCell
