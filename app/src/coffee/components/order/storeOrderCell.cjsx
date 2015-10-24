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


	_toWarehouseDetail:(item)->
		console.log item,'++++++____++++++'
		DB.put 'transData',item
		Plugin.nav.push ['warehouseOrderDetail']

	_receiver:(orderState,item,e )->
		if orderState is 1
			Plugin.alert '确认接受吗?', '提示', (index)->
				if index is 1
					OrderAction.warehouseAcceptOrder {
						orderNo:item.orderNo
						warehousePersonUserId:item.warehousePersonUserId
						version:item.version
					},item.orderNo
			, ['确定', '取消']

		else if orderState is 4
			console.log '货库交易结束 库主 评价 货主'
			if not item?.rateFlag
				DB.put 'transData', {
					userRole: '3'
					targetId: item?.goodsPersonUserId
					targetRole: if item?.orderType in ['GW', 'WG'] then 1 
					orderNo: item?.orderNo
				}
				Plugin.nav.push ['doComment']
			else
				e.stopPropagation()
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
								<Raty score={ item?.goodsPersonScore } />
							</div>
						</div>
						<div className="g-dirver-btn">
							{
								switch parseInt(item?.orderState)
									when 1
										if parseInt(item?.warehouseSourceMode) is 1
											<span>等待货主确认</span>
										else if parseInt(item?.warehouseSourceMode) is 2
											<a onClick={@_receiver.bind this,1,item} className="u-btn02">接受</a>
									when 2
										if item?.payType is '3'
											<span>等待货主付款</span>
										else
											<span>货物存储中</span>
									when 3
										<span>货物存储中</span>
									when 4
										if item?.mjRateflag
											<span>已评价</span>
										else
											<a onClick={@_receiver.bind this,4,item} className="u-btn02">评价货主</a>

										
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
					<p>货物描述 : <span>{item?.goodsName}</span><span>{ if item?.goodsWeight then item?.goodsWeight + '吨' else ''}</span><span>{if item?.goodsCubic then item?.goodsCubic + '方' else ''}</span><span>{ item?.goodsType }</span></p>
					<p>支付方式 : <span>{Helper.payTypeMapper item?.payType}</span><span>{ if parseInt(item?.payType) is 3 then item?.advance + '元' else ''}</span></p>
				</div>
			</div>
		, this
		<div>{items}</div>
}

module.exports = StoreCell



# <p>价格类型 : <span>{Helper.priceTypeMapper item?.priceType}</span><span>{item?.price + '元'}</span></p>
