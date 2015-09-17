# 货主订单详情页
require 'components/common/common'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

DRIVER_LOGO = require 'user-01.jpg'

PRODUCT_PIC = require 'product-01.jpg'

OrderDetail = React.createClass {
	render: ->
		<div>
			<div className="m-orderdetail clearfix">
				<p className="fl">订单号：<span>25112138</span></p>
				<p className="fr">等待货主确认</p>
			</div>
			<div className="m-item01">
				<div className="g-detail-dirver">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<img src={ DRIVER_LOGO } />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>司机名</span><span className="g-dirname-single">(个体)</span>
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
					<div className="g-adr-start ll-font g-adr-start-line">
						黑龙江鹤岗市向阳区
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						山西太原市矿区
					</div>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-detail-time01">
					<span className="fl">装货时间:</span>
					<span className="fr">
						2015-9-1 到 2015-9-3
					</span>
				</div>
				<div className="g-detail-time01">
					<span className="fl">到货时间:</span>
					<span className="fr">
						2015-9-1 到 2015-9-3
					</span>
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
				<p className="noborder">
					<span>发布时间:</span>
					<span>2015-01-01</span>
				</p>			
			</div>
			<div className="m-detail-bottom">
				<div className="g-cancle-btn">
					<a href="#" className="u-btn02 u-btn-cancel">取消订单</a>
				</div>
				<div className="g-pay-btn">
					<a href="#" className="u-btn02">评价司机</a>
				</div>
			</div>
		</div>
}

React.render <OrderDetail />, document.getElementById('content')