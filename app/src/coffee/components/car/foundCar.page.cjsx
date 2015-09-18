require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

ScreenMenu = require 'components/car/screen'

DRIVER_LOGO = require 'user-01.jpg'

CarStore = require 'stores/car/car'
CarAction = require 'actions/car/car'

CarItem = React.createClass {
	render: ->
		car = @props.car
		<div className="m-item01 m-item03">
			<div className="g-item-dirver">
				<div className="g-dirver">					
					<div className="g-dirver-pic">
						<img src={ DRIVER_LOGO } />
					</div>       
					<div className="g-dirver-msg">  
						<div className="g-dirver-name">
							<span>{ car.name }</span>
						</div>
						<div className="g-dirver-dis ll-font">&#xe609;&#xe609;&#xe609;&#xe609;&#xe609;</div>
					</div>
					<div className="g-dirver-btn">
						<a href="#" className="u-btn02">选择此车</a>
					</div>
				</div>  
			</div>   
			<div className="g-item">
				<div className="g-adr-start ll-font g-adr-start-line">
					{ car.startPoint }
				</div>
				<div className="g-adr-end ll-font g-adr-end-line">
					{ car.destination }
				</div>   
			</div>
			<div className="g-item g-item-des">
				<p>车辆描述 : <span>{ car.carDesc }</span></p>
			</div>
		</div>   
}

FoundCar = React.createClass {
	minxins: [PureRenderMixin]
	getInitialState: ->
		{
			car: CarStore.getCar()	
		}

	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		CarAction.info()

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: ->
		@setState {
			car: CarStore.getCar()
		}

	render: ->
		<section>
			<ScreenMenu />
			<CarItem car={ @state.car } />
		</section>
}

React.render <FoundCar />, document.getElementById('content')






