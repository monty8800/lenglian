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

_status = 1

BillList = React.createClass {

	_selectOut:->
		_status = 2
		newState = Object.create @state
		newState.resultList = []
		newState.selectIndex = 2
		@setState newState
		WalletAction.getBillList 2

	_selectIn:->
		_status = 1
		newState = Object.create @state
		newState.resultList = []
		newState.selectIndex = 1
		@setState newState
		WalletAction.getBillList 1


	getInitialState:->
		{
			resultList:[]
			selectIndex:2
		}

	componentDidMount: ->
		WalletStore.addChangeListener @_onChange
		WalletAction.getBillList @state.selectIndex

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		if mark is 'getBillListSucc'
			newState = Object.create @state
			newState.resultList = WalletStore.getBillList()
			@setState newState

	render: ->
		billItems = @state.resultList.map (bill,index)->
			<div className="m-billItem">
				<dl className="clearfix">
					<dd className="fl">
						<p className="clearfix">
							<span>{ bill.userMobile }</span>
							<span className={ if parseInt(bill.type) is 1 or parseInt(bill.type) is 4 then "plus" else "" } >{bill.amount.toFixed(2) + '元'}</span>
						</p>
						<p className="clearfix">
							<span>{ bill.createTime }</span>
							<span>交易结束</span>
						</p>
					</dd>
				</dl>
			</div>
		,this

		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={ @_selectOut }><span className={ if @state.selectIndex is 2 then "active" else ''}>支出</span></li>
					<li onClick={ @_selectIn }><span className={ if @state.selectIndex is 1 then "active" else ''}>收入</span></li>
				</ul>
			</div>
			{ billItems }
		</div>
}


React.render <BillList  />, document.getElementById('content')

