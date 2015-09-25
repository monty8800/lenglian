# 车主订单Cell
require 'components/common/common'
React = require 'react'
Plugin = require 'util/plugin'
Helper = require 'util/helper'

DRIVER_LOGO = require 'user-01.jpg'

CarItem = React.createClass {
	render: ->
		<div className="m-item01">
			<div className="g-item-dirver">
				<div className="g-dirver">					
					<div className="g-dirver-pic">
						<img src={ DRIVER_LOGO } />
					</div>
					<div className="g-dirver-msg">
						<div className="g-dirver-name">
							<span>车主姓名</span>
						</div>
						<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
					</div>
					<div className="g-dirver-btn">
						<a href="#" className="u-btn02">接受</a>
					</div>
				</div>
			</div>
			<div className="g-item">
				<div className="g-adr-start ll-font g-adr-start-line">
					永泰中路旁边
				</div>
				<div className="g-adr-end ll-font g-adr-end-line">
					泰鹏大厦中间
				</div>
			</div>
			<div className="g-item g-item-des">
				<p>价格类型：<span>一口价</span><span>4000元</span></p>
				<p>货物描述 : <span>老腊肉 你的菜</span></p>
				<p>支付方式 : <span>预付款</span><span>2000元</span></p>
			</div>
		</div>
}

module.exports = CarItem

