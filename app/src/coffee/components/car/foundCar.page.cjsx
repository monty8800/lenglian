require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Plugin = require 'util/plugin'
Helper = require 'util/helper'
DB = require 'util/storage'

ScreenMenu = require 'components/car/screen'

DRIVER_LOGO = require 'user-01.jpg'

CarStore = require 'stores/car/car'
CarAction = require 'actions/car/car'

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
		console.log '-----------item:', item.toJS()
		DB.put 'fdcar_to_card', item.toJS()
		Plugin.nav.push ['carOwnerDetail']

	# 选择此车
	select: (carId)->
		console.log '-------select_car', carId
		Plugin.nav.push ['select_goods', carId]

	render: ->
		items = @props.items.map (item, i)->
			<div className="m-item01 m-item03" key={ i }>
				<div className="g-item-dirver">
					<div className="g-dirver">								
						<div onClick={@_goPage.bind this, item} className="g-dirver-pic">
							<img src={ DRIVER_LOGO } />
						</div>       
						<div className="g-dirver-msg">  
							<div className="g-dirver-name">
								<span>{ item?.name }</span>
							</div>  
							<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
						</div>
						<div className="g-dirver-btn">
							<a href="###" onClick={@select.bind this, item.id} className="u-btn02">选择此车</a>
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
					<p>车辆描述 : <span>{Helper.carTypeMapper item.carType}{item.vehicle}米</span></p>
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

	render: ->
		<section>
			<ScreenMenu />
			<CarItem items={ @state.carList } />
		</section>
}

React.render <FoundCar />, document.getElementById('content')






