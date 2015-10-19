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
GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'
Goods = require 'model/goods'
DB = require 'util/storage'
Raty = require 'components/common/raty'

_transData = DB.get 'transData'


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
			@setState newState
		else if mark is 'fallowOrUnFallowHandleSucc'
			newState = Object.create @state
			newState.isFallow = !@state.isFallow
			Plugin.toast.success if newState.isFallow then '关注成功' else '取消关注成功'
			@setState newState

	_fallowButtonClick:->
		#       (1)focusid 		(2)focustype 关注类型 1:司机 2：货主 3：仓库		(3) 2取消 1添加
		type = if @state.isFallow then 2 else 1
		GoodsAction.handleFallow _transData.focusid,2,type


	render : ->
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
						<ul className="g-driver-contact" onClick={ @_fallowButtonClick }>
							<li className={ if @state.isFallow then "ll-font noborder" else "ll-font active noborder" }>关注</li>
						</ul>
					</div>
				</div>
				<div className="g-item g-adr-detail ll-font nopadding">			
					<div className="g-adr-start ll-font g-adr-start-line">
						{
							if @state.goodsDetail.toProvinceName is @state.goodsDetail.toCityName
								(@state.goodsDetail.toCityName + @state.goodsDetail.toAreaName + @state.goodsDetail.toStreet)
							else
								(@state.goodsDetail.toProvinceName + @state.goodsDetail.toCityName + @state.goodsDetail.toAreaName + @state.goodsDetail.toStreet)
						}
					</div>
					{
						if @state.goodsDetail.mjGoodsRoutes.length > 0	
							<GoodsRoutes list={ @state.goodsDetail.mjGoodsRoutes } />
					}
					<div className="g-adr-end ll-font g-adr-end-line">
						{
							if @state.goodsDetail.fromProvinceName is @state.goodsDetail.fromCityName
								@state.goodsDetail.fromCityName + @state.goodsDetail.fromAreaName + @state.goodsDetail.fromStreet
							else
								@state.goodsDetail.fromProvinceName + @state.goodsDetail.fromCityName + @state.goodsDetail.fromAreaName + @state.goodsDetail.fromStreet
						}
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
				<div className="g-pro-detail">
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

			<div className="m-detail-info m-nomargin">			
				<p>
					<span>发货人:</span>
					<span className="ll-font g-info-name">{ @state.goodsDetail.sender }</span>
				</p>
				{
					if @state.goodsDetail.receiver
						<p>
							<span>收货人:</span>
							<span className="ll-font g-info-name">{ @state.goodsDetail.receiver }</span>
						</p>					
				}

				<p>
					<span>价格类型:</span>
					<span>{ Helper.priceTypeMapper @state.goodsDetail.priceType } { @state.goodsDetail.price}</span>
				</p>
				<p>
					<span>支付方式:</span>
					<span>{ Helper.payTypeMapper @state.goodsDetail.payType }</span>
				</p>
				<p>
					<span>发票:</span>
					<span>{ Helper.invoiceStatus @state.goodsDetail.invoice }</span>
				</p>			
			</div>
		</div>
}

React.render <GoodsDetail />,document.getElementById('content')


