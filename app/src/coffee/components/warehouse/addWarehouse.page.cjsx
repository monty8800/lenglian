require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
WarehousePropertyModel = require 'model/warehouseProperty'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

DB = require 'util/storage'
assign = require 'object-assign'

_params = {
	area:""						#区id
	city:""						#市id
	contacts:""					#联系人
	isinvoice:""				#1:要发票 2：不要发票
	latitude:""					#纬度
	longitude:""				#经度
	name:""						#仓库名称
	phone:""					#联系电话
	province:""					#省id
	remark:""					#备注
	street:""					#详细地址
	userId:""					#"7201beba475b49fd8b872e2d1493844a" 	#用户id
	warehouseProperty:[]
}
_priceProperty = new WarehousePropertyModel
_priceProperty = _priceProperty.set 'type','4'
_priceProperty = _priceProperty.set 'typeName',"价格"

_areaProperty1 = new WarehousePropertyModel
_areaProperty1 = _areaProperty1.set 'attribute','1'
_areaProperty1 = _areaProperty1.set 'attributeName',"常温"
_areaProperty1 = _areaProperty1.set 'type','3'
_areaProperty1 = _areaProperty1.set 'typeName',"仓库面积"

_areaProperty2 = new WarehousePropertyModel
_areaProperty1 = _areaProperty1.set 'attribute','2'
_areaProperty1 = _areaProperty1.set 'attributeName',"冷藏"
_areaProperty1 = _areaProperty1.set 'type','3'
_areaProperty1 = _areaProperty1.set 'typeName',"仓库面积"

_areaProperty3 = new WarehousePropertyModel
_areaProperty1 = _areaProperty1.set 'attribute','3'
_areaProperty1 = _areaProperty1.set 'attributeName',"冷冻"
_areaProperty1 = _areaProperty1.set 'type','3'
_areaProperty1 = _areaProperty1.set 'typeName',"仓库面积"

_areaProperty4 = new WarehousePropertyModel
_areaProperty1 = _areaProperty1.set 'attribute','4'
_areaProperty1 = _areaProperty1.set 'attributeName',"急冻"
_areaProperty1 = _areaProperty1.set 'type','3'
_areaProperty1 = _areaProperty1.set 'typeName',"仓库面积"

_areaProperty5 = new WarehousePropertyModel
_areaProperty1 = _areaProperty1.set 'attribute','5'
_areaProperty1 = _areaProperty1.set 'attributeName',"深冷"
_areaProperty1 = _areaProperty1.set 'type','3'
_areaProperty1 = _areaProperty1.set 'typeName',"仓库面积"


_increaseServeProperty = [];


AddWarehouse = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		{
			priceValue1:''
			priceValue2:''
			temperatureChecked1:'0'
			temperatureChecked2:'0'
			temperatureChecked3:'0'
			temperatureChecked4:'0'
			temperatureChecked5:'0'
			temperatureArea1:''
			temperatureArea2:''
			temperatureArea3:''
			temperatureArea4:''
			temperatureArea5:''
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_onChange : ->


# 仓库名称
	warehouseNameValueChange : (e)->
		_params.name = e.target.value

# 仓库地址
	addressVAalueChange: (e) ->
		_params.street = e.target.value

# 仓库详细地址
	detailAddressVAalueChange : (e) ->
		_params.street = e.target.value

# 价格
	priceValueChange1 :(e) ->
		newState = Object.create @state
		if @state.priceValue2.length > 0
			newState.priceValue2 = ''
		newState.priceValue1 = e.target.value
		@setState newState
		_priceProperty = _priceProperty.set 'attribute','1'
		_priceProperty = _priceProperty.set 'attributeName',"天/托"
		_priceProperty = _priceProperty.set 'value',e.target.value

	priceValueChange2 : (e) ->
		newState = Object.create @state
		if @state.priceValue1.length > 0
			newState.priceValue1 = ''
		newState.priceValue2 = e.target.value
		@setState newState
		_priceProperty = _priceProperty.set 'attribute','2'
		_priceProperty = _priceProperty.set 'attributeName',"天/平"
		_priceProperty = _priceProperty.set 'value',e.target.value

# 发票
	needInvoice : (e)->
		_params.isinvoice = '1'
	unNeedInvoice : (e)->
		_params.isinvoice = '2'

#增值服务
	increaseServe1 : (e)-> #城配
		if e.target.checked
			increaseModel = new WarehousePropertyModel
			increaseModel = increaseModel.set 'type','2'
			increaseModel = increaseModel.set 'attribute','1'
			increaseModel = increaseModel.set 'typeName','仓库增值服务'
			increaseModel = increaseModel.set 'attributeName','城配'
			_increaseServeProperty.push increaseModel
		else
			_increaseServeProperty.map (model,i) ->
					if model.attribute is '1'	
						_increaseServeProperty.splice(i,1)
				,this
		console.log "增值服务",_increaseServeProperty
	increaseServe2 : (e)-> #仓配
		if e.target.checked
			increaseModel = new WarehousePropertyModel
			increaseModel = increaseModel.set 'type','2'
			increaseModel = increaseModel.set 'attribute','2'
			increaseModel = increaseModel.set 'typeName','仓库增值服务'
			increaseModel = increaseModel.set 'attributeName','仓配'
			_increaseServeProperty.push increaseModel
		else
			_increaseServeProperty.map (model,i) ->
					if model.attribute is '2'	
						_increaseServeProperty.splice(i,1)
				,this
		console.log "增值服务",_increaseServeProperty
	increaseServe3 : (e)-> #金融
		if e.target.checked
			increaseModel = new WarehousePropertyModel
			increaseModel = increaseModel.set 'type','2'
			increaseModel = increaseModel.set 'attribute','3'
			increaseModel = increaseModel.set 'typeName','仓库增值服务'
			increaseModel = increaseModel.set 'attributeName','金融'
			_increaseServeProperty.push increaseModel
		else
			_increaseServeProperty.map (model,i) ->
					if model.attribute is '3'
						_increaseServeProperty.splice(i,1)
				,this
		console.log "增值服务",_increaseServeProperty

	_takePhoto : ()->
		# Plugin.run ['8',]
		# TODO:
			
# 仓库面积
	temperatureCheck1 : (e) ->
		console.log '常温'
		newState = Object.create @state
		if e.target.checked
			newState.temperatureChecked1 = '1'
		else
			newState.temperatureChecked1 = '0'
		@setState newState
	temperatureCheck2 : (e) ->
		console.log '冷藏'
		newState = Object.create @state
		if e.target.checked
			newState.temperatureChecked2 = '1'
		else
			newState.temperatureChecked2 = '0'
		@setState newState
	temperatureCheck3 : (e) ->
		console.log '冷冻'
		newState = Object.create @state
		if e.target.checked
			newState.temperatureChecked3 = '1'
		else
			newState.temperatureChecked3 = '0'
		@setState newState
	temperatureCheck4 : (e) ->
		console.log '急冻'
		newState = Object.create @state
		if e.target.checked
			newState.temperatureChecked4 = '1'
		else
			newState.temperatureChecked4 = '0'
		@setState newState
	temperatureCheck5 : (e) ->
		console.log '深冷 '
		newState = Object.create @state
		if e.target.checked
			newState.temperatureChecked5 = '1'
		else
			newState.temperatureChecked5 = '0'
		@setState newState

	render : -> 
		<div>
			<div className="m-releaseitem">
				<div>
					<label for="packType"><span>仓库名称</span></label>
					<input type="text" className="input-weak" placeholder="仓库名" onChange=@warehouseNameValueChange />
				</div>
				<div>
					<label for="packType"><span>仓库地址</span></label>
					<input type="text" className="input-weak" placeholder="请输入地址" onChange=@addressVAalueChange />
				</div>
				<div>
					<label for="packType"><span>详细地址</span></label>
					<input type="text" className="input-weak" placeholder="详细地址" onChange=@detailAddressVAalueChange />
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-arrow-right ll-font">
					<span>仓库类型</span>
				</div>
				<div>
					<span>仓库价格</span>
					<input type="text" value={ @state.priceValue1 } className="weight" onChange=@priceValueChange1 /><span className="text-span">天/托</span>
					<input type="text" value={ @state.priceValue2 } className="weight" onChange=@priceValueChange2 /><span className="text-span">天/平</span>
				</div>
				<div>
					<div className="g-radio">
						<span>提供发票</span>
						<div className="radio-box">
							<label className="mr5">
		                        <input onChange=@needInvoice className="mui-checkbox ll-font" name="xe-checkbox" type="radio"/>否
		                    </label>
		                    <label className="mr5">
		                        <input onChange=@unNeedInvoice className="mui-checkbox ll-font" name="xe-checkbox" type="radio"/>是
		                    </label>
						</div>
					</div>
				</div>
				<div>
					<div className="g-radio">
						<span>增值服务</span>
						<div className="radio-box">
							<label className="mr5">
		                        <input onChange=@increaseServe1 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/>城配
		                    </label>
							<label className="mr5">
		                        <input onChange=@increaseServe2 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/>仓配
		                    </label>
        					<label className="mr5">
                                <input onChange=@increaseServe3 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/>金融
                            </label>
						</div>
					</div>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="g-releaseDl">
					<dl className="clearfix">
						<dt className="fl"><span>仓库面积</span></dt>
						<dd className="fl">
							<div>
								<label>
			                        <input onChange=@temperatureCheck1 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/><span>常温</span>
			                    </label>
								{
									if @state.temperatureChecked1 is '0'
										<input disabled='disabled' className="price" type="text" placeholder="" />
									else
										<input valueLink={@linkState 'temperatureArea1'} className="price" type="text" placeholder="" />
								}
			                    <span>平方米</span>
							</div>
							<div>
								<label>
			                        <input onChange=@temperatureCheck2 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/><span>冷藏</span>
			                    </label>
								{
									if @state.temperatureChecked2 is '0'
										<input disabled='disabled' className="price" type="text" placeholder="" />
									else
										<input valueLink={@linkState 'temperatureArea2'} className="price" type="text" placeholder="" />
								}
			                    <span>平方米</span>
							</div>
							<div>
								<label>
			                        <input onChange=@temperatureCheck3 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/><span>冷冻</span>
			                    </label>
			                    {
			                    	if @state.temperatureChecked3 is '0'
			                    		<input disabled='disabled' className="price" type="text" placeholder="" />
			                    	else
			                    		<input valueLink={@linkState 'temperatureArea3'} className="price" type="text" placeholder="" />
			                    }
			                    <span>平方米</span>
							</div>
							<div>
								<label>
			                        <input onChange=@temperatureCheck4 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/><span>急冻</span>
			                    </label>
			                    {
			                    	if @state.temperatureChecked4 is '0'
			                    		<input disabled='disabled' className="price" type="text" placeholder="" />
			                    	else
			                    		<input valueLink={@linkState 'temperatureArea4'} className="price" type="text" placeholder="" />
			                    }
			                    <span>平方米</span>
							</div>
							<div>
								<label>
			                        <input onChange=@temperatureCheck5 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox"/><span>深冷</span>
			                    </label>
			                    {
			                    	if @state.temperatureChecked5 is '0'
			                    		<input disabled='disabled' className="price" type="text" placeholder="" />
			                    	else
			                    		<input valueLink={@linkState 'temperatureArea5'} className="price" type="text" placeholder="" />
			                    }
			                    <span>平方米</span>
							</div>						
						</dd>
					</dl>
				</div>	
			</div>

			<div className="m-releaseitem">
				<div className="choicePic">
					<span>货物照片</span> <i>选填</i>
					<figure>
						<span className="ll-font"></span>
					</figure>
					<input type="file" accept="image/*" onClick={@_takePhoto.bind this} />
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>联系人</span><span>柠静</span>
				</div>
				<div>
					<span>联系手机</span><span>13412356854</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-voice ll-font">
					<label for="remark"><span>备注说明</span> </label>
					<input type="text" className="input-weak" placeholder="请输入备注消息" id="remark"/>
				</div>
			</div>
						
			
		</div>
}

React.render <AddWarehouse />,document.getElementById('content')


# <div className="u-pay-btn">
# 	<div className="u-pay-btn">
# 		<a href="#" className="btn">发布</a>
# 	</div>
# </div>