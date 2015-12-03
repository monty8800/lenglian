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

UserStore = require 'stores/user/user'

_user = UserStore.getUser()

CarInfo = DB.get 'transData'
_index = DB.get 'transData2'
carId = CarInfo?.carId
_carNo = CarInfo?.carNo

Vehicle = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	_goPage: (page)->
		if page is 'select_start_address'
			DB.put 'transData', 'start_address'
		else if page is 'select_end_address'
			DB.put 'transData', 'end_address'
		Plugin.nav.push [page]

	# 车辆列表点击
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
			isinvoice: '2' # 是否需要发票 默认否
			contacts: user.name or '' # 联系人
			phone:  user.mobile or '' # 手机号
			carId: carId # 车辆Id
			remark:  '' # 备注
			startTime: ''
			endTime: ''
			fromProvince: ''
			fromCity: ''
			fromArea: ''
			fromStreet: ''
			toProvince: ''
			toCity: ''
			toArea: ''
			toStreet: ''
			fromLng: ''
			fromLat: ''
			toLng: ''
			toLat: ''

			currentCar: _carNo # 选择车辆
			carList: CarStore.getFreeCar()
		}

	componentDidMount: ->
		# 空闲这两列表
		CarAction.getFreedomCar()
		CarStore.addChangeListener @resultCallBack

	componentWillUnMount: ->
		CarStore.removeChangeListener @resultCallBack

	resultCallBack: (result)->
		if result[0] is 'release_success'
			# 发布成功
			DB.remove 'transData'
		else if result[0] is 'updateContact'
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
				startPoint: add?.provinceName + add?.cityName + add?.areaName + add?.street
				fromProvince: add?.provinceName
				fromCity: add?.cityName
				fromArea: add?.areaName
				fromStreet: add?.street
				fromLng: add?.longi
				fromLat: add?.lati
			}
		else if result[0] is 'endAddress'
			endAddress = DB.get 'transData'
			add = endAddress.end_address
			console.log '-------endAdd:', endAddress
			@setState {
				destination: add.provinceName + add.cityName + add.areaName + add.street
				toProvince: add.provinceName
				toCity: add.cityName
				toArea: add.areaName
				toStreet: add.street
				toLng: add.longi
				toLat: add.lati
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
		@setState {
			isinvoice: '1'
		}
	unNeedInvoice : (e)->
		@setState {
			isinvoice: '2'
		}
	_submit: ->
		if @state.startPoint is ''
			Plugin.toast.err '请输入出发地'
		else if @state.destination is ''
			Plugin.toast.err '请输入目的地'
		else if @state.currentCar is undefined 
			Plugin.toast.err '请选择要发布的车辆'
		else if @state.currentCar is '' 
			Plugin.toast.err '请选择要发布的车辆'
		else if not Validator.isEmpty @state.startTime
			Plugin.toast.err '请选择开始时间'
		else if not Validator.isEmpty @state.endTime
			Plugin.toast.err '请选择结束时间'
		else if @state.isinvoice isnt '1' and @state.isinvoice isnt '2'
			Plugin.toast.err '请选择是否需要发票'
		else if not Validator.name @state.contacts
			Plugin.toast.err '请输入正确的联系人'
		else if not Validator.mobile @state.phone
			Plugin.toast.err '请输入正确的手机号'
		else
			CarAction.releaseCar({
				userId: _user?.id
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
				fromLng: @state.fromLng
				fromLat: @state.fromLat
				toLng: @state.toLng
				toLat: @state.toLat

				_index: _index
			});

	render: ->
		items = @state.carList.map (item, i) ->
			<div className="carType" onClick={@_goFreeCar.bind this, item}>{item.carNo}</div>
		, this
		<div>
			<div className="m-releasehead ll-font">
				<div className="g-adr-end ll-font g-adr-end-line g-adr-car" onClick={@_goPage.bind this, 'select_start_address'}>
					<p>{@state.startPoint or '出发地(必填)'}</p>
					<i className="icon-mask"></i>
				</div>
				<div className="g-adr-start ll-font g-adr-start-line  g-adr-car" onClick={@_goPage.bind this, 'select_end_address'}>
					<p>{@state.destination or '目的地（必填）'}</p>
					<i className="icon-mask"></i>
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
					<i className="arrow-i">{if @state.startTime then @state.startTime + '到' + @state.endTime else ''}</i>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="g-radio">
					<span>提供发票</span> 
					<div className="radio-box">
						<label >
							<input className="mui-checkbox ll-font" onChange={@unNeedInvoice} defaultChecked=true type="radio" name="xe-checkbox" dangerouslySetInnerHTML={{__html: '否'}} />
						</label>
						<label >
							<input className="mui-checkbox ll-font" onChange={@needInvoice} type="radio" name="xe-checkbox" dangerouslySetInnerHTML={{__html: '是'}} />
						</label>
					</div>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>联系人</span>
					<input valueLink={@linkState 'contacts'} type="text" 
						className="input-weak" placeholder="请输入联系人"/>
					<em onClick={@_goPage.bind this, 'contact_list'}></em>
				</div>
				<div>
					<span>手机号</span>
					<span><input className="input-weak" type="text" valueLink={@linkState 'phone'} placeholder="请输入手机号" /></span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<label htmlFor="remark"><span>备注说明</span> </label>
					<input type="text" className="input-weak" valueLink={@linkState 'remark'} placeholder="选填" id="remark"/>
				</div>
			</div>		
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a href="###" className="btn" onClick={@_submit}>发布</a>
				</div>
			</div>
		</div>
}

React.render <Vehicle />, document.getElementById('content')




