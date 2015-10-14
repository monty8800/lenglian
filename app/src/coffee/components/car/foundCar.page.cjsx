require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
InfiniteScroll = require('react-infinite-scroll')(React)
Constants = require 'constants/constants'
Plugin = require 'util/plugin'
Helper = require 'util/helper'
XeImage = require 'util/image'
DB = require 'util/storage'
ScreenMenu = require 'components/car/screen'
DRIVER_LOGO = require 'user-01.jpg'
CarStore = require 'stores/car/car'
CarAction = require 'actions/car/car'
XeImage = require 'components/common/xeImage'
avatar = require 'user-01'

CarItem = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	getInitialState: ->
		null

	componentDidMount: ->
		CarStore.addChangeListener @_onChange

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: ->
		console.log 'callback'

	# 车主详情
	_goPage: (item)->
		DB.put 'transData', [item.carId, item.userId]
		Plugin.nav.push ['carOwnerDetail']

	# 选择此车
	select: (carId, i, e)->
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
						<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
					</div>
					<div className="g-dirver-btn">
						<a href="###" onClick={@select.bind this, @props.car.id, @props.index} className="u-btn02">选择此车</a>
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
		}

	componentDidMount: ->
		# CarAction.info(0)
		CarStore.addChangeListener @_onChange

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		if params[0] is 'found_car'
			list = CarStore.getCar()
			if list.size < Constants.orderStatus.PAGESIZE
				hasMore = false
			else
				hasMore = true
			@setState {
				hasMore: hasMore
				carList: list
				dataCount: list.size
			}
		else if params[0] is 'submit_success'
			newState = Object.create @state
			newState.carList = @state.carList.splice params[1], 1
			@setState newState

	_loadMore: ->
		console.log '-----adfsdsfasdf'
		CarAction.info(@state.dataCount)

	render: ->
		carCells = @state.carList.map (cars, index)->
			<CarItem car={cars} index={index} key={index} />
		<section>
			<ScreenMenu />
			<InfiniteScroll pageStart=0 loadMore={@_loadMore} hasMore={@state.hasMore} >
				{carCells}
			</InfiniteScroll>
		</section>
}

React.render <FoundCar />, document.getElementById('content')






