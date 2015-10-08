require 'components/common/common'
require 'user-center-style'


React = require 'react/addons'

#TODO: 没有获取余额
UserStore = require 'stores/user/user'
DB = require 'util/storage'
Plugin = require 'util/plugin'

bankPic = require 'pay-bank-01'

Withdraw = React.createClass {
	_selectBankCard: ->
		Plugin.nav.push ['bankCardsList']

	_confirm: ->
		Plugin.nav.push ['withdrawDetail']
	render: ->
		<section>
		<div onClick={@_selectBankCard} className="m-cashItem">
			<div className="g-cash u-arrow-right ll-font">
				<dl className="clearfix">
					<dt className="fl">
						<img src={bankPic} />
					</dt>
					<dd className="fl">
						<p>
							<span>中国银行</span> <span>储蓄卡（4159）</span>
						</p>
						<p>当天24点前到账</p>
					</dd>
				</dl>
			</div>
		</div>
		<div className="m-releaseitem">
			<div>
				<label htmlFor="packType"><span>金额 (元)</span></label>
				<input type="text" placeholder={'当前零钱余额' + UserStore.getUser()?.balance} id="packType"/>
			</div>
		</div>
		
		
		<div onClick={@_confirm} className="u-pay-btn">
			<div className="u-pay-btn">
				<a className="btn">下一步</a>
			</div>
		</div>
		</section>
}

React.render <Withdraw  />, document.getElementById('content')