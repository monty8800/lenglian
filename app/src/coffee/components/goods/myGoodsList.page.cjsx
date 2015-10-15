require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
Immutable = require 'immutable'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

Helper = require 'util/helper'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'
XeImage = require 'components/common/xeImage'

GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'
Goods = require 'model/goods'
DB = require 'util/storage'


GoodsListItem = React.createClass {
	_toGoodsDetail: (index) ->
		goodsId = @props.list[index].id
		DB.put 'transData',goodsId
		Plugin.nav.push ['goodsDetail']

	render : ->
		listItem = @props.list.map (item, i) ->
			<div className="m-item03" onClick={ @_toGoodsDetail.bind this,i }>
				<div className="g-itemList">
					<h5>
						货物名称: <span>{ item.name }</span>				
					</h5>
					<div className="u-item-btn">
						<span href="#">{ Helper.goodsStatus item.resourceStatus }</span>
					</div>
						
				</div>			
				<div className="g-itemList g-item g-adr-detail ll-font">			
					<div className="g-adr-start ll-font g-adr-start-line">
						{
							if item.toProvinceName is item.toCityName
								item.toCityName + item.toAreaName + item.toStreet
							else
								item.toProvinceName + item.toCityName + item.toAreaName + item.toStreet
						}
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						{
							if item.fromProvinceName is item.fromCityName
								item.fromCityName + item.fromAreaName + item.fromStreet
							else
								item.fromProvinceName + item.fromCityName + item.fromAreaName + item.fromStreet
						}
					</div>
				</div>			
				<div className="g-itemList">
					<dl className="clearfix">
						<dt className=" fl">
							<XeImage src={ item.imageUrl } size='200x200' />
						</dt>
						<dd className=" fl">
							<p>货物类型: <span>{ Helper.goodsType item.goodsType }</span></p>
							<p>货物规格: <span>{ if item.weight then item.weight + '吨' } { if item.cube then item.cube + '方' }</span></p>
							<p>包装类型: <span>{ item.packType }</span></p>
						</dd>
					</dl>			
				</div>
			</div>
		,this
		<div>
			{ listItem }
		</div>
}


GoodsList = React.createClass {
	getInitialState:->
		{
			showType:0  		# 1 货源状态  2 价格类型  3 发布日期
			shouldShowMenu:0 # 1 货源菜单  2 价格菜单  3 发布日期菜单
			selectedMenu1: 0 # 按资源状态 1 全部 2 求车种 3 有人响应 4 已成交
			selectedMenu2: 0 # 按价格类型 1 高价 2 中价  3 低价
			selectedMenu3: 0 # 按发布类型 1 近一周 2 近两周  3 近一月
			goodsList:[]
		}

	componentDidMount: ->
		GoodsStore.addChangeListener @_onChange
		GoodsAction.getGoodsList 1,10,''		#pageNow pageSize status   userId在store中传
	componentWillUnmount: ->
		GoodsStore.removeChangeListener @_onChange

	_onChange: (mark)->
		if mark is 'getUserGoodsListSucc'
			newState = Object.create @state
			newState.goodsList = GoodsStore.getMyGoodsList()		
			@setState newState
	

	_topTypeClick : (index)->
		newState = Object.create @state
		if index is @state.showType
			newState.shouldShowMenu = 0
			newState.showType = 0
		else
			newState.shouldShowMenu = index
			newState.showType = newState.shouldShowMenu
		@setState newState


	_subMenu1Click :(index) ->
		if @state.selectedMenu1 is index
			return
		newState = Object.create @state
		newState.selectedMenu1 = index
		newState.shouldShowMenu = 0
		@setState newState 
		Plugin.toast.show  "" + index + @state.selectedMenu2 + @state.selectedMenu3

		# 确定了筛选条件 开始筛选
		# GoodsAction.filter @state.selectedMenu1,@state.selectedMenu2,@state.selectedMenu3
	_subMenu2Click :(index) ->
		if @state.selectedMenu2 is index
			return
		newState = Object.create @state
		newState.selectedMenu2 = index
		newState.shouldShowMenu = 0
		@setState newState 

	_subMenu3Click :(index) ->
		if @state.selectedMenu3 is index
			return
		newState = Object.create @state
		newState.selectedMenu3 = index
		newState.shouldShowMenu = 0
		@setState newState 
	
		
	render : ->
		console.log 'state', @state
		<div>
			<div className="viewport">
				<div className="m-tab02">
					<ul>
						<li onClick={ @_topTypeClick.bind this,1 } className={ if @state.showType is 1 then "active ll-font u-arrow-right" else "ll-font u-arrow-right" }>货源状态</li>
						<li onClick={ @_topTypeClick.bind this,2 } className={ if @state.showType is 2 then "active ll-font u-arrow-right" else "ll-font u-arrow-right" }>价格类型</li>
						<li onClick={ @_topTypeClick.bind this,3 } className={ if @state.showType is 3 then "active ll-font u-arrow-right" else "ll-font u-arrow-right" }>发布日期</li>
					</ul>
				</div>
				<div style={display: if @state.shouldShowMenu is 1 then 'block' else 'none'} className="m-dropDown">
					<ul>
						<li onClick={ @_subMenu1Click.bind this,0 } className={ if @state.selectedMenu1 is 0 then "active" else "" } >全部</li>
						<li onClick={ @_subMenu1Click.bind this,1 } className={ if @state.selectedMenu1 is 1 then "active" else "" } >求车中</li>
						<li onClick={ @_subMenu1Click.bind this,2 } className={ if @state.selectedMenu1 is 1 then "active" else "" } >求库中</li>
						<li onClick={ @_subMenu1Click.bind this,3 } className={ if @state.selectedMenu1 is 2 then "active" else "" } >有人响应</li>
						<li onClick={ @_subMenu1Click.bind this,4 } className={ if @state.selectedMenu1 is 3 then "active" else "" } >已成交</li>
					</ul>
				</div>
				<div style={display: if @state.shouldShowMenu is 2 then 'block' else 'none'} className="m-dropDown">
					<ul>
						<li onClick={ @_subMenu2Click.bind this,0 } className={ if @state.selectedMenu2 is 0 then "active" else "" } >全部</li>
						<li onClick={ @_subMenu2Click.bind this,1 } className={ if @state.selectedMenu2 is 1 then "active" else "" } >竞价</li>
						<li onClick={ @_subMenu2Click.bind this,2 } className={ if @state.selectedMenu2 is 2 then "active" else "" } >一口价</li>
					</ul>
				</div>
				<div style={display: if @state.shouldShowMenu is 3 then 'block' else 'none'} className="m-dropDown">
					<ul>
						<li onClick={ @_subMenu3Click.bind this,0 } className={ if @state.selectedMenu3 is 0 then "active" else "" } >全部</li>
						<li onClick={ @_subMenu3Click.bind this,1 } className={ if @state.selectedMenu3 is 1 then "active" else "" } >一天内</li>
						<li onClick={ @_subMenu3Click.bind this,2 } className={ if @state.selectedMenu3 is 2 then "active" else "" } >三天内</li>
						<li onClick={ @_subMenu3Click.bind this,3 } className={ if @state.selectedMenu3 is 3 then "active" else "" } >五天内</li>
						<li onClick={ @_subMenu3Click.bind this,3 } className={ if @state.selectedMenu3 is 3 then "active" else "" } >一周内</li>
						<li onClick={ @_subMenu3Click.bind this,3 } className={ if @state.selectedMenu3 is 3 then "active" else "" } >两周内</li>
					</ul>
				</div>
				<GoodsListItem list={ @state.goodsList } />
			</div>
			<div style={display: if @state.shouldShowMenu isnt 0 then 'block' else 'none'} className="m-gray02"></div>
		</div>
}

React.render <GoodsList />,document.getElementById('content')



