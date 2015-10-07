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

BankCardsList = React.createClass {
	_addNewBankCard:->
		Plugin.nav.push ['addBankCard']

	# _bankItemClick:(index)->
	# 	newState = Object.create @state
	# 	newState.selectIndex = index
	# 	@setState newState
	# 	Plugin.toast.show index

	getInitialState:->
		{
			bankCardsList:[]
			selectIndex:-1
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
		bankCardList = @state.bankCardsList.map (aBankCard,index)->
			<div className="g-bankList">
				<p className={ if index is 0 then "g-bank01 ll-font active noborder" else "g-bank01 ll-font" }>
					<span>{ aBankCard.bankName }</span>
					<span className="font24">{ aBankCard.cardType }(尾号{ aBankCard.cardNo.substr -4,4 })</span>
				</p>
			</div>
		,this

		<div className="m-bank">
			{ bankCardList }
			<div onClick={ @_addNewBankCard } className="g-bankList">
				<p className="g-bank02">
					<span>添加银行卡</span>
				</p>
			</div>
		</div>
}
React.render <BankCardsList />,document.getElementById('content')

