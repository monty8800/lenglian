require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
Immutable = require 'immutable'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
CSSTransitionGroup = React.addons.CSSTransitionGroup

Helper = require 'util/helper'
Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'
XeImage = require 'components/common/xeImage'
InfiniteScroll = require('react-infinite-scroll')(React)

GoodsStore = require 'stores/goods/goods'
GoodsAction = require 'actions/goods/goods'
Goods = require 'model/goods'
DB = require 'util/storage'
Moment = require 'moment'


_firstLoad = true

GoodsListItem = React.createClass {
	_toGoodsDetail: (index) ->
		goodsId = @props.list[index].id
		DB.put 'transData',goodsId
		Plugin.nav.push ['goodsDetail']

	render : ->
		listItem = @props.list.map (item, i) ->
			_statusText = ''
			if parseInt(item.resourceStatus) is 1
				if parseInt(item.refrigeration) is 1  
					_statusText = '求车中'
				else
					_statusText = '求车(库)中'
			else
				_statusText = Helper.goodsStatus item.resourceStatus

			toText = ''
			if item.toProvinceName is item.toCityName
				toText = (item.toCityName or '') + (item.toAreaName or '') + (item.toStreet or '')
			else
				toText = (item.toProvinceName or '') + (item.toCityName or '') + (item.toAreaName or '') + (item.toStreet or '')

			fromText = ''
			if item.fromProvinceName is item.fromCityName
				fromText = (item.fromCityName or '') + (item.fromAreaName or '') + (item.fromStreet or '')
			else
				fromText = (item.fromProvinceName or '') + (item.fromCityName or '') + (item.fromAreaName or '') + (item.fromStreet or '')			

			<div className="m-item03" onClick={ @_toGoodsDetail.bind this,i }>
				<div className="g-itemList">
					<h5>
						货物名称: <span>{ item.name }</span>				
					</h5>
					<div className="u-item-btn">
						<span>{_statusText}</span>
					</div>
						
				</div>			
				<div className="g-itemList g-item g-adr-detail ll-font">			
					<div className="g-adr-start ll-font g-adr-start-line" dangerouslySetInnerHTML={{__html: toText + '<span></span>'}}>
					</div>
					<div className="g-adr-end ll-font g-adr-end-line" dangerouslySetInnerHTML={{__html: fromText + '<span></span>'}}>
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
							<p>发布日期:<span>{ Moment(item.createTime).format('YYYY-MM-DD') }</span></p>
						</dd>
					</dl>			
				</div>
			</div>
		,this
		<div>
		<CSSTransitionGroup transitionName="list">
			{ listItem }
		</CSSTransitionGroup>
		</div>
}

getStamp = (index)->
	tempInt = 0
	currentTimestamp = Math.round(new Date().getTime())
	switch parseInt(index)
		when 1
			tempInt = 1
		when 2
			tempInt = 3
		when 3
			tempInt = 5
		when 4
			tempInt = 7
		when 5
			tempInt = 14
	timeStamp = currentTimestamp - tempInt * 24 * 60 * 60 * 1000
	Moment(timeStamp).format('YYYY-MM-DD')


	
GoodsList = React.createClass {
	getInitialState:->
		{
			showType:0  		# 1 货源状态  2 价格类型  3 发布日期
			shouldShowMenu:0 # 1 货源菜单  2 价格菜单  3 发布日期菜单  = 0 时 可以滑动   
			selectedMenu1: 0 # 按资源状态 1 全部 2 求车种 3 有人响应 4 已成交
			selectedMenu2: 0 # 按价格类型 1 高价 2 中价  3 低价
			selectedMenu3: 0 # 按发布类型 1 近一周 2 近两周  3 近一月
			goodsList:[]
		}

	componentDidMount: ->
		GoodsStore.addChangeListener @_onChange
		GoodsAction.getGoodsList 1,10,'','',''	
		#pageNow pageSize resourceStatus priceType createTime   userId在store中传 
	componentWillUnmount: ->
		GoodsStore.removeChangeListener @_onChange

	_onChange: (mark)->
		if mark is 'getUserGoodsListSucc'
			_firstLoad = false
			newState = Object.create @state
			newState.goodsList = GoodsStore.getMyGoodsList()		
			@setState newState
		else if mark is 'myGoodsList:reloaded'
			@setState {
				showType:0
				shouldShowMenu:0
				selectedMenu1: 0
				selectedMenu2: 0
				selectedMenu3: 0 
				goodsList:[]
			}
		

	_topTypeClick : (index)->
		newState = Object.create @state
		if index is @state.showType
			newState.shouldShowMenu = 0
			newState.showType = 0
			Plugin.run [3,'shouldScrollEnable',0]
		else
			newState.shouldShowMenu = index
			Plugin.run [3,'shouldScrollEnable',index]
			newState.showType = newState.shouldShowMenu
		@setState newState


	_subMenu1Click :(index) ->
		if @state.selectedMenu1 is index
			return
		newState = Object.create @state
		newState.selectedMenu1 = index
		newState.goodsList = []
		newState.shouldShowMenu = 0
		Plugin.run [3,'shouldScrollEnable',0]
		@setState newState 
		stu = index
		if parseInt(stu) is 0 then stu = ''
		pt = @state.selectedMenu2
		if parseInt(pt) is 0 then pt = ''
		ct = @state.selectedMenu3
		if parseInt(ct) is 0 then ct = ''  else ct = getStamp(ct)
		
		GoodsAction.getGoodsList 1,10,stu,pt,ct


	_subMenu2Click :(index) ->
		if @state.selectedMenu2 is index
			return
		newState = Object.create @state
		newState.selectedMenu2 = index
		newState.shouldShowMenu = 0
		newState.goodsList = []
		Plugin.run [3,'shouldScrollEnable',0]
		@setState newState 
		stu = @state.selectedMenu1
		if parseInt(stu) is 0 then stu = ''
		pt = index
		if parseInt(pt) is 0 then pt = ''
		ct = @state.selectedMenu3
		if parseInt(ct) is 0 then ct = ''  else ct = getStamp(ct)
		
		GoodsAction.getGoodsList 1,10,stu,pt,ct


	_subMenu3Click :(index) ->
		if @state.selectedMenu3 is index
			return
		newState = Object.create @state
		newState.selectedMenu3 = index
		newState.shouldShowMenu = 0
		newState.goodsList = []
		Plugin.run [3,'shouldScrollEnable',0]
		@setState newState 
		stu = @state.selectedMenu1
		if parseInt(stu) is 0 then stu = ''
		pt = @state.selectedMenu2
		if parseInt(pt) is 0 then pt = ''
		ct = index
		if parseInt(ct) is 0 then ct = ''  else ct = getStamp(ct)
		GoodsAction.getGoodsList 1,10,stu,pt,ct

	_loadMore: ->
		stu = @state.selectedMenu1
		if parseInt(stu) is 0 then stu = ''
		pt = @state.selectedMenu2
		if parseInt(pt) is 0 then pt = ''
		ct = @state.selectedMenu3
		if parseInt(ct) is 0 then ct = ''  else ct = getStamp(ct)
		GoodsAction.getGoodsList 1,10,stu,pt,ct

	_disableScroll: (e)->
		e.preventDefault()
		
	render : ->
		console.log 'state', @state
		<div>
			<div className="viewport">
				<div onTouchMove={@_disableScroll} className="m-tab02">
					<ul>
						<li onClick={ @_topTypeClick.bind this,1 } className={ if @state.showType is 1 then "active ll-font u-arrow-right" else "ll-font u-arrow-right" }>货源状态
							<div style={display: if @state.showType is 1 then 'block' else 'none'} className="m-dropDown">
								<p onClick={ @_subMenu1Click.bind this,0 } className={ if @state.selectedMenu1 is 0 then "active" else "" }>全部</p>
								<p onClick={ @_subMenu1Click.bind this,1 } className={ if @state.selectedMenu1 is 1 then "active" else "" }>求车(库)中</p>
								<p onClick={ @_subMenu1Click.bind this,2 } className={ if @state.selectedMenu1 is 2 then "active" else "" }>有人响应</p>
								<p onClick={ @_subMenu1Click.bind this,3 } className={ if @state.selectedMenu1 is 3 then "active" else "" }>已成交</p>
							</div>
						</li>
						<li onClick={ @_topTypeClick.bind this,2 } className={ if @state.showType is 2 then "active ll-font u-arrow-right" else "ll-font u-arrow-right" }>价格类型
							<div style={display: if @state.showType is 2 then 'block' else 'none'}  className="m-dropDown">
								<p onClick={ @_subMenu2Click.bind this,0 } className={ if @state.selectedMenu2 is 0 then "active" else "" } >全部</p>
								<p onClick={ @_subMenu2Click.bind this,1 } className={ if @state.selectedMenu2 is 1 then "active" else "" } >一口价</p>
								<p onClick={ @_subMenu2Click.bind this,2 } className={ if @state.selectedMenu2 is 2 then "active" else "" } >竞价</p>
							</div>
						</li>
						<li onClick={ @_topTypeClick.bind this,3 } className={ if @state.showType is 3 then "active ll-font u-arrow-right" else "ll-font u-arrow-right" }>发布日期
							<div style={display: if @state.showType is 3 then 'block' else 'none'}  className="m-dropDown">
								<p onClick={ @_subMenu3Click.bind this,0 } className={ if @state.selectedMenu3 is 0 then "active" else "" }>全部</p>
								<p onClick={ @_subMenu3Click.bind this,1 } className={ if @state.selectedMenu3 is 1 then "active" else "" }>一天内</p>
								<p onClick={ @_subMenu3Click.bind this,2 } className={ if @state.selectedMenu3 is 2 then "active" else "" }>三天内</p>
								<p onClick={ @_subMenu3Click.bind this,3 } className={ if @state.selectedMenu3 is 3 then "active" else "" }>五天内</p>
								<p onClick={ @_subMenu3Click.bind this,4 } className={ if @state.selectedMenu3 is 4 then "active" else "" }>一周内</p>
								<p onClick={ @_subMenu3Click.bind this,5 } className={ if @state.selectedMenu3 is 5 then "active" else "" }>两周内</p>
							</div>
						</li>
					</ul>
				</div>
				
				<div style={{display: if @state.goodsList.length is 0 and not _firstLoad then 'block' else 'none'}} className="m-searchNoresult">
					<div className="g-bgPic"></div>
					<p className="g-txt">很抱歉，没能找到您要的结果</p>
				</div>

				<GoodsListItem list={ @state.goodsList } />

			</div>
			<div onTouchMove={@_disableScroll} style={display: if @state.shouldShowMenu isnt 0 then 'block' else 'none'} className="m-gray02"></div>
		</div>
}

React.render <GoodsList />,document.getElementById('content')


