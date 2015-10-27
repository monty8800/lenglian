require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
UserStore = require 'stores/user/user'
WalletStore = require 'stores/wallet/wallet'
WalletModel = require 'model/wallet'
WalletAction = require 'actions/wallet/wallet'
Helper = require 'util/helper'
DB = require 'util/storage'
Plugin = require 'util/plugin'
user = UserStore.getUser()

_status = 1

Record = React.createClass {

	getInitialState: ->
		{				
			type: 1
			recordList: WalletStore.getRecordList()
		}

	componentDidMount: ->
		WalletAction.chargeRecord()
		WalletStore.addChangeListener @resultCallBack

	componentWillNotMount: ->
		WalletStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		if params[0] is 'charge_record'
			@setState {
				type: 1
				recordList: WalletStore.getRecordList()
			}
		else if params[0] is 'present_record'
			@setState {
				type: 2
				recordList: WalletStore.getRecordList()
			}

	charge: ->
		_status = 1
		@setState {
			type: 1
		}
		WalletAction.chargeRecord()
	withdraw: ->
		_status = 2
		@setState {
			type: 2
		}		
		WalletAction.presentRecord()

	render: ->

		cells = @state.recordList.map (item, index) ->
			<div className="m-moneyRecord" key={index}>
				<div className="g-recordItem clearfix">
					<div className="fl">
						<p className="f30">{if _status is 1 then '充值' else '提现'}</p>
						<p className="time">{item.createTime}</p>
					</div>
					<div className="fr right">
						{
							if _status is 1
								<p>{'+' + item.amount.toFixed 2}</p>
							else
								<p>{'-' + item.amount.toFixed 2}</p>		
						}
						<p className="f-state">{Helper.recordStatus _status, item?.state}</p>
					</div>
				</div>
			</div>				
		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={@charge}>
						<span className={ if @state.type is 1 then "active" else ""}>充值</span>
					</li>
					<li onClick={@withdraw}>
						<span className={ if @state.type is 2 then "active" else ""}>提现</span>
					</li>
				</ul>
			</div>
			<div>
				{cells}
			</div>

		</div>	
}

React.render <Record />, document.getElementById('content')
