require 'components/common/common'
require 'index-style'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
InfiniteScroll = require('react-infinite-scroll')(React)
Constants = require 'constants/constants'
NoResult = require 'components/common/noResult'
Plugin = require 'util/plugin'
Helper = require 'util/helper'
XeImage = require 'util/image'
DB = require 'util/storage'
ScreenMenu = require 'components/car/screen'
CarStore = require 'stores/car/car'
CarAction = require 'actions/car/car'
XeImage = require 'components/common/xeImage'
Raty = require 'components/common/raty'
avatar = require 'user-01'
UserStore = require 'stores/user/user'
Auth = require 'util/auth'
_user = UserStore.getUser()

Selection = require 'components/common/selection'
SelectionStore = require 'stores/common/selection'

selectionList = [
	{
		key: 'vehicle'
		value: '车辆长度'
		options: [
			{key: '1', value: '3.8米以下'}
			{key: '2', value: '3.8米'}
			{key: '3', value: '4.2米'}
			{key: '4', value: '4.8米'}
			{key: '5', value: '5.8米'}
			{key: '6', value: '6.2米'}
			{key: '7', value: '6.8米'}
			{key: '8', value: '7.4米'}
			{key: '9', value: '7.8米'}
			{key: '10', value: '8.6米'}
			{key: '11', value: '9.6米'}
			{key: '12', value: '13~15米'}
			{key: '13', value: '15以上米'}
		]
	}
	{
		key: 'heavy'
		value: '可载重货'
		options: [
			{key: '1', value: ''}
			{key: '2', value: '2吨以下'}
			{key: '3', value: '3吨'}
			{key: '4', value: '4吨'}
			{key: '5', value: '5吨'}
			{key: '6', value: '6吨'}
			{key: '7', value: '8吨'}
			{key: '8', value: '10吨'}
			{key: '9', value: '12吨'}
			{key: '10', value: '15吨'}
			{key: '11', value: '18吨'}
			{key: '12', value: '20吨'}
			{key: '13', value: '25吨'}
			{key: '14', value: '28吨'}
			{key: '15', value: '30吨'}
			{key: '16', value: '30~40吨'}
			{key: '17', value: '40吨以上'}
		]
	}
	{
		key: 'isInvoice'
		value: '提供发票'
		options: [
			{key: '1', value: '是'}
			{key: '2', value: '否'}
		]
	}
]

CarItem = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	getInitialState: ->
		{
			isInit: false
		}

	componentDidMount: ->
		CarStore.addChangeListener @_onChange

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		console.log 'callback'
		if params[0] is 'found_car'
			@setState {
				wishlst: true
			}

	# 车主详情
	_goPage: (item)->
		Auth.needLogin ->
			DB.put 'transData', [item.carId, item.userId]
			Plugin.nav.push ['carOwnerDetail']

	# 选择此车
	select: (carId, i, carUserId, e)->
		Auth.needLogin ->
			return Plugin.toast.err '尚未通过货主认证，请认证后再试' if UserStore.getUser()?.goodsStatus isnt 1
			# 判断该车源是否是自己发布的，如果是自己发布的提示不能选择
			return Plugin.toast.err '不能选择自己的车源哦' if carUserId is _user?.id
			console.log '-------carUserId:', carUserId
			console.log '-------userId:', _user.id
			console.log '-------select_car', carId
			Plugin.nav.push ['select_goods', carId, i]
		e.stopPropagation()

	render: ->
		<div onClick={@_goPage.bind this, @props.car} className="m-item01 m-item03">
			<div className="g-item-dirver">
				<div className="g-dirver">								
					<div className="g-dirver-pic">
						<XeImage src={@props.car?.drivePic} size='130x130' type='avatar' />
					</div>       
					<div className="g-dirver-msg">  
						<div className="g-dirver-name">
							<span>{ @props.car?.name }</span>
						</div>  
						<div className="g-dirver-dis ll-font">
							{
								if not @state.isInit
									<Raty score={@props.car.carScore} />
							}
						</div>
					</div>
					<div className="g-dirver-btn">
						<a href="###" onClick={@select.bind this, @props.car.id, @props.index, @props.car.userId} className="u-btn02">选择此车</a>
					</div>
				</div>  
			</div>   
			<div className="g-item">

				<div className="g-adr-start ll-font g-adr-start-line">
					<em>{ @props.car?.destination }</em>
					<span></span>
				</div>
				<div className="g-adr-end ll-font g-adr-end-line">
					<em>{ @props.car?.startPoint }</em>
					<span></span>
				</div>   	
			</div>
			<div className="g-item g-item-des">
				<p>车辆描述 : <span>{Helper.carTypeMapper @props.car.carType}{Helper.carVehicle @props.car.vehicle}</span></p>
			</div>
		</div>   		
}

_skip = 0
_pageSize = 10
_hasMore = true
_netBusy = false

FoundCar = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		initState = {
			carList: CarStore.getCar()	
			showCarList: false
			isShow: false
		}

		for selection in selectionList
			initState[selection.key] = (option.key for option in selection.options)
		console.log 'initState', initState
		return initState		

	componentDidMount: ->
		SelectionStore.addChangeListener @_onChange
		CarStore.addChangeListener @_onChange
		@_loadMore

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange
		SelectionStore.removeChangeListener @_onChange

	_onChange: (params)->
		if params[0] is 'found_car'
			list = CarStore.getCar()
			_netBusy = false
			_skip = list.size
			_hasMore = (list.size % _pageSize) is 0
			@setState {
				carList: list
				isShow: list.size == 0
			}
		else if params[0] is 'submit_success'
			list = @state.carList
			newState = Object.create @state
			newState.carList = list.splice params[1], 1
			@setState newState
		else if params[0] is 'do_search_car'
			_skip = 0
			_hasMore = true
			@_loadMore()
		else if params.type
			console.log '------------params.type:', params.type
			newState = Object.create @state
			newState[params.type] = params.list
			@setState newState

	_loadMore: ->
		CarAction.searchCarList {
			userId: _user?.id
			startNo: _skip
			pageSize: Constants.orderStatus.PAGESIZE	
			vehicle: @state.vehicle
			heavy: @state.heavy	
			isInvoice: @state.isInvoice[0] if @state.isInvoice.length is 1 
		}

	render: ->
		carCells = @state.carList.map (cars, index)->
			<CarItem car={cars} index={index} key={cars?.id} />
		<section>
			<div className="m-nav03">
				<ul>
					{
						for s, i in selectionList
							<Selection selectionMap=s  key={i} />
					}
				</ul>			
			</div>	
			<NoResult isShow={@state.isShow} />
			<InfiniteScroll pageStart=0 loadMore={@_loadMore} hasMore={_hasMore}>
				{ carCells }
			</InfiniteScroll>
		</section>	
		# carCells = @state.carList.map (cars, index)->
		# 	<CarItem car={cars} index={index} key={cars?.id} />
		# <section>
		# 	<ScreenMenu />
		# 	<NoResult isShow={@state.isShow} />
		# 	<InfiniteScroll pageStart=0 loadMore={@_loadMore} hasMore={@state.hasMore} >
		# 		{carCells}
		# 	</InfiniteScroll>
		# </section>
}

React.render <FoundCar />, document.getElementById('content')
