require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
Immutable = require 'immutable'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
XeImage = require 'components/common/xeImage'

Helper = require 'util/helper'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'
Moment = require 'moment'
UserStore = require 'stores/user/user'

GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'
Goods = require 'model/goods'
DB = require 'util/storage'
_user = UserStore.getUser()

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
			}
		}

	componentDidMount: ->
		GoodsStore.addChangeListener @_onChange
		goodsId = DB.get 'transData'
		GoodsAction.getGoodsDetail goodsId
	componentWillUnmount: ->
		GoodsStore.removeChangeListener @_onChange

# mjGoodsRoutes
	_onChange: (mark)->
		if mark is 'getGoodsDetailSucc'
			newState = Object.create @state
			newState.goodsDetail = GoodsStore.getGoodsDetail()
			@setState newState
		else if mark is 'deleteGoodsSucc'
			Plugin.toast.success '删除成功'
			Plugin.nav.pop()

	_deleteCurrentGoods: ->
		toDeleteGoodsId = @state.goodsDetail.id
		Plugin.alert '确定删除吗', '提示', (index)->
			if index is 1
				GoodsAction.deleteGoods toDeleteGoodsId
		, ['确定', '取消']

	_makePhoneCall:(phone)->
		if parseInt(_user.certification) is 0
			Plugin.toast.err '认证后可见'
		else 
			if phone
	  			window.location.href = 'tel:' + phone


	render : ->
		console.log 'state', @state
		toColdFlag = if parseInt(@state.goodsDetail.refrigeration) in [4, 3] then '（需要冷库）' else ''
		fromColdFlag = if parseInt(@state.goodsDetail.refrigeration) in [4, 2] then '（需要冷库）' else ''

		_payTypeText = Helper.payTypeMapper @state.goodsDetail.payType
		if parseInt(@state.goodsDetail.payType) is 3 and @state.goodsDetail.prePay
			_payTypeText = _payTypeText + @state.goodsDetail.prePay + '元'
		<div>
			<div className="m-item01">
				<div className="g-item g-adr-detail ll-font nopadding">			
					<div className="g-adr-start ll-font g-adr-start-line">
						{
							if @state.goodsDetail.toProvinceName is @state.goodsDetail.toCityName
								<em>{(@state.goodsDetail.toCityName or '') + (@state.goodsDetail.toAreaName or '') + (@state.goodsDetail.toStreet or '') + toColdFlag}</em>
							else
								<em>{(@state.goodsDetail.toProvinceName or '') + (@state.goodsDetail.toCityName or '') + (@state.goodsDetail.toAreaName or '') + (@state.goodsDetail.toStreet or '') + toColdFlag}</em>
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
								<em>{(@state.goodsDetail.fromCityName or '') + (@state.goodsDetail.fromAreaName or '') + (@state.goodsDetail.fromStreet or '') + fromColdFlag}</em>
							else
								<em>{(@state.goodsDetail.fromProvinceName or '') + (@state.goodsDetail.fromCityName or '') + (@state.goodsDetail.fromAreaName or '') + (@state.goodsDetail.fromStreet or '') + fromColdFlag}</em>
						}
						<span></span>
					</div>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-detail-time01">
					<span className="fl">装货时间:</span>
					<span className="fr">
						{
							if @state.goodsDetail.installStime and @state.goodsDetail.installEtime
								Moment(@state.goodsDetail.installStime).format('YYYY-MM-DD') + '到' +  Moment(@state.goodsDetail.installEtime).format('YYYY-MM-DD') 
						}
					</span>
				</div>
				{
					if @state.goodsDetail.arrivalStime
						<div className="g-detail-time01">
							<span className="fl">到货时间:</span>
							<span className="fr">
								{ Moment(@state.goodsDetail.arrivalStime).format('YYYY-MM-DD') + '到' + Moment(@state.goodsDetail.arrivalEtime).format('YYYY-MM-DD') }
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
						<p>货物类型: <span>{ Helper.goodsType @state.goodsDetail.goodsType }</span></p>
						<p>货物规格: <span>{ if @state.goodsDetail.weight then @state.goodsDetail.weight + '吨' } { if @state.goodsDetail.cube then @state.goodsDetail.cube + '方'}</span></p>
						<p>包装类型: <span>{ @state.goodsDetail.packType }</span></p>
					</div>
				</div>
			</div>
			<div className="m-detail-info">			
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
					<span>{ Helper.priceTypeMapper @state.goodsDetail.priceType }  { if  @state.goodsDetail.price then @state.goodsDetail.price + '元' else ''}</span>
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
					if @state.goodsDetail.remark
						<p>
							<span>备注:</span>
							<span>{ @state.goodsDetail.remark }</span>
						</p>	
				}
			</div>
			{
				if parseInt(@state.goodsDetail.resourceStatus) is 1
					<div className="m-detail-bottom">
						<div className="g-pay-btn">
							<a onClick={ @_deleteCurrentGoods } className="u-btn02">删除货源</a>
						</div>
					</div>	
			}
		</div>
}

React.render <GoodsDetail />,document.getElementById('content')


