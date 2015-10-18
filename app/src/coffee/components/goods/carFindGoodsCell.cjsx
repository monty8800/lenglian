require 'components/common/common'

React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

Plugin = require 'util/plugin'

Helper = require 'util/helper'

avatar = require 'user-01'

moment = require 'moment'

XeImage = require 'components/common/xeImage'

Raty = require 'components/common/raty'

UserStore = require 'stores/user/user'
Auth = require 'util/auth'

DB = require 'util/storage'

CarFindGoodsCell = React.createClass {
	mixins: [PureRenderMixin]

	_showWidget: (e)->
		#js，改用原生的弹窗就用不到了
		# GoodsAction.changeWidgetStatus(true, @props.bid)
		#goodsid，是否是竞价
		Auth.needLogin ->
			return Plugin.toast.err '尚未通过车主认证，请认证后再试' if UserStore.getUser()?.carStatus isnt 1
			Plugin.run [3, 'select:car', @props.goods.get('id'), if @props.goods.get('priceType') isnt '1' then true else false]
		e.stopPropagation()

	_goodsDetail: ->
		DB.put 'transData', {
			goodsId: @props.goods.get 'id'
			focusid: @props.goods.get 'userId'
		}
		Plugin.nav.push ['searchGoodsDetail']

	render: ->
		console.log 'goods---', @props.goods.get 'certificAtion'
		installStime = @props.goods.get('installStime')
		installEtime = @props.goods.get('installEtime')
		userAvatar = @props.goods.get 'userImgUrl'
		<div onClick={@_goodsDetail} className="m-item01 m-item03">
			<div className="g-item-dirver">
				<div className="g-dirver">					
					<div className="g-dirver-pic">
						<XeImage src={userAvatar} size='130x130' type='avatar' />
					</div>
					<div className="g-dirver-msg">
						<div className="g-dirver-name">
							<span>{@props.goods.get 'userName'}</span><span className="g-dirname-single">{if @props.goods.get('certificAtion') is '1' then '(个体)' else '(公司)'}</span>
						</div>
						<div className="g-dirver-dis ll-font"><Raty score={@props.goods.get 'userScore'} canRate=false /></div>
					</div>
					<div onClick={@_showWidget} className="g-dirver-btn">
						<a className="u-btn03">{if @props.goods.get('priceType') isnt '1' then '竞价' else '抢单'}</a>
					</div>
				</div>
			</div>
			<div className="g-item">
				
				<div className="g-adr-start ll-font g-adr-start-line">
					{@props.goods.get('toProvinceName') + @props.goods.get('toCityName') + @props.goods.get('toAreaName')}
				</div>
				<div className="g-adr-end ll-font g-adr-end-line">
					{@props.goods.get('fromProvinceName') + @props.goods.get('fromCityName') + @props.goods.get('fromAreaName')}
				</div>
			</div>
			
			<div className="g-item g-item-des">
				<p>货物描述 : <span>{@props.goods.get 'name'}</span><span>{Helper.goodsType @props.goods.get('goodsType')}</span><span>{@props.goods.get('weight') + '吨'}</span></p>
				<p>装货时间 : <span>{moment(installStime).format('YYYY-MM-DD')}</span><span>到</span><span>{moment(installEtime).format('YYYY-MM-DD')}</span></p>
				{
					if @props.goods.get('priceType') is '1'
						<p>价格类型 : <span>一口价</span><span>{@props.goods.get('price') or '0' + '元'}</span></p>
				}
				
			</div>
		</div>
}


module.exports = CarFindGoodsCell


