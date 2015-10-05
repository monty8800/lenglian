require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
Immutable = require 'immutable'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
GoodsImage = require 'user-01.jpg'

Helper = require 'util/helper'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'

GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'
Goods = require 'model/goods'
DB = require 'util/storage'

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


	render : ->
		<div>
			<div className="m-item01">
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
						{ @state.goodsDetail.installStime } 到 { @state.goodsDetail.installEtime}
					</span>
				</div>
				<div className="g-detail-time01">
					<span className="fl">到货时间:</span>
					<span className="fr">
						{ @state.goodsDetail.arrivalStime} 到 { @state.goodsDetail.arrivalEtime}
					</span>
				</div>
			</div>
			<div className="m-item01">
				<div className="g-pro-p">
					<p className="g-pro-name">货物名称: <span>{ @state.goodsDetail.name}</span></p>
				</div>
				<div className="g-pro-detail">
					<div className="g-pro-pic fl">
						<img src="../images/product-01.jpg"/>
					</div>
					<div className="g-pro-text fl">
						<p>货物种类: <span>冷鲜肉</span></p>
						<p>货物要求: <span>冷藏</span></p>
						<p>货物重量: <span>{ @state.goodsDetail.weight }</span></p>
						<p>包装类型: <span>{ @state.goodsDetail.packType }</span></p>
					</div>
				</div>
			</div>
			<div className="m-detail-info">			
				<p>
					<span>发货人:</span>
					<span className="ll-font g-info-name">{ @state.goodsDetail.sender }</span>
				</p>
				<p>
					<span>收货人:</span>
					<span className="ll-font g-info-name">{ @state.goodsDetail.reciver }</span>
				</p>
				<p>
					<span>价格类型:</span>
					<span>{ Helper.priceTypeMapper @state.goodsDetail.priceType } { @state.goodsDetail.price}</span>
				</p>
				<p>
					<span>支付方式:</span>
					<span>{ Helper.payTypeMapper @state.goodsDetail.payType } {'预付款金额$$'} </span>
				</p>
				<p>
					<span>发票:</span>
					<span>{ Helper.invoiceStatus @state.goodsDetail.invoice }</span>
				</p>			
			</div>
			<div className="m-detail-bottom">
				<div className="g-pay-btn">
					<a href="#" className="u-btn02">删除货源</a>
				</div>
			</div>	
		</div>
}

React.render <GoodsDetail />,document.getElementById('content')


