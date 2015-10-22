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
						<XeImage src={@props.car?.drivingImg} size='130x130' type='avatar' />
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
					{ @props.car?.startPoint }
				</div>
				<div className="g-adr-end ll-font g-adr-end-line">
					{ @props.car?.destination }
				</div>   	
			</div>
			<div className="g-item g-item-des">
				<p>车辆描述 : <span>{Helper.carTypeMapper @props.car.carType}{Helper.carVehicle @props.car.vehicle}</span></p>
			</div>
		</div>   		
}

FoundCar = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		{
			hasMore: true
			dataCount: 0
			carList: CarStore.getCar()	
			isShow: false
		}

	componentDidMount: ->
		# CarAction.info(0)
		CarStore.addChangeListener @_onChange

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		if params[0] is 'found_car'
			list = CarStore.getCar()
			# if list.size < Constants.orderStatus.PAGESIZE
			# 	hasMore = false
			# else
			# 	hasMore = true
			@setState {
				hasMore: list.size - @state.dataCount >= Constants.orderStatus.PAGESIZE
				carList: list
				dataCount: list.size
				isShow: list.size == 0
			}
		else if params[0] is 'submit_success'
			list = @state.carList
			console.log '----submit_success--callback--:', params[1]
			newState = Object.create @state
			newState.carList = list.splice params[1], 1
			@setState newState

	_loadMore: ->
		console.log '-----adfsdsfasdf'
		CarAction.info(@state.dataCount)

	render: ->
		carCells = @state.carList.map (cars, index)->
			<CarItem car={cars} index={index} key={cars?.id} />
		<section>
			<ScreenMenu />
			<NoResult isShow={@state.isShow} />
			<InfiniteScroll pageStart=0 loadMore={@_loadMore} hasMore={@state.hasMore} >
				{carCells}
			</InfiniteScroll>
		</section>
}

React.render <FoundCar />, document.getElementById('content')
