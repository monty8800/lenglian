require 'components/common/common'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

XeImage = require 'components/common/xeImage'

Moment = require 'moment'

Helper = require 'util/helper'

OrderStore = require 'stores/order/order'

OrderAction = require 'actions/order/order'

UserStore = require 'stores/user/user'

transData = DB.get 'transData'

GoodsOrderDetail = React.createClass {
	componentDidMount: ->
		OrderStore.addChangeListener @resultCallBack
		OrderAction.goodsOrderDetail {
			userId: UserStore.getUser()?.id
			orderNo: transData?.orderNo
		}

	componentWillNotMount: ->
		OrderStore.removeChangeListener @resultCallBack

	resultCallBack: (params)->
		console.log 'event change', params
		if params.msg is 'goods:order:detail:done'
			@setState {
				detail: params.detail.toJS()
			}

	getInitialState: ->
		{
			detail: null
		}

	render : ->
		<section>
		<div className="m-orderdetail clearfix">
			<p className="fl">订单号：<span>{@state.detail?.orderNo}</span></p>
			<p className="fr">等待货主付款</p>
		</div>

		<div className="m-item01">
			<div className="g-detail-dirver">
				<div className="g-detail">					
					<div className="g-dirver-pic">
						<XeImage src={@state.detail?.carUserHeadPic} size='130x130' type='avatar' />
					</div>
					<div className="g-dirver-msg">
						<div className="g-dirver-name">
							<span>{@state.detail?.carUserName}</span><span className="g-dirname-single">(个体)</span>
						</div>
						<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
					</div>
					<ul className="g-driver-contact">
						<li className="ll-font">关注</li>
						<li className="ll-font">拨号</li>
					</ul>
				</div>
			</div>
			<div className="g-item g-adr-detail ll-font nopadding">			
				<div className="g-adr-start ll-font g-adr-start-line">
					{@state.detail?.fromProvinceName + @state.detail?.fromCityName + @state.detail?.fromCountyName}
				</div>
				
				<div className="g-adr-end ll-font g-adr-end-line">
					{@state.detail?.toProvinceName + @state.detail?.toCityName + @state.detail?.toCountyName}
				</div>	
			</div>
		</div>
		<div className="m-item01">
			<div className="g-detail-time01">
				<span className="fl">装货时间:</span>
				<span className="fr">
					{Moment(@state.detail?.loadingSdate).format('YYYY-MM-DD') + ' 到 ' + Moment(@state.detail?.loadingEdate).format('YYYY-MM-DD')}
				</span>
			</div>
			<div className="g-detail-time01">
				<span className="fl">到货时间:</span>
				<span className="fr">
					{Moment(@state.detail?.arrivalSdate).format('YYYY-MM-DD') + ' 到 ' + Moment(@state.detail?.arrivalEdate).format('YYYY-MM-DD')}
				</span>
			</div>
		</div>
		<div className="m-item01">
			<div className="g-pro-p">
				<p className="g-pro-name">货物名称: <span>{@state.detail?.goodsName}</span></p>
			</div>
			<div className="g-pro-detail">
				<div className="g-pro-pic fl">
					<XeImage src={@state.detail?.goodsPic} />
				</div>
				<div className="g-pro-text fl">
					<p>货物种类: <span>{@state.detail?.goodsType}</span></p>
					<p>货物重量: <span>{@state.detail?.goodsWeight + '吨'}</span></p>
					<p>包装类型: <span>{@state.detail?.goodsPackingType}</span></p>
				</div>
			</div>
		</div>
		<div className="m-detail-info">			
			<p>
				<span>发货人:</span>
				<span className="ll-font g-info-name">{@state.detail?.receiver}</span>
			</p>
			<p>
				<span>收货人:</span>
				<span className="ll-font g-info-name">{@state.detail?.shipper}</span>
			</p>
			<p>
				<span>价格类型:</span>
				<span>{(if parseInt(@state.detail?.priceType) is 1 then '一口价' else '竞价') + @state.detail?.price + '元'}</span>
			</p>
			<p>
				<span>支付方式:</span>
				<span>{Helper.payTypeMapper @state.detail?.payType}</span>
			</p>
			<p>
				<span>发票:</span>
				<span>{Helper.isInvoinceMap @state.detail?.isInvoince}</span>
			</p>
			<p>
				<span>发布时间:</span>
				<span>{@state.detail?.createTime}</span>
			</p>			
		</div>
		<div className="m-detail-bottom">
			<div className="g-pay-btn">
				<a className="u-btn02">确认付款</a>
			</div>
		</div>
		</section>
}

React.render <GoodsOrderDetail />,document.getElementById('content')