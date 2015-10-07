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

BankCardsItem = React.createClass {
	render: ->
		items = @props.bankCardsList.map (aBankCard,i) ->
			<div className="g-bankList">
				<p className="g-bank01 ll-font active noborder">
					<span>{ aBankCard.bankName }</span>
					<span className="font24">信用卡(尾号2345)</span>
				</p>
			</div>
		,this
		<div>
			{items}
		</div>
}


BankCardsList = React.createClass {
	_addNewBankCard:->
		Plugin.nav.push ['addBankCard']

	getInitialState:->
		{
			bankCardsList:[]
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

		<div className="m-bank">
			<BankCardsItem bankCardsList={@state.bankCardsList} />
			<div onClick={ @_addNewBankCard } className="g-bankList">
				<p className="g-bank02">
					<span>添加银行卡</span>
				</p>
			</div>
		</div>
}
React.render <BankCardsList />,document.getElementById('content')

