# 仓库订单Cell
React = require 'react'

DRIVER_LOGO = require 'user-01.jpg'

StoreCell = React.createClass {
	render: ->
		<div className="m-item01 m-item05">
			<div className="g-item-dirver">
				<div className="g-dirver">					
					<div className="g-dirver-pic">
						<img src={ DRIVER_LOGO } />
					</div>
					<div className="g-dirver-msg">
						<div className="g-dirver-name">
							<span>货主姓名</span>
						</div>
						<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
					</div>
					<div className="g-dirver-btn">
						<a href="#" className="u-btn02">接受</a>
					</div>
				</div>
			</div>
			<div className="g-item">
				<div className="g-adr-store ll-font">
					北京市海淀区泰鹏大厦
					<p>
						<span>2015-8-20</span> 至 <span>2015-10-1</span>
					</p>
				</div>
			</div>
			<div className="g-item g-item-des">
				<p>价格类型：<span>一口价</span><span>4000元</span></p>
				<p>货物描述 : <span>小鲜肉</span><span>1吨</span><span>冷鲜类</span></p>
				<p>支付方式 : <span>预付款</span><span>2000元</span></p>
			</div>
		</div>
}

module.exports = StoreCell