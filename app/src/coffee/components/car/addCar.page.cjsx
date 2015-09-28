require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Plugin = require 'util/plugin'
Validator = require 'util/validator'
PicCell = require 'components/car/picCell'
UserStore = require 'stores/user/user'
CarStore = require 'stores/car/car'
CarAction = require 'actions/car/car'
AddressStore = require 'stores/address/address'

AddCar = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	componentDidMount: ->
		CarStore.addChangeListener @resultCallBack

	componentWillUnMount: ->
		CarStore.removeChangeListener @resultCallBack

	resultCallBack: (result)->
		if result is 'setAuthPic:done'
			@setState {
				user: UserStore.getUser()
				carNum: @state.carNum
				vinNum: @state.vinNum
				name: @state.name
				idNum: @state.idNum
			}
		else if result is 'auth:done'
			console.log '------result:' + result

	getInitialState: ->
		user = UserStore.getUser()
		address = AddressStore.getAddress()
		{
			user: user
			carNo: '' # 车牌号
			bulky: '' # 可载泡货
			driver: '' # 随车司机
			latitude: address.lati
			longitude: address.longi
			mobile: user.mobile or ''
		}

	handleSubmit: ->
		if not Validator.carNum @state.carNo
			Plugin.toast.err '请输入正确的车牌号'
		else if not Validator.isEmpty @state.bulky
			Plugin.toast.err '泡货不能为空'
		else if not Validator.isEmpty @state.driver
			Plugin.toast.err '随车司机不能为空'
		else if not Validator.mobile @state.mobile
			Plugin.toast.err '请输入正确的手机号'
		else if not @state.user.carPic
			Plugin.toast.err '请上传车辆图片'
		else if not @state.user.license
			Plugin.toast.err '请上传行驶证图片'
		else if not @state.user.transLicensePic
			Plugin.toast.err '请上传道路运输许可证'
		else 
			# TODO 界面效果没有做哦！
			CarAction.addCar {
				bulky: @state.bulky # 可载泡货
				carno: @state.carNo # 车牌号
				category: '1' # 车辆类别
				driver: @state.driver # 随车司机
				heavy: '1' # 可载重货
				latitude: @state.latitude # 纬度
				longitude: @state.longitude # 经度
				phone: @state.mobile # 联系电话 
				type: '1' # 车辆类型
				userId: @state.user.id
				vehicle: '2' # 车辆长度
			}, [
				{
					filed: 'carPic'
					path: @state.user.carPic
					name: 'carPic.jpg'
				}
				{
					filed: 'license'
					path: @state.user.license
					name: 'license.jpg'
				}
				{
					filed: 'transLicensePic'
					path: @state.user.transLicensePic
					name: 'transLicensePic.jpg'
				}
			]

	render: ->

		cells = [
			{
				name: '车辆图片'
				url: @state.user.carPic
				optional: false
				type: 'carPic'
			}
			{
				name: '行驶证图片'
				url: @state.user.license
				optional: false
				type: 'license'
			}
			{
				name: '道路运输许可证'
				url: @state.user.transLicensePic
				optional: false
				type: 'transLicensePic'
			}
		].map (cell, i)->
			<PicCell key={i} type={cell.type} url={cell.url} name={cell.name} optional={cell.optional} />
		, this

		<div>
			<div className="m-releaseitem">
				<div>
					<span>车牌号码</span>
					<input type="text" valueLink={@linkState 'carNo'} ref="carNo" className="weight car" placeholder="例：渝B622B5"/>
				</div>
				<div className="u-arrow-right ll-font">
					<span>车辆类型</span>
				</div>
				<div className="u-arrow-right ll-font">
					<span>车辆类别</span>
				</div>
			</div>
			<div className="m-releaseitem">
				
				<div className="u-arrow-right ll-font">
					<span>可载重货</span>
				</div>
				<div>
					<span>可载泡货</span>
					<input ref="bulky" valueLink={@linkState 'bulky'} type="text" className="weight car"/>
					<span>方</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<label htmlFor="remark"><span>随车司机</span> </label>
					<input ref="driver" valueLink={@linkState 'driver'} type="text" placeholder="请输入随车司机" id="remark"/>
				</div>
				<div>
					<span>联系电话</span>
					<input ref="mobile" valueLink={@linkState 'mobile'}></input>
				</div>
			</div>	
			<div className="u-green ll-font u-tip">
				温馨提示：单张图片大小不能超过1M
			</div>
			<div className="g-uploadPic">
				<ul className="clearfix">
					{ cells }
				</ul>
			</div>
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a href="#" className="btn" onClick={@.handleSubmit.bind this}>新增车辆</a>
				</div>
			</div>
		</div>
}

React.render <AddCar />, document.getElementById('content')

