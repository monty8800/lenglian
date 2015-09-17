# 货主订单列表
require 'components/common/common'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

DRIVER_LOGO = require 'user-01.jpg'

OrderList = React.createClass {
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
			<div className="m-item01">
				<div className="g-item">
					<div className="g-adr-start ll-font g-adr-start-line">
						黑龙江鹤岗市向阳区
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						山西太原市矿区
					</div>
				</div>
				<div className="g-item g-pad ll-font u-arrow-right">
					价格类型 : 竞价
				</div>
				<div className="g-item-order">
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
					<p>货物描述 : <span>小鲜肉</span><span>1吨</span><span>冷鲜类</span></p>
					<p>支付方式 : <span>预支付</span><span>2000元</span></p>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-item">
					<div className="g-adr-start ll-font g-adr-start-line">
						黑龙江鹤岗市向阳区
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						山西太原市矿区
					</div>
				</div>
				<div className="g-item g-pad ll-font">
					价格类型 : 竞价
					<span>( 柠静  4999元 )</span>
				</div>
				<div className="g-item g-item-des">
					<p>货物描述 : <span>小鲜肉</span><span>1吨</span><span>冷鲜类</span></p>
					<p>支付方式 : <span>预支付</span><span>2000元</span></p>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<img src={ DRIVER_LOGO } />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>司机名</span>
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
						黑龙江鹤岗市向阳区
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						山西太原市矿区
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>价格类型：<span>一口价</span><span>4000元</span></p>
					<p>货物描述 : <span>小鲜肉</span><span>1吨</span><span>冷鲜类</span></p>
					<p>支付方式 : <span>预支付</span><span>2000元</span></p>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<img src={ DRIVER_LOGO } />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>司机名</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<span>等待司机同意</span>
						</div>
					</div>
				</div>
				<div className="g-item">
					
					<div className="g-adr-start ll-font g-adr-start-line">
						黑龙江鹤岗市向阳区
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						山西太原市矿区
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>价格类型：<span>一口价</span><span>4000元</span></p>
					<p>货物描述 : <span>小鲜肉</span><span>1吨</span><span>冷鲜类</span></p>
					<p>支付方式 : <span>预支付</span><span>2000元</span></p>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<img src={ DRIVER_LOGO } />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>司机名</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<a href="#" className="u-btn02">接受</a>
						</div>
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-start ll-font">
						黑龙江鹤岗市向阳区
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>价格类型：<span>一口价</span><span>4000元</span></p>
					<p>货物描述 : <span>小鲜肉</span><span>1吨</span><span>冷鲜类</span></p>
					<p>支付方式 : <span>预支付</span><span>2000元</span></p>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<img src={ DRIVER_LOGO } />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>司机名</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<a href="#" className="u-btn02">接受</a>
						</div>
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-start ll-font">
						黑龙江鹤岗市向阳区
					</div>
				</div>
				<div className="g-item g-item-des">
					<p>价格类型：<span>一口价</span><span>4000元</span></p>
					<p>货物描述 : <span>小鲜肉</span><span>1吨</span><span>冷鲜类</span></p>
					<p>支付方式 : <span>预支付</span><span>2000元</span></p>
				</div>
			</div>
		</div>
}

React.render <OrderList />, document.getElementById('content')