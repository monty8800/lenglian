require 'components/common/common'
require 'user-center-style'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

LinkedStateMixin = React.addons.LinkedStateMixin
Plugin = require 'util/plugin'
Validator = require 'util/validator'
PicCell = require 'components/car/picCell'
UserStore = require 'stores/user/user'
CarStore = require 'stores/car/car'
User = require 'model/user'
DB = require 'util/storage'
CarAction = require 'actions/car/car'
AddressStore = require 'stores/address/address'
Selection = require 'components/car/addCarSelection'

# 数据源
selList = [
	{
		key: 'carType'
		value: '车辆类型'
		options: [
			{key: 1, value: '普通货车'}
			{key: 2, value: '冷藏车'}
			{key: 3, value: '平板'}
			{key: 4, value: '箱式'}
			{key: 5, value: '集装箱'}
			{key: 6, value: '高栏'}
		]
	}
	{
		key: 'carCategory'
		value: '车辆类别'
		options: [
			{key: 1, value: '单车'}
			{key: 2, value: '前四后四'}
			{key: 3, value: '前四后六'}
			{key: 4, value: '前四后八'}
			{key: 5, value: '后八轮'}
			{key: 6, value: '五桥'}
			{key: 7, value: '六桥'}
			{key: 8, value: '半挂'}
		]
	}
	{
		key: 'weight'
		value: '可载重货'
		options: [
			{key: 1, value: '2吨'}
			{key: 2, value: '3吨'}
			{key: 3, value: '4吨'}
			{key: 4, value: '5吨'}
			{key: 4, value: '6吨'}
			{key: 5, value: '8吨'}
			{key: 6, value: '10吨'}
			{key: 7, value: '12吨'}
			{key: 8, value: '15吨'}
			{key: 9, value: '18吨'}
			{key: 10, value: '20吨'}
			{key: 11, value: '25吨'}
			{key: 12, value: '28吨'}
			{key: 13, value: '30吨'}
			{key: 14, value: '30~40吨'}
		]
	}
	{
		key: 'carLength'
		value: '车辆长度'
		options: [
			{key: 1, value: '3.8米'}
			{key: 2, value: '4.2米'}
			{key: 3, value: '4.8米'}
			{key: 4, value: '5.8米'}
			{key: 4, value: '6.2米'}
			{key: 5, value: '6.8米'}
			{key: 6, value: '7.4米'}
			{key: 7, value: '7.8米'}
			{key: 8, value: '8.6米'}
			{key: 9, value: '9.6米'}
			{key: 10, value: '13~15米'}
			{key: 11, value: '15米以上'}
		]
	}
]


AddCar = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	componentDidMount: ->
		CarStore.addChangeListener @resultCallBack


	componentWillUnMount: ->
		CarStore.removeChangeListener @resultCallBack


	resultCallBack: (result)->
		if result is 'setAuthPic:done'
			user = UserStore.getUser()
			carPic = @state.user.carPic
			license = @state.user.license
			transLicensePic = @state.user.transLicensePic
			console.log '----------carPic:', carPic
			console.log '----------license:', license
			console.log '----------transLicensePic:', transLicensePic
			@setState {
				user: UserStore.getUser()
				carNum: @state.carNum
				vinNum: @state.vinNum
				name: @state.name
				idNum: @state.idNum
			}
		else if result is 'auth:done'
			console.log '------result:' + result
		else if result[0] is 'selection'
			if result[1] is 'carType'
				newState = Object.create @state
				newState.type = result[2]
				@setState newState
			else if result[1] is 'carCategory'
				newState = Object.create @state
				newState.category = result[2]
				@setState newState
			else if result[1] is 'weight'
				newState = Object.create @state
				newState.heavy = result[2]
				@setState newState
			else if result[1] is 'carLength'
				newState = Object.create @state
				newState.vehicle = result[2]
				@setState newState

	getInitialState: ->
		# 清空上次图片
		_user = new User
		_user = _user.set 'carPic', null
		_user = _user.set 'license', null
		_user = _user.set 'transLicensePic', null
		DB.put 'user', _user.toJS()

		user = UserStore.getUser()

		user = user.set 'carPic', null
		user = user.set 'license', null
		user = user.set 'transLicensePic', null

		console.log '----------carPic:', user.carPic
		console.log '----------license:', user.license
		console.log '----------transLicensePic:', user.transLicensePic

		address = AddressStore.getAddress()
		{
			user: user
			carNo: '' # 车牌号
			bulky: '' # 可载泡货
			driver: '' # 随车司机
			latitude: address.lati
			longitude: address.longi
			mobile: user.mobile or ''
			category: ''
			heavy: ''
			type: ''
			vehicle: ''
		}

	handleSubmit: ->
		bulky = @state.bulky
		if bulky.length isnt 0
			h = bulky.split '.'
			console.log '-------hhhh:', h
			if h.length > 2
				return Plugin.toast.err '只能包含一个小数点哦'
			else if h.length > 1
				index = bulky.indexOf '.'
				last = bulky.substr index + 1, bulky.length
				console.log '------hasdfads:', last
				if last.length > 2
					return Plugin.toast.err '只能有两位小数哦'
		if not Validator.carNum @state.carNo
			Plugin.toast.err '请输入正确的车牌号'
		else if @state.category is ''
			Plugin.toast.err '请选择车辆类型'
		else if @state.heavy is ''
			Plugin.toast.err '可载重货不能为空'
		else if @state.type is ''
			Plugin.toast.err '请选择车辆类别'
		else if @state.vehicle is ''
			Plugin.toast.err '请选择车辆长度'
		else if not Validator.isEmpty @state.bulky
			Plugin.toast.err '泡货不能为空'
		else if not Validator.isEmpty @state.driver
			Plugin.toast.err '随车司机不能为空'
		else if not Validator.mobile @state.mobile
			Plugin.toast.err '请输入正确的手机号'
		# else if not @state.user.carPic
			# Plugin.toast.err '请上传车辆图片'	
		else if not @state.user.license
			Plugin.toast.err '请上传行驶证图片'	
		else if not @state.user.transLicensePic
			Plugin.toast.err '请上传道路运输许可证'
		else 
			CarAction.addCar {
				bulky: @state.bulky # 可载泡货
				carno: @state.carNo # 车牌号
				category: (@state.category + 1) # 车辆类别
				driver: @state.driver # 随车司机
				heavy: (@state.heavy + 1) # 可载重货
				latitude: @state.latitude # 纬度
				longitude: @state.longitude # 经度
				phone: @state.mobile # 联系电话 
				type: (@state.type + 1) # 车辆类型
				userId: @state.user.id
				vehicle: (@state.vehicle + 1) # 车辆长度
			}, [
				{
					filed: 'imgUrl'
					path: @state.user.carPic
					name: 'carPic.jpg'
				}
				{
					filed: 'drivingImg'
					path: @state.user.license
					name: 'license.jpg'
				}
				{
					filed: 'transportImg'
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
			<PicCell key={i}  type={cell.type} url={cell.url} name={cell.name} optional={cell.optional} />
		, this

		<div>
			<div className="m-releaseitem">
				<div>
					<span>车牌号码</span>
					<input type="text" valueLink={@linkState 'carNo'} ref="carNo" className="weight car" placeholder="例：渝B622B5"/>
				</div>
			</div>

			<div className="m-nav03">
				<ul>
					{
						for item, i in selList
							<Selection items=item key={i} />
					}
				</ul>
			</div>

			<div className="m-releaseitem">
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
					<a href="###" className="btn" onClick={@.handleSubmit}>新增车辆</a>
				</div>
			</div>
		</div>
}

React.render <AddCar />, document.getElementById('content')

