require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Plugin = require 'util/plugin'
UserStore = require 'stores/user/user'
Validator = require 'util/validator'
CarAction = require 'actions/car/car'
CarStore = require 'stores/car/car'
DB = require 'util/storage'

CarInfo = DB.get 'transData'
carId = CarInfo?.carId

Vehicle = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	_goPage: (page)->
		if page is 'select_start_address'
			DB.put 'transData', 'start_address'
		else if page is 'select_end_address'
			DB.put 'transData', 'end_address'
		Plugin.nav.push [page]

	_goFreeCar: (item)->
		@setState {
			isShow: 1
			currentCar: item.carNo
			carId: item.carId
		}

	getInitialState: ->
		user = UserStore.getUser()
		{
			isShow: 1

			startPoint: '' # 出发地
			destination: '' # 目的地
			isinvoice: '' # 是否需要发票 默认是
			contacts: user.name or '' # 联系人
			phone:  user.mobile or '' # 手机号
			carId: '' # 车辆Id
			remark:  'bbb' # 备注
			startTime: ''
			endTime: ''
			fromProvince: '北京市'
			fromCity: '北京市'
			fromArea: '海淀区'
			fromStreet: '2红'
			toProvince: '北京市'
			toCity: '北京市'
			toArea: '海淀区'
			toStreet: '青楼'

			currentCar: '' # 选择车辆
			carList: CarStore.getFreeCar()
		}

	componentDidMount: ->
		# 空闲这两列表
		CarAction.getFreedomCar()
		CarStore.addChangeListener @resultCallBack

	componentWillUnMount: ->
		CarStore.removeChangeListener @resultCallBack

	resultCallBack: (result)->
		if result[0] is 'updateContact'
			@setState {
				contacts: result[1] # 联系人
				phone: result[2] # 手机号
			}
		else if result[0] is 'updateDate'
			@setState {
				startTime: result[1] # 开始时间
				endTime: result[2] # 结束时间
			}
		else if result[0] is 'startAddress'
			console.log '-------startAddCallBack--'
			startAddress = DB.get 'transData'
			add = startAddress.start_address
			console.log '-------startAdd:', startAddress
			@setState {
				startPoint: add.provinceName + add.cityName + add.areaName + add.street
				fromProvince: add.provinceName
				fromCity: add.cityName
				fromArea: add.areaName
				fromStreet: add.street
			}
		else if result[0] is 'endAddress'
			endAddress = DB.get 'transData'
			add = endAddress.end_address
			@setState {
				destination: add.provinceName + add.cityName + add.areaName + add.street
				toProvince: add.provinceName
				toCity: add.cityName
				toArea: add.areaName
				toStreet: add.street
			}
		else if result[0] is 'free_car'
			console.log '-----freeCar:'
			console.log '------carList:', CarStore.getFreeCar()
			@setState {
				carList: CarStore.getFreeCar()
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

	# 发票
	needInvoice : (e)->
		if e.target.checked
			@setState {
				isinvoice: '1'
			}
	unNeedInvoice : (e)->
		if e.target.checked
			@setState {
				isinvoice: '2'
			}
	_submit: ->
		if @state.startPoint is ''
			Plugin.toast.err '请输入出发地'
		else if not Validator.name @state.contacts
			Plugin.toast.err '请输入正确的姓名'
		else if not Validator.mobile @state.phone
			Plugin.toast.err '请输入正确的手机号'
		else if not Validator.remark @state.remark
			Plugin.toast.err '备注1-30个字符'
		else
			CarAction.releaseCar({
				startPoint: @state.startPoint # 出发地
				destination: @state.destination # 目的地
				isinvoice: @state.isinvoice # 是否需要发票 默认是
				contacts: @state.contacts # 联系人
				phone:  @state.phone # 手机号
				carId: @state.carId # 车辆Id
				remark:  @state.remark # 备注
				startTime: @state.startTime
				endTime: @state.endTime
				fromProvince: @state.fromProvince
				fromCity: @state.fromCity
				fromArea: @state.fromArea
				fromStreet: @state.fromStreet
				toProvince: @state.toProvince
				toCity: @state.toCity
				toArea: @state.toArea
				toStreet: @state.toStreet
			});

	render: ->
		items = @state.carList.map (item, i) ->
			<div className="carType" onClick={@_goFreeCar.bind this, item}>{item.carNo}</div>
		, this
		<div>
			<div className="m-releasehead ll-font">
				<div className="g-adr-end ll-font g-adr-end-line g-adr-car" onClick={@_goPage.bind this, 'select_start_address'}>
					<input readOnly="readOnly" valueLink={@linkState 'startPoint'} type="text" placeholder="出发地"/>
				</div>
				<div className="g-adr-start ll-font g-adr-start-line  g-adr-car" onClick={@_goPage.bind this, 'select_end_address'}>
					<input readOnly="readOnly" valueLink={@linkState 'destination'} type="text" placeholder="终点(选填)"/>
				</div>
			</div>	
			<div className="m-releaseitem">
				<div className={if @state.isShow is 1 then "u-arrow-right ll-font g-tab01" else "u-arrow-right ll-font g-tab01 g-tab01-act"} onClick={@_showCar}>
					<span>选择车辆 </span>
					<i className="arrow-i">{@state.currentCar}</i>
				</div>
				<div className="carType-con g-tab01-con" style={ display: if @state.isShow is 1 then 'none' else 'block'}>
					{items}
				</div>
				<div className="u-arrow-right ll-font g-tab01" onClick={@_goPage.bind this, 'datepicker'}>
					<span>装货时间</span>
					<i className="arrow-i">{@state.startTime}-{@state.endTime}</i>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="g-radio">
					<span>提供发票</span> 
					<div className="radio-box">
						<label className="label-checkbox">
							<input onChange=@unNeedInvoice type="radio" name="xe-checkbox"/><span className="item-media ll-font"></span><span>否</span>
						</label>
						<label className="label-checkbox">
							<input onChange=@needInvoice type="radio" name="xe-checkbox"/><span className="item-media ll-font"></span><span>是</span>
						</label>
					</div>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>联系人</span>
					<input valueLink={@linkState 'contacts'} type="text" 
						className="input-weak" placeholder="请输入收货人"/>
					<em onClick={@_goPage.bind this, 'contact_list'}></em>
				</div>
				<div>
					<span>手机号</span>
					<span><input type="text" valueLink={@linkState 'phone'} placeholder="请输入手机号" /></span>
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




