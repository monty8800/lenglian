require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

CarAction = require 'actions/car/car'
CarStore = require 'stores/car/car'

CarPic = require 'car.jpg'

Plugin = require 'util/plugin'

Helper = require 'util/helper'

DB = require 'util/storage'

detailCarUrl = 'carDetail'
addCarUrl = 'addCar'

carList = []

CarItem = React.createClass {
	_goPage: (page, i)-> 
		console.log 'i可以当做下标来用哦---', carList.toJS()[i].carId
		carId = carList.toJS()[i].carId
		DB.put 'transData', carId
		Plugin.nav.push [page]

	render: ->
		carStatus: (status)->
		items = @props.items.map (item, i)->
			car = item
			<div className="m-item03" key={ i }>
				<div className="g-itemList">  
					<h5>
						车牌号码: <span>{ car.carNo }</span>				
					</h5>
					<div className="u-item-btn"> 
						<a href="#" onClick={@_goPage.bind this, addCarUrl, i} >发布车源</a>
					</div>
				</div>			
				<div className="g-itemList" onClick={@_goPage.bind this, detailCarUrl, i} >
					<dl className="clearfix">  
						<dt className=" fl">
							<img src={ CarPic }/>
						</dt>  
						<dd className=" fl">
							<p>司机姓名: <span>{ car.name }</span></p>
							<p>联系电话: <span>{ car.mobile }</span></p>
							<p>车辆类型: <span>{ Helper.carTypeMapper car.carType }</span></p>
							<p>车辆长度: <span>{ car.carVehicle }米</span></p>
						</dd>
					</dl>			
				</div>
			</div>
		, this
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
			carList: CarStore.getCarList()
		}
   
	render: ->
		carList = @state.carList
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

