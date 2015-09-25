require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
Plugin = require 'util/plugin'

Vehicle = React.createClass {

	getInitialState: ->
		{
			isShow: 1
			note1: 1
			note2: 2
		}

	_showCar: ->
		if @state.isShow is 1
			@setState {
				isShow: 2
			}
		else 
			@setState {
				isShow: 1
			}

	_isChecked: (who)->
		console.log 'dffdfd'
		if who is 1
			@setState {
				note1: 1
				note2: 2
			}
		else 
			@setState {
				note1: 2
				note2: 1
			}

	_submit: ->
		Plugin.nav.push ['pic']

	_temp: ->
		Plugin.nav.push ['temp']		

	render: ->
		<div>
			<div className="m-releasehead ll-font">
				<div className="g-adr-end ll-font g-adr-end-line g-adr-car">
					<input type="type" placeholder="出发地"/>
				</div>
				<div className="g-adr-start ll-font g-adr-start-line  g-adr-car">
					<input type="type" placeholder="终点(选填)"/>
				</div>
			</div>	
			<div className="m-releaseitem">
				<div className="g-div01 ll-font u-arrow-right " onClick={@_showCar}>
					<span>选择车辆 </span>
				</div>
				<div style={ display: if @state.isShow is 1 then 'none' else 'block'}>
					<div className="carType">京B12345  普通车型</div>
					<div className="carType">京B12345  普通车型</div>
				</div>
				<div className="u-arrow-right ll-font">
					<span>装货时间</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="g-radio">
					<span>提供发票</span>
					<input type="radio" name="invoice" onClic={@_isChecked.bind this} value="no" id="no" className={ if @state.note1 is 1 then "radio ll-font" else 'radio ll-font checked'}/>
					<label htmlFor="no">否</label>
					<input type="radio" name="invoice" onClic={@_isChecked.bind this} value="yes" id="yes" className={ if @state.note2 is 1 then "radio ll-font" else 'radio ll-font checked'}/>
					<label htmlFor="yes">是</label>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>联系人</span><span>柠静</span>
				</div>
				<div>
					<span>手机号</span><span>13412356854</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-voice ll-font">
					<label htmlFor="remark"><span onClick={@_temp}>备注说明</span> </label>
					<input type="text" placeholder="选填" id="remark"/>
				</div>
			</div>		
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a href="#" className="btn" onClick={@_submit}>发布</a>
				</div>
			</div>
		</div>
}

React.render <Vehicle />, document.getElementById('content')




