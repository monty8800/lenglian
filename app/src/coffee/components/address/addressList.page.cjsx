require 'components/common/common'
require 'index-style'


React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
CSSTransitionGroup = React.addons.CSSTransitionGroup

AddressStore = require 'stores/address/address'
AddressAction = require 'actions/address/address'

Plugin = require 'util/plugin'

_index = -1

_addressList = []

locationUrl = 'modifyAddress'

DB = require 'util/storage'

Address = React.createClass {

	hrefDetail: (page)->
		Plugin.nav.push [page]

	setDefault: (item)->
		console.log 'default ---- ', item
		Plugin.debug '表结构没有该字段呢' 

	modifyAddress: (item)->
		console.log 'modify_address -- ',item 
		DB.put 'transData', item
		Plugin.nav.push ['modifyAddress']

	delAddress: (item, i)->
		Plugin.alert '确定删除吗', '提示', (index)->
			console.log index
			if index is 1
				_index = i
				console.log 'del_address -- ',item
				AddressAction.delAddress(item.id)
		, ['确定', '取消']

	getDefaultProps: ->
		console.log '---------getDefaultProps----'

	getInitialState: ->
		console.log '---------getInitialState----'
		addressList: AddressStore.getAddressList()

	componentWillMount: ->
		console.log '---------componentWillMount----'

	componentDidMount: ->
		console.log '---------componentDidMount----'
		AddressStore.addChangeListener @resultCallBack
		AddressAction.addressList()
		DB.remove 'transData'
  
	componentWillUnMount: ->
		console.log '---------componentWillUnMount----'
		AddressStore.removeChangeListener @resultCallBack

	resultCallBack: (who)->
		switch who
			when 'list'
				@setState {
					addressList: AddressStore.getAddressList()
				}
			else 
				if who is 'del_success'
					list = _addressList.delete(_index)
					@setState {
						addressList: list
					}	
					Plugin.toast.success '删除成功'
				else 
					console.log who			


	minxins: [PureRenderMixin]
	render: ->
		console.log '---------render----'
		_addressList = @state.addressList
		items = @state.addressList.map (item, i) -> 
			<div key={ i }>
				<div className="m-adr-con">
					<ul>
						<li>{ item?.provinceName }{ item?.cityName }{ item?.areaName }{ item?.street}</li>
						<li>
							<p className="fr">
								<span className="ll-font" onClick={@modifyAddress.bind this, item}>编辑</span>
								<span className="ll-font" onClick={@delAddress.bind this, item, i}>删除</span>
							</p>
						</li>
					</ul>
				</div>
			</div>
		, this
		<div>
		<CSSTransitionGroup transitionName="list">
		{ items }
		</CSSTransitionGroup>
		</div>
}

React.render <Address />, document.getElementById('content')

