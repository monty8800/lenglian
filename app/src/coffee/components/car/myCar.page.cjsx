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

st_01 = '1'
st_02 = '2'
st_03 = '3'
st_04 = ''

detailCarUrl = 'carDetail'
addCarUrl = 'releaseVehicle'
	
carList = []				

CarItem = React.createClass {
	_goPage: (page, i)-> 
		carId = carList.toJS()[i].carId
		console.log '----------page:', page
		DB.put 'transData', carList.toJS()[i]
		Plugin.nav.push [page]
		
	render: ->
		items = @props.items.map (item, i)->
			car = item
			<div className="m-item03" key={ i }>
				<div className="g-itemList">  
					<h5>
						车牌号码: <span>{ car?.carNo }</span>				
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
							<p>司机姓名: <span>{ car?.name }</span></p>
							<p>联系电话: <span>{ car?.mobile }</span></p>
							<p>车辆类型: <span>{ Helper.carTypeMapper car.carType }</span></p>
							<p>车辆长度: <span>{ car?.carVehicle }米</span></p>
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

	# 空闲中
	status_01: ->
		newState = Object.create @state
		newState.type = st_01
		@setState newState
		CarAction.carList(st_01)

	# 求货中
	status_02: ->
		newState = Object.create @state
		newState.type = st_02
		@setState newState
		CarAction.carList(st_02)

	# 运输中
	status_03: ->
		newState = Object.create @state
		newState.type = st_03
		@setState newState
		CarAction.carList(st_03)

	# 全部
	status_04: ->
		newState = Object.create @state
		newState.type = st_04
		@setState newState
		CarAction.carList(st_04)

	getInitialState: ->
		{
			type: '1'
			carList: CarStore.getCarList().toJS()
		}

	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		CarAction.carList('1')

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
					<li onClick={ @status_01.bind this }>
						<span className={ if @state.type is '1' then "active" else "" }>空闲中</span>
					</li>
					<li onClick={ @status_02.bind this }>
						<span className={ if @state.type is '2' then "active" else "" }>求货中</span>
					</li>
					<li onClick={ @status_03.bind this }>
						<span className={ if @state.type is '3' then "active" else "" }>运输中</span>
					</li>
					<li onClick={ @status_04.bind this }>
						<span className={ if @state.type is '' then "active" else "" }>全部</span>
					</li>
				</ul>   
			</div> 
			<CarItem items={ @state.carList } />
		</div>
}

React.render <Car />, document.getElementById('content')

