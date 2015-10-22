require 'components/common/common'
require 'user-center-style'


React = require 'react/addons'

#TODO: 没有获取余额
UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'
UserAction = require 'actions/user/user'

Wallet = React.createClass {
	_goPage: (page, transData)->
		DB.put 'transData', transData or {}
		Plugin.nav.push [page]
		
	_toCharge:-> 
		Plugin.nav.push ['toCharge']

	_withdraw: ->
		Plugin.nav.push ['withdraw']

	_showBillCurrentMonth: ->
		Plugin.nav.push ['billList']

	componentDidMount: ->
		UserStore.addChangeListener @_onChange
		UserAction.info()

	componentWillUnmount: ->
		UserStore.removeChangeListener @_onChange

	_onChange: (msg)->
		console.log 'user center msg', msg
		@setState {
			user: UserStore.getUser()
		}

	getInitialState: ->
		{
			user: UserStore.getUser()
		}

	render: ->
		<section>
		<div className="m-moneyItem">
			<div className="g-account">
				<p>账户余额</p>
				<p>&yen;<span>{@state.user.balance.toFixed 2}</span></p>
			</div>	
		</div>
		<div className="u-pay-btn">
			<div className="u-pay-btn">
				<a onClick={ @_toCharge } className="btn btnItem">充值</a>
				<a onClick={ @_withdraw } className="btn btnItem">提现</a>
				<p className="clearfix">
					<span className="fl" onClick={@_goPage.bind this, 'changePasswd', {type: 'payPwd'}}>修改支付密码</span>
					<span className="fr" onClick={ @_showBillCurrentMonth }>查看本月账单</span>
				</p>
			</div>
		</div>
		</section>
}

React.render <Wallet  />, document.getElementById('content')