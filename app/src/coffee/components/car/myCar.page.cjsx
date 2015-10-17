require 'components/common/common'
require 'user-center-style'
React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
InfiniteScroll = require('react-infinite-scroll')(React)
Constants = require 'constants/constants'
CarAction = require 'actions/car/car'
CarStore = require 'stores/car/car'
CarPic = require 'car.jpg'
Plugin = require 'util/plugin'
Helper = require 'util/helper'
DB = require 'util/storage'
Image = require 'util/image'

st_01 = '1'
st_02 = '2'
st_03 = '3'
st_04 = ''
_currentStatus = '1'

detailCarUrl = 'carDetail'
addCarUrl = 'releaseVehicle'
	
carList = []				

CarItem = React.createClass {
	_goPage: (page, i)-> 
		carId = carList.toJS()[i].carId
		DB.put 'transData', carList.toJS()[i]
		DB.put 'transData2', i
		DB.put 'callBackRefresh', _currentStatus
		Plugin.nav.push [page]
		
	render: ->
		car = @props.car
		<div className="m-item03" key={car.carNo}>
			<div className="g-itemList">  
				<h5>
					车牌号码: <span>{ car?.carNo }</span>				
				</h5>
				<div className="u-item-btn"> 
					{
						if car?.status is 1
							<a href="#" className="u-btn02" onClick={@_goPage.bind this, addCarUrl, @props.index} >发布车源</a>
						else if car?.status is 2
							<span>求货中</span>
						else if car?.status is 3
							<span>运输中</span>
					}
				</div>
			</div>			
			<div className="g-itemList" onClick={@_goPage.bind this, detailCarUrl, @props.index} >
				<dl className="clearfix">  
					<dt className=" fl">
						<img src={Image.getFullPath car?.carPic, Constants.carPicSize} />
					</dt>
					<dd className=" fl">
						<p>司机姓名: <span>{ car?.name }</span></p>
						<p>联系电话: <span>{ car?.mobile }</span></p>
						<p>车辆类型: <span>{ Helper.carTypeMapper car.carType }</span></p>
						<p>车辆长度: <span>{ Helper.carVehicle car?.carVehicle }</span></p>
					</dd>
				</dl>			
			</div>
		</div>
}

Car = React.createClass {

	minxins: [PureRenderMixin]

	# 空闲中
	status_01: ->
		_currentStatus = st_01
		newState = Object.create @state
		newState.type = st_01
		newState.pageNow = 1
		@setState newState
		CarAction.carList(st_01, 1)

	# 求货中
	status_02: ->
		_currentStatus = st_02
		newState = Object.create @state
		newState.type = st_02
		newState.pageNow = 1
		@setState newState
		CarAction.carList(st_02, 1)

	# 运输中
	status_03: ->
		_currentStatus = st_03
		newState = Object.create @state
		newState.type = st_03
		newState.pageNow = 1
		@setState newState
		CarAction.carList(st_03, 1)

	# 全部
	status_04: ->
		_currentStatus = st_04
		newState = Object.create @state
		newState.type = st_04
		newState.pageNow = 1
		@setState newState
		CarAction.carList(st_04, 1)

	getInitialState: ->
		{
			type: '1'
			hasMore: true
			pageNow: 1
			dataCount: 0
			carList: CarStore.getCarList().toJS()
		}

	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		# CarAction.carList('1', 1)

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		if params[0] is 'my_car_list'
			list = CarStore.getCarList()
			pageNow = @state.pageNow + 1
			@setState { 
				hasMore: list.size - @state.dataCount >= Constants.orderStatus.PAGESIZE
				pageNow: pageNow
				dataCount: list.size
				carList: CarStore.getCarList()
			}
		else if params[0] is 'refresh_my_car'
			index = DB.get 'operator_car'
			console.log '------hahahha:', index
			if parseInt(index) is 10000
				newState = Object.create @state
				newState.type = st_02
				newState.pageNow = 1
				@setState newState	
				CarAction.carList(st_02, @state.pageNow)			
			else
				carList = @state.carList.splice parseInt(index), 1
				newState = Object.create @state
				newState.carList = carList
				@setState newState
			DB.remove 'operator_car'
		else if params[0] is 'native_js_status'
			newState = Object.create @state
			newState.type = st_01
			@setState newState

	_loadMore: ->
		console.log '-----loadMore----', @state.pageNow
		CarAction.carList(_currentStatus, @state.pageNow)
   
	render: ->
		carList = @state.carList
		cars = carList.map (cars, index)->
			<CarItem car={cars} index={index} key={index} />
		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={ @status_01 }>
						<span className={ if @state.type is '1' then "active" else "" }>空闲中</span>
					</li>
					<li onClick={ @status_02 }>
						<span className={ if @state.type is '2' then "active" else "" }>求货中</span>
					</li>
					<li onClick={ @status_03 }>
						<span className={ if @state.type is '3' then "active" else "" }>运输中</span>
					</li>
					<li onClick={ @status_04 }>
						<span className={ if @state.type is '' then "active" else "" }>全部</span>
					</li>
				</ul>   
			</div> 
			<InfiniteScroll pageStart=0 loadMore={@_loadMore} hasMore={@state.hasMore}>
				{cars}
			</InfiniteScroll>
		</div>
}

React.render <Car />, document.getElementById('content')

