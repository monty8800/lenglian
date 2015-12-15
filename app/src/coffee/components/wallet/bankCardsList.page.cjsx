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
Auth = require 'util/auth'

transData = DB.get 'transData2'
DB.remove 'transData2'

DB.remove 'bindCardType'
_toDeleteIndex = -1

_bindType = 1

BankCardsList = React.createClass {
	_addNewBankCard:->
		if user.certification is 2 and _bindType is 1
			return Plugin.toast.err '认证企业不能添加快捷银行卡'
		if user.personalGoodsStatus is 1 or user.personalCarStatus is 1 or user.personalWarehouseStatus is 1 or user.enterpriseGoodsStatus is 1 or user.enterpriseCarStatus is 1 or user.enterpriseWarehouseStatus
			DB.put 'bindCardType', "#{_bindType}"
			Plugin.nav.push ['addBankCard']
		else
			Auth.needAuth 'any','您尚未进行任何角色的认证，请认证后再绑定银行卡'

	_bankItemClick:(index)->
		newState = Object.create @state
		newState.selectIndex = index
		@setState newState
		if transData?.type is 'withdraw'
			WalletAction.selectWithdrawCard @state.bankCardsList[index]
		
	_deleteBankCard:(index)->
		_toDeleteIndex = index
		toDeleteBankCardId = @state.bankCardsList[index].id
		Plugin.alert '确认删除吗?', '提示', (index)->
			if index is 1
				WalletAction.removeBankCard toDeleteBankCardId
				console.log 'deletedeletedelete'
		, ['确定', '取消']



	getInitialState:->
		{
			bankCardsList:[]
			selectIndex:0
			isDeleteStatus:false
		}

	_setBindType: (type)->
		_bindType = type
		@setState {
			bankCardsList: []
		}
		@_getBankCardList()

	_getBankCardList: ->
		WalletAction.getBankCardsList {
			userId: UserStore.getUser()?.id
			status: 1
			bindType: _bindType
		}

	componentDidMount: ->
		WalletStore.addChangeListener @_onChange
		@_getBankCardList()

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		if mark[0] is 'getBankCardsListSucc'
			bindType = mark[2]
			console.log '++++++ get it success', bindType
			newState = Object.create @state
			newState.bankCardsList = WalletStore.getBankCardsList()
			@setState newState
		else if mark is 'select:withdraw:card'
			Plugin.nav.pop()
		else if mark is 'bankCards_status_delete'
			@setState {
				isDeleteStatus:true
			}
		else if mark is 'bankCards_status_normal'
			@setState {
				isDeleteStatus:false
			}
		else if mark is 'bankCard_delete_succ'
			newBankCardList = Object.create @state.bankCardsList
			newBankCardList.splice _toDeleteIndex,1
			@setState {
				bankCardsList:newBankCardList
			}
		else if mark is 'reloadBandCardsListAction'
			@_getBankCardList()
		
			

	render : ->
		bankCardsList = @state.bankCardsList.map (aBankCard,index)->
			if @state.isDeleteStatus
				<div onClick={ @_deleteBankCard.bind this,index } className="g-bankList">
					<p className="g-bank03 ll-font">
						<em className="ll-font"></em>
						<span>{ aBankCard.bankName }</span>
						<span className="font24">{ aBankCard.cardType }(尾号{ aBankCard.cardNo.substr -4,4 })</span>
					</p>
				</div>
			else
				<div onClick={ @_bankItemClick.bind this,index } className="g-bankList">
					<p className={ if @state.selectIndex is index then "g-bank01 ll-font active" else "g-bank01 ll-font" }>
						<span>{ aBankCard.bankName }</span>
						<span className="font24">{ aBankCard.cardType }(尾号{ aBankCard.cardNo.substr -4,4 })</span>
					</p>
				</div>
		,this

		<section>
			<div className="m-tab01">
				<ul>
				<li onClick={@_setBindType.bind this, 1}>
				{
					if _bindType is 1
						<span className="active">快捷银行卡</span>
					else
						'快捷银行卡'
				}
				</li>
				<li onClick={@_setBindType.bind this, 2}>
				{
					if _bindType is 2
						<span className="active">提现银行卡</span>
					else
						'提现银行卡'
					
				}
				</li>
				</ul>
			</div>
			{
				if @state.isDeleteStatus
					<div className="m-bank f-delete">
						{ bankCardsList }
					</div>
				else 
					<div className="m-bank">
						{ bankCardsList }
						<div onClick={ @_addNewBankCard } className="g-bankList">
							<p className="g-bank02">
								<span>{if _bindType is 1 then '添加快捷银行卡' else '添加提现银行卡'}</span>
							</p>
						</div>
					</div>
			}
		</section>
}
React.render <BankCardsList />,document.getElementById('content')

