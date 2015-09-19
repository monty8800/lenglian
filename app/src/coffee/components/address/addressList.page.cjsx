require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

AddressStore = require 'stores/address/address'
AddressAction = require 'actions/address/address'

Plugin = require 'util/plugin'

_index = -1

_addressList = []

locationUrl = 'modifyAddress'

Address = React.createClass {

	hrefDetail: (page)->
		Plugin.nav.push [page]

	setDefault: (item)->
		console.log 'default ---- ', item

	modifyAddress: (item)->
		console.log 'modify_address -- ',item 

	delAddress: (item, i)->
		_index = i
		console.log 'del_address -- ',item
		AddressAction.delAddress(item.id)

	getInitialState: ->
		addressList: AddressStore.getAddressList()

	componentDidMount: ->
		AddressStore.addChangeListener @resultCallBack
		AddressAction.addressList()
  
	componentWillUnMount: ->
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
					console.log 'del_success'
				else 
					console.log 'del_falil'					


	minxins: [PureRenderMixin]
	render: ->
		_addressList = @state.addressList
		items = @state.addressList.map (item, i) -> 
			<div key={ i }>
				<div className="m-adr-con">
					<ul>
						<li>{ item.provinceId } { item.cityId } { item.areaId }</li>
						<li>
							<label className="u-label fl" onClick={@setDefault.bind this, item}>
								<input name="adr-radio" className="ll-font circle" type="radio" />设置为常用地址
							</label>
							<p className="fr">
								<span className="ll-font" onClick={@hrefDetail.bind this, locationUrl}>编辑</span>
								<span className="ll-font" onClick={@delAddress.bind this, item, i}>删除</span>
							</p>
						</li>
					</ul>
				</div>
			</div>
		, this
		<div>{ items }</div>
}

React.render <Address />, document.getElementById('content')

