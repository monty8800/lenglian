require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Constants = require 'constants/constants'
Validator = require 'util/validator'
XeImage = require 'components/common/xeImage'
Image = require 'util/image'
CarAction = require 'actions/car/car'
CarStore = require 'stores/car/car'
Plugin = require 'util/plugin'
Helper = require 'util/helper'
DB = require 'util/storage'
UserStore = require 'stores/user/user'
_user = UserStore.getUser()
CarInfo = DB.get 'transData'
_index = DB.get 'transData2'
carId = CarInfo.carId
DB.remove 'transData'

_carId = ''

Detail = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	getInitialState: ->
		{
			isDel: 1
			driver: ''
			phone: ''
			status: ''
			name: ''
			carDetail: CarStore.getCarDetail().toJS()
		}

	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		CarAction.carDetail(carId)

	componentWillUnMount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		carDetail = CarStore.getCarDetail()
		if params[0] is 'car_detail'
			@setState {
				name: carDetail.driver
				mobile: carDetail.mobile
				status: carDetail.status
				carDetail: carDetail
			}
		else if params[0] is 'editor_car'
			@setState {
				isDel: 2
			}
		else if params[0] is 'editor_car_done'
			@setState {
				isDel: 1
			}

	_delCar: (id, status)->
		Plugin.alert '确认删除吗?', '提示', (index)->
			if index is 1
				CarAction.delCar(id, status, _index)
		, ['确定', '取消']

	_editorCarDone: ->
		if not Validator.name @state.name
			Plugin.toast.err '请输入正确的姓名'
			return
		else if not Validator.mobile @state.mobile
			Plugin.toast.err '请输入正确的手机号'
			return
		CarAction.modifyCar({
			carId: carId
			userId: _user?.id
			driver: @state.name
			phone: @state.mobile
			status: @state.status
		});

	render: ->
		detail = @state.carDetail
		<div>
			<div className="m-item03">
				<div className="g-itemList">
					<span>车牌号码:</span> <span>{ detail?.carNo }</span>	
					<div className="u-item-btn">
						<span href="#">{ Helper.navStatus detail?.status }</span>
					</div>
				</div>
				<div className="g-itemList">
					<span>车辆类型:</span> <span>{ Helper.carTypeMapper detail.carType }</span>			
				</div>
				<div className="g-itemList">
					<dl className="clearfix">
						<dt className=" fl">
							<XeImage src={detail?.carPic} size=Constants.carPicSize />
						</dt>
						<dd className=" fl">
							<p>车辆类别: <span>{ Helper.carCategoryMapper detail.category }</span></p>
							<p>可载重货: <span>{ Helper.goodsWeight detail?.heavy }</span></p>
							<p>可载泡货: <span>{ if detail?.bulky isnt '' then detail?.bulky + '方' else ''}</span></p>
							<p>车辆长度: <span>{ Helper.carVehicle detail?.carVehicle }</span></p>
						</dd>
					</dl>			
				</div>
			</div>

			<div style={{display: if detail?.isinvoice is '' then 'none' else 'block'}} className="m-detail-info m-nomargin">
				<p>
					<span>是否需要发票:</span>
					<span>{ if detail?.isinvoice is '1' then '需要发票' else '不需要发票'}</span>
				</p>				
			</div>
			<div style={{display: if detail?.mark is '' then 'none' else 'block'}} className="m-detail-info m-nomargin">
				<p>
					<span>备注:</span>
					<span>{ detail?.mark }</span>
				</p>				
			</div>

			<div className="m-releaseitem">
				<div>
					<label htmlFor="packType"><span>随车司机:</span></label>
					<input type="text" readOnly={ if @state.isDel is 1 then "readOnly" else ""} valueLink={@linkState 'name'} placeholder="请输入姓名" id="packType"/>
				</div>
				<div>  
					<label htmlFor="packType"><span>联系电话:</span></label>
					<input type="tel" readOnly={ if @state.isDel is 1 then "readOnly" else ""} valueLink={@linkState 'mobile'} placeholder="请输入联系电话" id="packType"/>
				</div>
			</div>
			<div className="g-uploadPic">
				<ul className="clearfix">
					<li>
						<XeImage src={detail?.drivingImg} size=Constants.carPicSize />
					</li>
					<li>
						<XeImage src={detail?.transportImg} size=Constants.carPicSize />
					</li>
				</ul>
			</div>
			<div className="u-pay-btn" style={{display: if @state.isDel is 2 then 'block' else 'none'}}>
				<a href="###" onClick={@_editorCarDone} className="btn">提交</a>
			</div>
			<div className="m-detail-bottom" style={{display: if @state.isDel is 1 && @state.status is 1 then 'block' else 'none'}}>
				<div className="g-pay-btn">
					<a href="###" className="u-btn02" onClick={@_delCar.bind this, detail.id, detail.status}>删除车辆</a>
				</div>
			</div>
		</div>
}

CarDetail = React.createClass {

	getInitialState: ->
		{
			carDetail: CarStore.getCarDetail().toJS()
		}
  
	componentDidMount: ->
		CarStore.addChangeListener @_onChange
		CarAction.carDetail(carId)

	componentWillUnMount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		if params[0] is 'car_detail'
			@setState {
				carDetail: CarStore.getCarDetail()
			}

	render: ->
		<div>
			<Detail detail={ @state.carDetail }/>
		</div>
}

React.render <Detail />, document.getElementById('content')

