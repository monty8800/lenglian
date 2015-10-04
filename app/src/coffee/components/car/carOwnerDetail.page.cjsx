require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Plugin = require 'util/plugin'
Helper = require 'util/helper'

CarAction = require 'actions/car/car'
CarStore = require 'stores/car/car'
DB = require 'util/storage'
UserStore = require 'stores/user/user'
_user = UserStore.getUser()

DRIVER_LOGO = require 'user-01.jpg'
CarPic03 = require 'car-04.jpg'

CarInfo = DB.get 'fdcar_to_card'	

Detail = React.createClass {

	# 关注
	attention: ->
		if @state.wishlst is true
			CarAction.attentionDetail({
				focusid: CarInfo.userId
				focustype: 1
				userId: _user?.id
				type: 2
			})
		else if @state.wishlst is false
			CarAction.attentionDetail({
				focusid: CarInfo.userId
				focustype: 1
				userId: _user?.id
				type: 1
			})

	getInitialState: ->		
		{
			wishlst: false
			carDetail: CarStore.getCarDetail().toJS()
		}

	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		CarAction.carOwnerDetail(CarInfo.userId, CarInfo.carId)

	componentWillUnMount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		console.log '-------callback'
		if params[0] is 'car_owner_detail'
			carInfo = CarStore.getCarDetail().toJS()
			@setState {
				wishlst: carInfo.wishlst
				carDetail: carInfo
			}
		else if params[0] is 'attention_success'
			@setState {
				wishlst: true
			}
		else if params[0] is 'attention_cancel_success'
			@setState {
				wishlst: false
			}
			
	render: ->
		detail = @state.carDetail
		<div>
			<div className="m-item01">
				<div className="g-detail-dirver g-det-pad0">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<img src={DRIVER_LOGO} />
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{detail.name}</span><span className="g-dirname-single">{if detail.certificationis is '1' then '(个体)' else if detail.certificationis is '2' then '(企业 )'}</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<ul className="g-driver-contact" onClick={@attention}>
							<li className={if @state.wishlst is true then "ll-font" else 'll-font active'}>关注</li>
						</ul>
					</div>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-pro-p">
					<p className="g-pro-name">车牌号码: <span>{detail?.carNo}</span></p>
					<p className="g-pro-name">车辆类型: <span>{Helper.carTypeMapper detail?.status}</span></p>
				</div>
				<div className="g-pro-detail">
					<div className="g-pro-pic fl">
						<img src={CarPic03} />
					</div>
					<div className="g-pro-text fl">
						<p>车辆类别: <span>{Helper.carCategoryMapper detail.category}</span></p>
						<p>可载货重: <span>{detail?.heavy}</span></p>
						<p>可载泡货: <span>{detail?.bulky}</span></p>
						<p>车辆长度: <span>{detail?.carVehicle}</span></p>
					</div>
				</div>
			</div>
			<div className="m-detail-info m-nomargin">
				<p>
					<span>随车司机:</span>
					<span>{detail?.name}</span>
				</p>
				<p>
					<span>联系电话:</span>
					<span>{detail?.mobile}</span>
				</p>			
			</div>
		</div>
}

React.render <Detail />, document.getElementById('content')
