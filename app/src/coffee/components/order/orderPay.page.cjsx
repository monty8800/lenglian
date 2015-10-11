require 'components/common/common'

React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'
BankCardList = require 'components/order/bankCardList'

OrderPay = React.createClass {
	render : ->
		<section>
		<div className="m-pay-item">
			<p className="g-pay clearfix">
				<span className="fl">支付金额</span>
				<span className="fr g-pay-money"><span>&yen;</span>193847</span>
			</p>
			<p className="g-pay clearfix">
				<span className="fl g-payPass">输入支付密码</span>
				<span className="fr">
					<input className="setPas" type="password" readOnly="readonly" placeholder="去设置支付密码"/>
				</span>	
			</p>
		</div>

		<div className="m-pay-item">
			<p className="g-pay offMoney ll-font">
				<span className="font30">余额支付</span>
				<span className="font24">200元</span>
			</p>
		</div>

		<BankCardList />


		<div className="u-pay-btn">
			<div className="u-pay-btn">
				<a className="btn">立即支付</a>
			</div>
		</div>
		
		<div className="u-green ll-font">
			同意
			<a >《马甲协议》</a>
		</div>	

		</section>
}

React.render <OrderPay />,document.getElementById('content')