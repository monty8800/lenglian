# 仓库订单详情
require 'components/common/common'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

DRIVER_LOGO = require 'user-01.jpg'
PRODUCT_PIC = require 'car-02.jpg'

StoreDetail = React.createClass {
	render: ->
		<div>
			<div className="m-orderdetail clearfix">
				<p className="fl">订单号：<span>25112138</span></p>
				<p className="fr"></p>
			</div>
			<div className="m-item01">
				<div className="g-detail-dirver">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<img src={ DRIVER_LOGO } />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>货主姓名</span><span className="g-dirname-single">(个体)</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<ul className="g-driver-contact">
							<li className="ll-font active">关注</li>
							<li className="ll-font">拨号</li>
						</ul>
					</div>
				</div>
				<div className="g-item g-adr-detail ll-font nopadding">			
					<div className="g-adr-store ll-font">
						北京市海淀区泰鹏大厦
						<p>
							<span>2015-8-20</span> 至 <span>2015-10-1</span>
						</p>
					</div>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-pro-p">
					<p className="g-pro-name">货物名称: <span>冷鲜肉</span></p>
				</div>
				<div className="g-pro-detail">
					<div className="g-pro-pic fl">
						<img src={ PRODUCT_PIC }/>
					</div>
					<div className="g-pro-text fl">
						<p>货物种类: <span>冷鲜肉</span></p>
						<p>货物要求: <span>冷藏</span></p>
						<p>货物重量: <span>20吨</span></p>
						<p>包装类型: <span>硬纸壳</span></p>
					</div>
				</div>
			</div>
			<div className="m-detail-info">
				<p>
					<span>发货人:</span>
					<span className="ll-font g-info-name">李鑫萍</span>
				</p>
				<p>
					<span>收货人:</span>
					<span className="ll-font g-info-name">周昌旭</span>
				</p>
				<p>
					<span>价格类型:</span>
					<span>竞价 4000元</span>
				</p>
				<p>
					<span>支付方式:</span>
					<span>货到付款</span>
				</p>
				<p>
					<span>发票:</span>
					<span>需要发票</span>
				</p>
				<p>
					<span>发布时间:</span>
					<span>2015-01-01</span>
				</p>			
			</div>
			<div className="m-detail-bottom">
				<div className="g-pay-btn">
					<a href="#" className="u-btn02">评价货主</a>
				</div>
			</div>	
		</div>

}

React.render <StoreDetail />, document.getElementById('content')