require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

CarPic01 = require 'car-02.jpg'
CarPic02 = require 'car-03.jpg'
CarPic03 = require 'car-04.jpg'

CarAction = require 'actions/car/car'
CarStore = require 'stores/car/car'

Helper = require 'util/helper'

DB = require 'util/storage'

carId = DB.get 'transData'
console.log '-----carId', carId

Detail = React.createClass {

	_delStore: ->
		alert 'are you kidding?'

	render: ->
		detail = @props.detail
		<div>
			<div className="m-item03">
				<div className="g-itemList">
					<span>车牌号码:</span> <span>{ detail.carNo }</span>	
					<div className="u-item-btn">
						<span href="#">求货中</span>
					</div>
				</div>
				<div className="g-itemList">
					<span>车辆类型:</span> <span>{ Helper.carTypeMapper detail.carType }</span>			
				</div>
				<div className="g-itemList">
					<dl className="clearfix">
						<dt className=" fl">
							<img src={ CarPic01 }/>
						</dt>
						<dd className=" fl">
							<p>车辆类别: <span>{ Helper.carCategoryMapper detail.category }</span></p>
							<p>可载货重: <span>{ detail.heavy }</span></p>
							<p>可载泡货: <span>{ detail.bulky }</span></p>
							<p>车辆长度: <span>{ detail.carVehicle }</span></p>
						</dd>
					</dl>			
				</div>
			</div>
		
			<div className="m-releaseitem">
				<div>
					<label htmlFor="packType"><span>随车司机:</span></label>
					<input type="text" value={ detail.name } placeholder="请输入姓名" id="packType"/>
				</div>
				<div>  
					<label htmlFor="packType"><span>联系电话:</span></label>
					<input type="tel" value={ detail.mobile } placeholder="请输入联系电话" id="packType"/>
				</div>
			</div>
			
			<div className="g-uploadPic">
				<ul className="clearfix">
					<li>
						<img src={ CarPic02 }/>
					</li>
					<li>
						<img src={ CarPic03 }/>
					</li>
				</ul>
			</div>
			
			<div className="m-detail-bottom">
				<div className="g-pay-btn">
					<a href="#" className="u-btn02" onClick={ @_delStore }>删除仓库</a>
				</div>
			</div>
		</div>
}

CarDetail = React.createClass {

	getInitialState: ->
		{
			carDetail: CarStore.getCarDetail(carId).toJS()
		}
  
	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		CarAction.carDetail()

	_onChange: ->
		@setState {
			carDetail: CarStore.getCarDetail()
		}

	render: ->
		<div>
			<Detail detail={ @state.carDetail }/>
		</div>
}

React.render <CarDetail />, document.getElementById('content')

