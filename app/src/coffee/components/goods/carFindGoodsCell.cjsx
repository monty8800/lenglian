require 'components/common/common'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

Plugin = require 'util/plugin'

GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'

avatar = require 'user-01'


CarFindGoodsCell = React.createClass {
	mixins: [PureRenderMixin]
	componentDidMount: ->
		GoodsStore.addChangeListener @_change

	componentWillUnmount: ->
		GoodsStore.removeChangeListener @_change

	_change: (msg)->
		console.log 'event change ', msg

	_showWidget: ->
		GoodsAction.changeWidgetStatus(true)

	render: ->
		console.log 'state---', @state
		<div className="m-item01 m-item03">
			<div className="g-item-dirver">
				<div className="g-dirver">					
					<div className="g-dirver-pic">
						<img src={avatar} />
					</div>
					<div className="g-dirver-msg">
						<div className="g-dirver-name">
							<span>司机名</span><span className="g-dirname-single">(个体)</span>
						</div>
						<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
					</div>
					<div onClick={@_showWidget} className="g-dirver-btn">
						<a href="#" className="u-btn03">抢单</a>
					</div>
				</div>
			</div>
			<div className="g-item">
				
				<div className="g-adr-start ll-font g-adr-start-line">
					黑龙江鹤岗市向阳区
				</div>
				<div className="g-adr-end ll-font g-adr-end-line">
					山西太原市矿区
				</div>
			</div>
			
			<div className="g-item g-item-des">
				<p>车辆描述 : <span>10米</span><span>高栏</span></p>
			</div>
		</div>
}


module.exports = CarFindGoodsCell


