require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'
user = UserStore.getUser()


BankCardsList = React.createClass {
	_addNewBankCard:->
		Plugin.nav.push ['addBankCard']

	render : ->
		<div className="m-bank">
			<div className="g-bankList">
				<p className="g-bank01 ll-font active noborder">
					<span>工商银行</span>
					<span className="font24">信用卡(尾号2345)</span>
				</p>
			</div>
			<div className="g-bankList">
				<p className="g-bank01 ll-font">
					<span>建设银行</span>
					<span className="font24">信用卡(尾号2345)</span>
				</p>
			</div>
			<div onClick={ @_addNewBankCard } className="g-bankList">
				<p className="g-bank02">
					<span>添加银行卡</span>
				</p>
			</div>
		</div>
}
React.render <BankCardsList />,document.getElementById('content')

