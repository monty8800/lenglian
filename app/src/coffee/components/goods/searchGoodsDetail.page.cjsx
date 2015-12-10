require 'components/common/common'
require 'user-center-style'
require 'app-style'

React = require 'react/addons'
Immutable = require 'immutable'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
XeImage = require 'components/common/xeImage'
UserStore = require 'stores/user/user'

Helper = require 'util/helper'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'
Moment = require 'moment'
GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'
Goods = require 'model/goods'
DB = require 'util/storage'
Raty = require 'components/common/raty'
_user = UserStore.getUser()
_transData = DB.get 'transData'

Auth = require 'util/auth'


GoodsRoutes = React.createClass {
	render : ->
		items = @props.list.map (item,i)->
			<div style={display:"block"} className="g-adr-middle ll-font">
				{ if item.provinceName is item.cityName then item.provinceName + item.areaName + item.street else  item.provinceName + item.cityName + item.areaName + item.street }					
			</div>
		,this
		<div>
			{items}
		</div>
}


GoodsDetail = React.createClass {
	getInitialState: ->
		{
			goodsDetail:{
				mjGoodsRoutes:[]
				toProvinceName:''
				toCityName:''
				toAreaName:''
				toStreet:''
				fromProvinceName:''
				toCityName:''
				toAreaName:''
				toStreet:''
			}
			isFallow:false
			hideFallow:true
		}

	componentDidMount: ->
		GoodsStore.addChangeListener @_onChange
		GoodsAction.getSearchGoodsDetail _transData.goodsId,_transData.focusid

	componentWillUnmount: ->
		GoodsStore.removeChangeListener @_onChange

# mjGoodsRoutes
	_onChange: (mark)->
		if mark is 'getSearchGoodsDetailSucc'
			newState = Object.create @state
			newState.goodsDetail = GoodsStore.getSearchGoodsDetail()
			newState.isFallow = newState.goodsDetail.wishlst
			newState.hideFallow = newState.goodsDetail?.userId is _user.id
			@setState newState
		else if mark is 'fallowOrUnFallowHandleSucc'
			newState = Object.create @state
			newState.isFallow = !@state.isFallow
			Plugin.toast.success if newState.isFallow then '关注成功' else '取消关注成功'
			@setState newState

	_fallowButtonClick:->
		#       (1)focusid 		(2)focustype 关注类型 1:货主 2：司机 3：仓库		(3) 2取消 1添加
		type = if @state.isFallow then 2 else 1
		GoodsAction.handleFallow _transData.focusid,1,type

	_makePhoneCall:(phone)->
		if parseInt(_user.certification) is 0
			Plugin.toast.err '认证后方可拨号'
		else 
			if phone
				window.location.href = 'tel:' + phone
	_showWidget: (e)->
		goods = @state.goodsDetail
		flag = _transData.flag
		Auth.needLogin ->
			Auth.needAuth flag,->
				return Plugin.toast.err '不能选择自己的货源哦' if goods.userId is UserStore.getUser()?.id
				Plugin.run [3, 'select:' + flag, goods.id, if parseInt(goods.priceType) isnt 1 then true else false]
		e.stopPropagation()

	render : ->
		console.log 'state', @state
		toColdFlag = if parseInt(@state.goodsDetail.refrigeration) in [4, 3] then '（需要冷库）' else ''
		fromColdFlag = if parseInt(@state.goodsDetail.refrigeration) in [4, 2] then '（需要冷库）' else '' 

		_payTypeText = Helper.payTypeMapper @state.goodsDetail.payType
		# if parseInt(@state.goodsDetail.payType) is 3 and @state.goodsDetail.prePay
		# 	_payTypeText = _payTypeText + @state.goodsDetail.prePay + '元'
		
		<div>
			<div style={{display: if _transData?.orderId then 'block' else 'none'}} className="m-orderdetail clearfix">
				<p className="fl">订单号：<span>{ _transData?.orderId }</span></p>
				<p className="fr">{ _transData?.orderStatus }</p>
			</div>
			<div className="m-item01">
				<div className="g-detail-dirver">
					<div className="g-detail">					
						<div className="g-dirver-pic">
							<XeImage src={ @state.goodsDetail.userHeaderImageUrl } size='130x130' type='avatar'/>
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ @state.goodsDetail.userName }</span><span className="g-dirname-single">{ Helper.whoYouAreMapper @state.goodsDetail.certification  }</span>
							</div>
							<div className="g-dirver-dis ll-font">
								<Raty score={ @state.goodsDetail.stars }/>
							</div>
						</div>
						<ul style={{ display: if @state.hideFallow then 'none' else 'block' }} className="g-driver-contact" onClick={ @_fallowButtonClick }>
							<li className={ if @state.isFallow then "ll-font noborder" else "ll-font active noborder" }>关注</li>
						</ul>
					</div>
				</div>
				<div className="g-item g-adr-detail ll-font nopadding">			
					<div className="g-adr-start ll-font g-adr-start-line">
						{
							if @state.goodsDetail.toProvinceName is @state.goodsDetail.toCityName
								<em>{(@state.goodsDetail.toCityName + @state.goodsDetail.toAreaName + @state.goodsDetail.toStreet) + toColdFlag}</em>
							else
								<em>{(@state.goodsDetail.toProvinceName + @state.goodsDetail.toCityName + @state.goodsDetail.toAreaName + @state.goodsDetail.toStreet) + toColdFlag}</em>
						}
						<span></span>
					</div>
					{
						if @state.goodsDetail.mjGoodsRoutes.length > 0	
							<GoodsRoutes list={ @state.goodsDetail.mjGoodsRoutes } />
					}
					<div className="g-adr-end ll-font g-adr-end-line">
						{
							if @state.goodsDetail.fromProvinceName is @state.goodsDetail.fromCityName
								<em>{@state.goodsDetail.fromCityName + @state.goodsDetail.fromAreaName + @state.goodsDetail.fromStreet + fromColdFlag}</em>
							else
								<em>{@state.goodsDetail.fromProvinceName + @state.goodsDetail.fromCityName + @state.goodsDetail.fromAreaName + @state.goodsDetail.fromStreet + fromColdFlag}</em>
						}
						<span></span>
					</div>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-detail-time01">
					<span className="fl">装货时间:</span>
					<span className="fr">
						{ Moment(@state.goodsDetail.installStime).format('YYYY-MM-DD') } 到 { Moment(@state.goodsDetail.installEtime).format('YYYY-MM-DD') }
					</span>
				</div>
				{
					if @state.goodsDetail.arrivalStime
						<div className="g-detail-time01">
							<span className="fl">到货时间:</span>
							<span className="fr">
								{ Moment(@state.goodsDetail.arrivalStime).format('YYYY-MM-DD') } 到 { Moment(@state.goodsDetail.arrivalEtime).format('YYYY-MM-DD') }
							</span>
						</div>	
				}

			</div>
			<div className="m-item01">
				<div className="g-pro-p">
					<p className="g-pro-name">货物名称: <span>{ @state.goodsDetail.name}</span></p>
				</div>
				<div className="g-pro-detail clearfix">
					<div className="g-pro-pic fl">
						<XeImage src={ @state.goodsDetail.imageUrl } size='200x200' />
					</div>
					<div className="g-pro-text fl">
						<p>货物规格: <span>{ if @state.goodsDetail.weight then @state.goodsDetail.weight + '吨' else ''} { if @state.goodsDetail.cube then @state.goodsDetail.cube + '方' else ''}</span></p>
						<p>货物类型: <span>{ Helper.goodsType @state.goodsDetail.goodsType }</span></p>
						<p>包装类型: <span>{ @state.goodsDetail.packType }</span></p>
					</div>
				</div>
			</div>

			<div className="m-detail-info m-nomargin padding86">			
				<p>
					<span>发货人:</span>
					<span onClick={ @_makePhoneCall.bind this, @state.goodsDetail.senderMobile } className="ll-font g-info-name">{ @state.goodsDetail.sender }</span>
				</p>
				{
					if @state.goodsDetail.receiver
						<p>
							<span>收货人:</span>
							<span onClick={ @_makePhoneCall.bind this, @state.goodsDetail.receiverMobile } className="ll-font g-info-name">{ @state.goodsDetail.receiver }</span>
						</p>					
				}

				<p>
					<span>价格类型:</span>
					<span>{ Helper.priceTypeMapper @state.goodsDetail.priceType } { if  @state.goodsDetail.price then @state.goodsDetail.price + '元' else ''}</span>
				</p>
				<p>
					<span>支付方式:</span>
					<span>{ _payTypeText }</span>
				</p>
				<p>
					<span>发票:</span>
					<span>{ Helper.invoiceStatus @state.goodsDetail.invoice }</span>
				</p>
				{
					if @state.goodsDetail?.remark 
						<p>
							<span>备注:</span>
							<span>{ @state.goodsDetail?.remark }</span>
						</p>
				}			
			</div>
			<div className="m-detail-bottom">
				<p onClick={@_showWidget} className="btn-choose">{if parseInt(@state.goodsDetail.priceType) is 2 then '竞价' else '抢单'}</p>
			</div>
		</div>
}

React.render <GoodsDetail />,document.getElementById('content')
