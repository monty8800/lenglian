# 货主订单Cell
React = require 'react'

DRIVER_LOGO = require 'user-01.jpg'

GoodsCell = React.createClass {

	getInitialState: ->
		{
			isShow: 2
		}

	_show: ->
		if @state.isShow is 1
			@setState {
				isShow: 2
			}
		else 
			@setState {
				isShow: 1
			}

	render: ->
		<div className="m-item01">
			<div className="g-item">
				<div className="g-adr-start ll-font g-adr-start-line">
					黑龙江鹤岗市向阳区
				</div>
				<div className="g-adr-end ll-font g-adr-end-line">
					山西太原市矿区
				</div> 
			</div>
			<div onClick={@_show} className={ if @state.isShow is 1 then "g-item g-pad ll-font u-arrow-right g-pad-active" else "g-item g-pad ll-font u-arrow-right" }>
				价格类型 : 竞价
			</div>
			<div className="g-item-order" style={{ height: if @state.isShow is 1 then 'auto' else '0' }}>
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
}

module.exports = GoodsCell