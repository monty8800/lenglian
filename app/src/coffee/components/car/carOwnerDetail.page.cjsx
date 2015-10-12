require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Constants = require 'constants/constants'
Plugin = require 'util/plugin'
Helper = require 'util/helper'

CarAction = require 'actions/car/car'
CarStore = require 'stores/car/car'
DB = require 'util/storage'
UserStore = require 'stores/user/user'
_user = UserStore.getUser()
Image = require 'util/image'
XeImage = require 'components/common/xeImage'
Image = require 'util/image'
avatar = require 'user-01'

_detailParams = DB.get 'transData'
carId = _detailParams[0]
dUserId = _detailParams[1]
carNo = _detailParams[2]
carStatus = _detailParams[3]

Detail = React.createClass {

	# 关注
	attention: ->
		if @state.wishlst is true
			CarAction.attentionDetail({
				focusid: dUserId
				focustype: 2
				userId: _user?.id
				type: 2
			})
		else if @state.wishlst is false
			CarAction.attentionDetail({
				focusid: dUserId
				focustype: 2
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
		CarAction.carOwnerDetail(carId, dUserId)

	componentWillUnMount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
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
			<div className="m-orderdetail clearfix" style={{display: if carNo is undefined then 'none' else 'block'}}>
				<p className="fl">订单号：<span>{carNo}</span></p>
				<p className="fr">{carStatus}</p>
			</div>
			<div className="m-item01">
				<div className="g-detail-dirver g-det-pad0">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<XeImage src={detail?.userImgUrl} size='130x130' type='avatar' />
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
					<p className="g-pro-name">车辆类型: <span>{Helper.carTypeMapper detail?.carType}</span></p>
				</div>
				<div className="g-pro-detail">
					<div className="g-pro-pic fl">
						<img src={Image.getFullPath detail?.carPic, Constants.carPicSize} />
					</div>
					<div className="g-pro-text fl">
						<p>车辆类别: <span>{Helper.carCategoryMapper detail?.category}</span></p>
						<p>可载货重: <span>{Helper.goodsWeight detail?.heavy}</span></p>
						<p>可载泡货: <span>{detail?.bulky}</span></p>
						<p>车辆长度: <span>{Helper.carVehicle detail?.carVehicle}</span></p>
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
