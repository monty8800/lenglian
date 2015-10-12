require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
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
		items = @props.items.map (item, i)->
			<div onClick={@_goPage.bind this, item} className="m-item01 m-item03" key={ i }>
				<div className="g-item-dirver">
					<div className="g-dirver">								
						<div className="g-dirver-pic">
							<XeImage src={item?.drivingImg} size='130x130' type='avatar' />
						</div>       
						<div className="g-dirver-msg">  
							<div className="g-dirver-name">
								<span>{ item?.name }</span>
							</div>  
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<a href="###" onClick={@select.bind this, item.id, i} className="u-btn02">选择此车</a>
						</div>
					</div>  
				</div>   
				<div className="g-item">
					<div className="g-adr-start ll-font g-adr-start-line">
						{ item?.startPoint }
					</div>
					<div className="g-adr-end ll-font g-adr-end-line">
						{ item?.destination }
					</div>   	
				</div>
				<div className="g-item g-item-des">
					<p>车辆描述 : <span>{Helper.carTypeMapper item.carType}{Helper.carVehicle item.vehicle}</span></p>
				</div>
			</div>   
		, this		
		<div>
			{ items }
		</div>
}

FoundCar = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		{
			carList: CarStore.getCar()	
		}

	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		CarAction.info([''])

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		if params[0] is 'found_car'
			@setState {
				carList: CarStore.getCar()
			}
		else if params[0] is 'submit_success'
			newState = Object.create @state
			newState.carList = @state.carList.splice params[1], 1
			@setState newState

	render: ->
		<section>
			<ScreenMenu />
			<CarItem items={ @state.carList } />
		</section>
}

React.render <FoundCar />, document.getElementById('content')






