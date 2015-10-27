require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
CSSTransitionGroup = React.addons.CSSTransitionGroup
PureRenderMixin = React.addons.PureRenderMixin
CSSTransitionGroup = React.addons.CSSTransitionGroup
UserStore = require 'stores/user/user'
WalletStore = require 'stores/wallet/wallet'
WalletModel = require 'model/wallet'
WalletAction = require 'actions/wallet/wallet'
Helper = require 'util/helper'
DB = require 'util/storage'
Plugin = require 'util/plugin'
Immutable = require 'immutable'
user = UserStore.getUser()

InfiniteScroll = require('react-infinite-scroll')(React)


_status = 1 #1充值，2提现
_page = 1
_pageSize = 10
_count = 0
_busy = false
_hasMore = true

Record = React.createClass {

	getInitialState: ->
		{				
			recordList: WalletStore.getRecordList()
		}

	componentDidMount: ->
		WalletStore.addChangeListener @resultCallBack

	componentWillNotMount: ->
		WalletStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		if params[0] in ['charge_record', 'present_record']
			recordList = WalletStore.getRecordList()
			_busy = false
			_hasMore = parseInt(recordList.size) - parseInt(_count) >= parseInt(_pageSize)
			_count = recordList.size
			_page++
			console.log 'page', _page, '_busy', _busy, '_hasMore', _hasMore, 'count', _count
			@setState {
				recordList: recordList
			}
			
	_selectType: (type)->
		_status = type
		@setState {
			recordList: Immutable.List()
		}
		_page = 1
		_count = 0
		_hasMore = true
		@_requestData()

	_requestData: ->
		return null if _busy
		_busy = true
		params = {
			userId: user?.id
			pageNow: _page
			pageSize: _pageSize
		}

		if _status is 1
			WalletAction.chargeRecord params
		else
			WalletAction.presentRecord params

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
					<li onClick={@_selectType.bind this, 1}>
						<span className={ if _status is 1 then "active" else ""}>充值</span>
					</li>
					<li onClick={@_selectType.bind this, 2}>
						<span className={ if _status is 2 then "active" else ""}>提现</span>
					</li>
				</ul>
			</div>
			<div>
			<InfiniteScroll pageStart=0 loadMore={@_requestData} hasMore={_hasMore and not _busy}>
			<CSSTransitionGroup transitionName="list">
				{cells}
			</CSSTransitionGroup>
			</InfiniteScroll>
			</div>

		</div>	
}

React.render <Record />, document.getElementById('content')
