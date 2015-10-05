require 'components/common/common'
require 'index-style'
require 'majia-style'

React = require 'react/addons'

headerImg = require 'user-01.jpg'
WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

Plugin = require 'util/plugin'

SearchWarehouse = React.createClass {
	getInitialState: ->
		{
			searchResult:[]
			userGoodsSource:['1','2']
			showTypeSelect:0
			showTempreatureSelect:0
			showInvoiceSelect:0
			showGoodsListMenu:0
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		WarehouseAction.searchWarehouse '0','10'
		
	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_onChange: (mark)->
		console.log "#!!!!!!!!!!  " + WarehouseStore.getWarehouseSearchResult()
		if mark is "searchWarehouse"
			@setState { 
				searchResult:WarehouseStore.getWarehouseSearchResult()
				showTypeSelect:0
				showTempreatureSelect:0
				showInvoiceSelect:0
				showGoodsListMenu:0
			}

	typeChooseCkick: ->
		newState = Object.create @state
		if @state.showTypeSelect is 1 then newState.showTypeSelect = 0 else newState.showTypeSelect = 1
		@setState newState
		console.log @state.showTypeSelect + "__ \\\\\\\\\\"

	tempreatureSelectCkick: ->
		newState = Object.create @state
		if @state.showTempreatureSelect is 1 then newState.showTempreatureSelect = 0 else newState.showTempreatureSelect = 1
		@setState newState

	invoiceSelectCkick:->
		newState = Object.create @state
		if @state.showInvoiceSelect is 1 then newState.showInvoiceSelect = 0 else newState.showInvoiceSelect = 1
		@setState newState

	sureButtonClick:->
		WarehouseAction.searchWarehouse '0','10'


	selectWarehouse :(index) ->
		# if @state.userGoodsSource.length < 1
		# 	Plugin.toast.show '没有货源适合这个仓库'
		# 	return
		newState = Object.create @state
		newState.showGoodsListMenu = 1
		@setState newState
	selectGoods :(index) ->

		newState = Object.create @state
		newState.showGoodsListMenu = 0 
		@setState newState

	render: ->
		searchResultList = @state.searchResult.map (aResult, i)->
			<div className="m-item01 m-item03">
				<div className="g-item-dirver">
					<div className="g-dirver">					
						<div className="g-dirver-pic">
							<img src={ headerImg }/>
						</div>
						<div className="g-dirver-msg">
							<div className="g-dirver-name">
								<span>{ aResult.name }</span><span className="g-dirname-single">(个体)</span>
							</div>
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<a onClick={ @selectWarehouse.bind this,i} className="u-btn02">选择该仓库</a>
						</div>
					</div>
				</div>
				<div className="g-item">
					<div className="g-adr-store ll-font">
						{ 
							if aResult.provinceName is aResult.cityName
								aResult.provinceName + aResult.areaName + aResult.street 
							else
								aResult.provinceName + aResult.cityName + aResult.areaName + aResult.street 
						}
					</div>
				</div>
				<div className="g-item g-pad ll-font">
					价格类型 : 竞价
					<span>( 柠静  4999元 )</span>
				</div>
				<div className="g-item g-item-des">
					<p>仓库类型 : <span>{ aResult.wareHouseType }</span></p>
					<p>库温类型 : <span>{ aResult.cuvinType }</span></p>
					<p>仓库价格 : <span>{ aResult.price }</span></p>
				</div>
			</div>
		, this

		goodsLists = @state.userGoodsSource.map (aResult, i)->
			<div className="u-content" onClick={@selectGoods.bind this,i}>
				<div className="u-content-item ll-font">
					<div className="u-address">
						<div className="g-adr-start ll-font g-adr-start-line">
							黑龙江鹤岗市向阳区
						</div>
						<div className="g-adr-end ll-font g-adr-end-line">
							山西太原市矿区123456
						</div>
					</div>
					<p>价格类型:一口价 4000元</p>
					<p>货物描述:小鲜肉 1吨 冷鲜肉</p>
				</div>
			</div>
		,this

		<div>
			<div className="m-nav03">
				<ul>
					<li>
						<div className={ if @state.showTypeSelect is 1 then "g-div01 ll-font u-arrow-right g-div01-act" else "g-div01 ll-font u-arrow-right" } onClick={ @typeChooseCkick }>
							<div dangerouslySetInnerHTML={{__html: "仓库类型"}}/>
							<span>全部</span>
						</div>
						<div className="g-div02" style={ if @state.showTypeSelect is 1 then {display:'block'} else {display:'none'} }>
							<div className="g-div02-item">
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "全部"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "3.8米"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "4.2米"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "4.8米"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "5.8米"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "6.2米"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "6.8米"}}/></label>
							</div>
							<div className="g-div02-btn" onClick={ @sureButtonClick }>
								<a className="u-btn u-btn-small">确定</a>
							</div>
						</div>
					</li>
					<li>
						<div className={ if @state.showTempreatureSelect is 1 then "g-div01 ll-font u-arrow-right g-div01-act" else "g-div01 ll-font u-arrow-right" } onClick={ @tempreatureSelectCkick }>
							<div dangerouslySetInnerHTML={{__html: "库温类型"}}/>
							<span>全部</span>
						</div>
						<div className="g-div02" style={ if @state.showTempreatureSelect is 1 then {display:'block'} else {display:'none'} }>
							<div className="g-div02-item">
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "全部"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "-100"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "-50"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "-20"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "0"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "20"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "30"}}/></label>
							</div>
							<div className="g-div02-btn">
								<a className="u-btn u-btn-small">确定</a>
							</div>
						</div>
					</li>
					<li>
						<div className={ if @state.showInvoiceSelect is 1 then "g-div01 ll-font u-arrow-right g-div01-act" else "g-div01 ll-font u-arrow-right" } onClick={ @invoiceSelectCkick }>
							<div dangerouslySetInnerHTML={{__html: "需要发票"}}/>
							<span>全部</span>
						</div>
						<div className="g-div02" style={ if @state.showInvoiceSelect is 1 then {display:'block'} else {display:'none'} }>
							<div className="g-div02-item">
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "不需要"}}/></label>
								<label className="u-label">
									<input className="ll-font" type="checkbox"/>
									<div dangerouslySetInnerHTML={{__html: "需要"}}/></label>
							</div>
						</div>
					</li>
				</ul>			
			</div>
			{ searchResultList }
			<div className={ if @state.showGoodsListMenu is 1 then "u-pop-box u-show" else "u-pop-box" }>
				{ goodsLists }
			</div>
			<div className={ if @state.showGoodsListMenu is 1 then "u-mask-grid show" else "u-mask-grid" }></div>

		</div>
}

React.render <SearchWarehouse />, document.getElementById('content')


