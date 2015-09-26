require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'
Validator = require 'util/validator'
CarAction = require 'actions/car/car'


Vehicle = React.createClass {

	mixins: [PureRenderMixin, LinkedStateMixin]

	getInitialState: ->
		user = UserStore.getUser()
		{
			isShow: 1
			startPoint: '' # 出发地
			destination: '' # 目的地
			invoice: 1 # 是否需要发票 默认是
			contact: user.name or '' # 联系人
			mobile:  user.mobile or '' # 手机号
			remark:  '' # 备注
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

	_submit: ->
		if @state.startPoint is ''
			Plugin.toast.err '请输入出发地'
		else if not Validator.name @state.contact
			Plugin.toast.err '请输入正确的姓名'
		else if not Validator.mobile @state.mobile
			Plugin.toast.err '请输入正确的手机号'
		else if not Validator.remark @state.remark
			Plugin.toast.err '备注1-30个字符'
		else
			CarAction.releaseCar();

	render: ->
		<div>
			<div className="m-releasehead ll-font">
				<div className="g-adr-end ll-font g-adr-end-line g-adr-car">
					<input valueLink={@linkState 'startPoint'} type="text" placeholder="出发地"/>
				</div>
				<div className="g-adr-start ll-font g-adr-start-line  g-adr-car">
					<input valueLink={@linkState 'destination'} type="text" placeholder="终点(选填)"/>
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
					<input type="radio" name="invoice" value="no" id="no" className='radio ll-font checked'/>
					<label htmlFor="no">否</label>
					<input type="radio" name="invoice" value="yes" id="yes" className='radio ll-font' />
					<label htmlFor="yes">是</label>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>联系人</span>
					<span><input type="text" valueLink={@linkState 'contact'} placeholder="请输入联系人" id="remark"/></span>		
				</div>
				<div>
					<span>手机号</span>
					<span><input type="text" valueLink={@linkState 'mobile'} placeholder="请输入手机号" /></span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-voice ll-font">
					<label htmlFor="remark"><span>备注说明</span> </label>
					<input type="text" valueLink={@linkState 'remark'} placeholder="选填" id="remark"/>
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




