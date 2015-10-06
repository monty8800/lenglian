require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'
user = UserStore.getUser()

BillIn = React.createClass {
	render: ->
		<div>
			<div className="m-tab01">
				<ul>
					<li>支出</li>
					<li><span className="active">收入</span></li>
				</ul>
			</div>
			<div className="m-billItem">
				<dl className="clearfix">
					<dt className="fl">
						<img src="../images/billPic.jpg"/>
					</dt>
					<dd className="fl">
						<p className="clearfix">
							<span>给XX司机付款</span>
							<span className="plus">-10000.00</span>
						</p>
						<p className="clearfix">
							<span>2015-8-5</span>
							<span>交易结束</span>
						</p>
					</dd>
				</dl>
			</div>
			<div className="m-billItem">
				<dl className="clearfix">
					<dt className="fl">
						<img src="../images/billPic.jpg"/>
					</dt>
					<dd className="fl">
						<p className="clearfix">
							<span>给XX司机付款</span>
							<span className="plus">-100.00</span>
						</p>
						<p className="clearfix">
							<span>2015-8-5</span>
							<span>交易结束</span>
						</p>
					</dd>
				</dl>
			</div>
		</div>
}


Wallet = React.createClass {
	_goPage: (page, transData)->
		DB.put 'transData', transData or {}
		Plugin.nav.push [page]

	_showBillCurrentMonth: ->
		Plugin.nav.push ['billList']

	render: ->
		<section>
		<div className="m-moneyItem">
			<div className="g-account">
				<p>账户余额</p>
				<p>&yen;<span>{user.balance.toFixed 2}</span></p>
			</div>	
		</div>
		<div className="u-pay-btn">
			<div className="u-pay-btn">
				<a href="#" className="btn">充值</a>
				<p className="clearfix">
					<span className="fl" onClick={@_goPage.bind this, 'changePasswd', {type: 'payPwd'}}>修改支付密码</span>
					<span className="fr" onClick={ @_showBillCurrentMonth }>查看本月账单</span>
				</p>
			</div>
		</div>
		</section>
}

React.render <Wallet  />, document.getElementById('content')