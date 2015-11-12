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
Auth = require 'util/auth'
Raty = require 'components/common/raty'

_detailParams = DB.get 'transData'
carId = _detailParams[0]
dUserId = _detailParams[1]
carNo = _detailParams[2]
carStatus = _detailParams[3]
carSourceId = _detailParams[3]
Auth = require 'util/auth'

Detail = React.createClass {

	# 关注
	attention: (wishlst)->
		# Auth.needLogin ->	
		console.log '-------wishlst:', @state.wishlst
		if wishlst is true
			CarAction.attentionDetail({
				focusid: dUserId
				focustype: 2
				userId: _user?.id
				type: 2
			})
		else if wishlst is false
			CarAction.attentionDetail({
				focusid: dUserId
				focustype: 2
				userId: _user?.id
				type: 1
			})

	getInitialState: ->
		{
			wishlst: false
			score: 0
			isInit: true
			# carDetail: CarStore.getCarSourceDetail()
			hideFallow:true
		}

	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		CarAction.carSourceDetail {
			id: carSourceId
		}

	componentWillUnMount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		console.log 'event change', params
		if params is 'car:source:detail:done'
			carInfo = CarStore.getCarSourceDetail()
			@setState {
				score: carInfo?.get('carScore')
				wishlst: carInfo?.get('wishlst')
				carDetail: carInfo
				isInit: false
				hideFallow: carInfo?.get('carResource')?['car']?['userId'] is _user.id
			}
		else if params[0] is 'attention_success'
			@setState {
				wishlst: true
			}
		else if params[0] is 'attention_cancel_success'
			@setState {
				wishlst: false
			}

	# # 选择此车
	# _select: (e)->
	# 	carId = @state.carDetail.id
	# 	carUserId = @state.carDetail.userId

	# 	Auth.needLogin ->
	# 		Auth.needAuth 'goods',->
	# 		# 判断该车源是否是自己发布的，如果是自己发布的提示不能选择
	# 			return Plugin.toast.err '不能选择自己的车源哦' if carUserId is _user?.id
	# 			console.log '-------carUserId:', carUserId
	# 			console.log '-------userId:', _user.id
	# 			console.log '-------select_car', carId
	# 			Plugin.nav.push ['select_goods', carId]
	# 	e.stopPropagation()

	mixins: [PureRenderMixin, LinkedStateMixin]
	render: ->
		detail = @state.carDetail
		console.log 'detail----', detail
		<div>
			<div className="m-orderdetail clearfix" style={{display: if carNo is undefined then 'none' else 'block'}}>
				<p className="fl">订单号：<span>{carNo}</span></p>
				<p className="fr">{Helper.navStatus detail?.get('carResource')?['car']?['status']}</p>
			</div>
			<div className="m-item01">
				<div className="g-detail-dirver g-det-pad0">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<XeImage src={detail?.get('imgurl')} size='130x130' type='avatar' />
						</div>	
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{detail?.get('name')}</span><span className="g-dirname-single">{if detail?.get('certification') is '1' then '(个体)' else if detail?.get('certification') is '2' then '(企业 )'}</span>
							</div>
							<div className="g-dirver-dis ll-font">
								{
									if not @state.isInit
										<Raty score={@state.score} />
								}
							</div>
						</div>
						<ul style={{ display: if @state.hideFallow then 'none' else 'block' }} className="g-driver-contact" onClick={@attention.bind this, @state.wishlst}>
							<li className={if @state.wishlst is true then "ll-font" else 'll-font active'}>关注</li>
						</ul>
					</div>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-pro-p">
					<p className="g-pro-name">车牌号码: <span>{detail?.get('carResource')?['car']?['carno']}</span></p>
					<p className="g-pro-name">车辆类型: <span>{Helper.carTypeMapper detail?.get('carResource')?['car']?['type']}</span></p>
				</div>
				<div className="g-pro-detail clearfix">
					<div className="g-pro-pic fl">
						<XeImage src={detail?.get('carResource')?['car']?['imgurl']} size=Constants.carPicSize />
					</div>
					<div className="g-pro-text fl">
						<p>车辆类别: <span>{Helper.carCategoryMapper detail?.get('carResource')?['car']?['category']}</span></p>
						<p>可载重货: <span>{Helper.goodsWeight detail?.get('carResource')?['car']?['heavy']}</span></p>
						<p>可载泡货: <span>{ if detail?.get('carResource')?['car']?['bulky'] is '' then '' else detail?.get('carResource')?['car']?['bulky'] + '方'}</span></p>
						<p>车辆长度: <span>{Helper.carVehicle detail?.get('carResource')?['car']?['carVehicle']}</span></p>
					</div>
				</div>
			</div>
			<div className="m-detail-info m-nomargin">
				<p>
					<span>司机姓名:</span>
					<span>{detail?.get('carResource')['car']?['driver']}</span>
				</p>
				<p>	
					<span>联系电话:</span>
					<span>{ if parseInt(UserStore.getUser()?.certification) is 0 then '认证后可见' else detail?.get('carResource')?['car']?['phone'] }</span>
				</p>
				<p>
					<span>需要发票:</span>
					<span>{Helper.isInvoinceMap detail?.get('carResource')?('isinvoice')}</span>
				</p>
				{
					if detail?.get('carResource')?['remark']
						<p>
							<span>备注:</span>
							<span>{detail?.get('carResource')?['remark']}</span>
						</p>
				}
			
			</div>

		</div>
}

React.render <Detail />, document.getElementById('content')
# <img src={Image.getFullPath detail?.carPic, Constants.carPicSize} />