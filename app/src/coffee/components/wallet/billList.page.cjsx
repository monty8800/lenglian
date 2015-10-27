require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

CSSTransitionGroup = React.addons.CSSTransitionGroup
UserStore = require 'stores/user/user'
WalletStore = require 'stores/wallet/wallet'
WalletModel = require 'model/wallet'
WalletAction = require 'actions/wallet/wallet'

DB = require 'util/storage'
Plugin = require 'util/plugin'
Immutable = require 'immutable'

InfiniteScroll = require('react-infinite-scroll')(React)

user = UserStore.getUser()

_status = 1

_page = 1
_pageSize = 10
_busy = false
_hasMore = true
_count = 0
_type = 2

BillList = React.createClass {

	_select: (type)->
		_type = type
		@setState {
			resultList: Immutable.List()
		}
		_page = 1
		_count = 0
		_hasMore = true
		@_requestData()


	getInitialState:->
		{
			resultList: WalletStore.getBillList()
		}

	componentDidMount: ->
		WalletStore.addChangeListener @_onChange

	componentWillUnmount: ->
		WalletStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		if mark is 'getBillListSucc'
			billList = WalletStore.getBillList()
			_page++
			_busy = false
			_hasMore = _count < billList.size and  (billList.size % _pageSize) is 0
			_count = billList.size
			console.log 'page', _page, '_busy', _busy, '_hasMore', _hasMore, 'count', _count
			@setState {
				resultList: billList
			}

	_requestData: ->
		return null if _busy
		_busy = true
		WalletAction.getBillList {
			userId: user?.id
			type: _type
			pageNow: _page
			pageSize: _pageSize
		}

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
					<li onClick={ @_select.bind this, 2 }><span className={ if _type is 2 then "active" else ''}>支出</span></li>
					<li onClick={ @_select.bind this, 1 }><span className={ if _type is 1 then "active" else ''}>收入</span></li>
				</ul>
			</div>
			<InfiniteScroll pageStart=0 loadMore={@_requestData} hasMore={_hasMore and not _busy}>
			<CSSTransitionGroup transitionName="list">
			{ billItems }
			</CSSTransitionGroup>
			</InfiniteScroll>
		</div>
}


React.render <BillList  />, document.getElementById('content')

