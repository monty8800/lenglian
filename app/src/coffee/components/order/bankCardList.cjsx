# 货主订单Cell
React = require 'react'

PayAction = require 'actions/order/pay'
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'
Auth = require 'util/auth'

BankCardList = React.createClass {
	_select: (card)->
		PayAction.selectCard card

	_addNewCard: ->
		user = UserStore.getUser()
		if user.carStatus is 1 or user.goodsStatus is 1 or user.warehouseStatus is 1
			Plugin.nav.push ['addBankCard']
		else
			Auth.needAuth 'any','您尚未进行任何角色的认证，请认证后再绑定银行卡'
	render: ->
		cardList = @props.bankCardList?.map (card, i)->
			<div className="g-bankList" onClick={@_select.bind this, card}>
				<p className={"g-bank01 ll-font" + if @props.selected is card.id then ' active' else ''}>
					<span>{card.blankName}</span>
					<span className="font24">{'信用卡' + '(尾号' + card.cardNo + ')'}</span>
				</p>
			</div>
		, this

		<div className="m-bank">			
			<h6 className="g-bankTitle">
				请选择银行卡
			</h6>
			{cardList}
			<div onClick={@_addNewCard} className="g-bankList">
				<p className="g-bank02">
					<span>添加银行卡</span>
				</p>
			</div>
		</div>
}

module.exports = BankCardList
