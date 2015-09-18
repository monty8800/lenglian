# 我的车辆 
require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

CarAction = require 'actions/car/car'
CarStore = require 'stores/car/car'

CarPic = require 'car.jpg'

CarItem = React.createClass {
	render: ->
		console.log "----- #{@props.items}"
		items = @props.items.map (item)->
			car = item
			<div className="m-item03">
				<div className="g-itemList">  
					<h5>
						车牌号码: <span>{ car.carNo }</span>				
					</h5>
					<div className="u-item-btn">
						<a href="#">发布车源</a>
					</div>
				</div>			
				<div className="g-itemList">
					<dl className="clearfix">
						<dt className=" fl">
							<img src={ CarPic }/>
						</dt>
						<dd className=" fl">
							<p>司机姓名: <span>{ car.name }</span></p>
							<p>联系电话: <span>{ car.mobile }</span></p>
							<p>车辆类型: 
								<span>
							      # {(() => {    
							      #   switch (car.carType) {
							      #     case '1': return "#FF0000";
							      #     case '2': return "#00FF00";
							      #     case '3': return "#0000FF";
							      #     default:   return "#FFFFFF";
							      #   }
							      # })()}
									{car.carType}
								</span> 
							</p>
							<p>车辆长度: <span>{ car.carVehicle }米</span></p>
						</dd>
					</dl>			
				</div>
			</div>
		<div>
			{items}
		</div>
}

Car = React.createClass {
	minxins: [PureRenderMixin]
	getInitialState: ->
		{
			carList: CarStore.getCarList().toJS()
		}

	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		CarAction.carList()

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: ->
		@setState { 
			carList: CarStore.getCarList().toJS()
		}
   
	render: ->
		console.log 'itmes---', @state.carList
		<div>
			<div className="m-tab01">
				<ul>
					<li><span className="active">空闲中</span></li>
					<li>求货中</li>
					<li>运输中</li>
					<li>全部</li>
				</ul>   
			</div> 
			<CarItem items={ @state.carList } />
		</div>
}

React.render <Car />, document.getElementById('content')


