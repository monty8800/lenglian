# 仓库订单列表
require 'components/common/common'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

DRIVER_LOGO = require 'user-01.jpg'

StoreOrderList = React.createClass {
	render: ->
		<div>
			<div className="m-tab01">
				<ul>
					<li><span className="active">洽谈中</span></li>
					<li>待付款</li>
					<li>已付款</li>
					<li>待评价</li>
				</ul>
			</div>
		
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
							<span>等待货主确认</span>
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
		</div>
}

React.render <StoreOrderList />, document.getElementById('content')

