# 车主订单Cell
require 'components/common/common'
React = require 'react'
Plugin = require 'util/plugin'
Helper = require 'util/helper'

DRIVER_LOGO = require 'user-01.jpg'

CarItem = React.createClass {

	# 接受
	_receiver: ->
		Plugin.toast.show '接受'

	render: ->
		items = @props.items.map (item, i)->
			<div className="m-item01" key={i}>
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<img src={ DRIVER_LOGO } />
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
										<a href="###" onClick={@_receiver} className="u-btn02">接受</a>
										<a href="###" onClick={@_receiver} className="u-btn02">取消</a>
								else if item?.orderState is '2'
									# 1：货到付款（线下）2：回单付款（线下） 3：预付款（线上）
									if item?.payType is '3'
										<span>等待货主付款</span>
									else
										<a href="###"onClick={@_receiver} className="u-btn02">完成订单</a>
								else if item?.orderState is '3'
									<span>货物运输中</span>
								else if item?.orderState is '4'
									<a href="###"onClick={@_receiver} className="u-btn02">评价货主</a>
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

