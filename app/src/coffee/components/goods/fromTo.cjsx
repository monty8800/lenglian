require 'components/common/common'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

Plugin = require 'util/plugin'

AddressStore = require 'stores/address/address'
DB = require 'util/storage'


FromTo = React.createClass {
	mixins: [PureRenderMixin]
	componentDidMount: ->
		AddressStore.addChangeListener @_change

	componentWillUnmount: ->
		AddressStore.removeChangeListener @_change

	_selectAddress: (type)->
		DB.put 'transData', type
		Plugin.nav.push ['selectAddress']

	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'fromTo:update'
			@setState {
				fromTo: AddressStore.getFromToList()
			}

	getInitialState: ->
		{
			fromTo: AddressStore.getFromToList()
		}
	render: ->
		<div onClick={@_selectAddress} className="m-releasehead ll-font">
			<div className="g-adr-end ll-font g-adr-end-line">
				<input readOnly="readOnly" type="type" placeholder="输入终点"/>
			</div>
			<div className="g-adr-pass ll-font g-adr-pass-line">
				<input readOnly="readOnly" type="type" placeholder="北京海淀区中关村泰鹏大厦"/>
			</div>
			<div className="g-adr-middle ll-font">
				<input readOnly="readOnly" type="type" placeholder="途径地"/>
			</div>
			<div className="g-adr-start ll-font g-adr-start-line">
				<input readOnly="readOnly" type="type" placeholder="输入起点"/>
			</div>
			<a href="#" className="u-addIcon"></a>
		</div>
}


module.exports = FromTo


