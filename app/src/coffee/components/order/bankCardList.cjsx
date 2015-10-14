# 货主订单Cell
React = require 'react'

BankCardList = React.createClass {
	render: ->
		cardList = @props.bankCardList?.map (card, i)->
			<div className="g-bankList">
				<p className="g-bank01 ll-font">
					<span>{card.get 'blankName'}</span>
					<span className="font24">{'信用卡' + '(尾号' + card.get('cardNo') + ')'}</span>
				</p>
			</div>

		<div className="m-bank">			
			<h6 className="g-bankTitle">
				请选择银行卡
			</h6>
			<div className="g-bankList">
				<p className="g-bank01 ll-font active">
					<span>工商银行</span>
					<span className="font24">信用卡(尾号2345)</span>
				</p>
			</div>

			{cardList}
			<div className="g-bankList">
				<p className="g-bank02">
					<span>添加银行卡</span>
				</p>
			</div>
		</div>
}

module.exports = BankCardList
