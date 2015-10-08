require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

UserStore = require 'stores/user/user'
WalletStore = require 'stores/wallet/wallet'
WalletModel = require 'model/wallet'
WalletAction = require 'actions/wallet/wallet'

DB = require 'util/storage'
Plugin = require 'util/plugin'

user = UserStore.getUser()

Charge = React.createClass {

	_sureToCharge:->

	_addNewBankCard:->
		Plugin.nav.push ['addBankCard']

	getInitialState:->
		{
			bankCardsList:[]
			selectIndex:0
		}

	componentDidMount: ->
		WalletStore.addChangeListener @_onChange
		WalletAction.getBankCardsList()

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		if mark is 'getBankCardsListSucc'
			console.log '++++++ get it success'
			newState = Object.create @state
			newState.bankCardsList = WalletStore.getBankCardsList()
			@setState newState


	render : ->
		bankCardsList = @state.bankCardsList.map (aBankCard,index)->
			<div className="g-bankList">
				<p className={ if @state.selectIndex is index then "g-bank01 ll-font active" else "g-bank01 ll-font" }>
					<span>{ aBankCard.bankName }</span>
					<span className="font24">{ aBankCard.cardType }(尾号{ aBankCard.cardNo.substr -4,4 })</span>
				</p>
			</div>
		,this

		<div>
			<div className="m-pay-item">
				<p className="g-pay clearfix">
					<span className="fl">充值金额</span>
					<span className="fr g-pay-money"><span>&yen;</span>193847</span>
				</p>
				<p className="g-pay clearfix">
					<span className="fl">输入支付密码</span>
					<span className="fr">
						<input className="setPas" type="password" placeholder=""/>
					</span>				
				</p>
			</div>
			<div className="m-pay-item">
				<p className="g-pay">
					<span className="font30">当前余额</span>
					<span className="font24">200元</span>
				</p>
			</div>
			<div className="m-bank">			
				<h6 className="g-bankTitle">
					请选择银行卡
				</h6>
				{ bankCardsList }
				<div onClick={ @_addNewBankCard } className="g-bankList">
					<p className="g-bank02">
						<span>添加银行卡</span>
					</p>
				</div>
			</div>
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a onClick={ @_sureToCharge } href="#" className="btn">立即充值</a>
				</div>
			</div>
			<div className="u-green ll-font">
				同意
				<a href="#">《马甲协议》</a>
			</div>
		</div>
}


React.render <Charge />,document.getElementById('content')

