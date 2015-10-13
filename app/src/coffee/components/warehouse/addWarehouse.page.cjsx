require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
UserStore = require 'stores/user/user'
WarehousePropertyModel = require 'model/warehouseProperty'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Plugin = require 'util/plugin'
DB = require 'util/storage'
assign = require 'object-assign'

user = UserStore.getUser()

addPropertyModel = (attribute,attributeName,type,typeName,value) ->
	areaModel = new WarehousePropertyModel
	areaModel = areaModel.set 'attribute',attribute
	areaModel = areaModel.set 'attributeName',attributeName
	areaModel = areaModel.set 'type',type
	areaModel = areaModel.set 'typeName',typeName
	areaModel = areaModel.set 'value',value

AddWarehouse = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	getInitialState: ->
		priceProperty = new WarehousePropertyModel
		priceProperty = priceProperty.set 'type','4'
		priceProperty = priceProperty.set 'typeName',"价格"
		
		{
			priceValue1:''
			priceValue2:''
			increaseServe1:'0'
			increaseServe2:'0'
			increaseServe3:'0'
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
			addWarehouseImageUrl:''
			priceProperty:priceProperty
			mainStreet:''
			detailStreet:''
			contactName:''
			contactMobile:''
			params:{
				area:""						#区id
				city:""						#市id
				contacts:user.name				#联系人
				isinvoice:"1"				#1:要发票 2：不要发票
				latitude:""					#纬度
				longitude:""				#经度,116.361905,39.948242 北站 
				name:""						#仓库名称
				phone:user.mobile			#联系电话
				province:""					#省id
				remark:""					#备注
				street:""					#详细地址
				userId:user.id 				#'5b3d93775a22449284aad35443c09fb6'	#user.id
				warehouseProperty:[]
			}
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_onChange :(mark) ->
		if mark.mark is 'addWarehouseImage:done'
			console.log 'show addWarehouseImage files://',mark.picUrl
			newState = Object.create @state
			newState.addWarehouseImageUrl = mark.picUrl
			@setState newState
		else if mark.mark is 'getAddressFromMap'
			newState = Object.create @state
			pa = newState.params;
			pa.province = mark.province
			pa.city = mark.city
			pa.area = mark.district
			pa.street = mark.streetName
			pa.latitude = mark.latitude
			pa.longitude = mark.longitude
			newState.params = pa
			if pa.city is pa.province
				mainStreet = pa.province + pa.area
			else
				mainStreet = pa.province + pa.city + pa.area
			newState.mainStreet = mainStreet
			newState.detailStreet = pa.street + mark.streetNumber
			@setState newState
		else if mark.mark is 'getContectForAddWarehouse'
			newState = Object.create @state
			newState.contactName = mark.contactName
			newState.params.contacts = mark.contactName
			newState.contactMobile = mark.contactMobile
			newState.params.phone = mark.contactMobile
			@setState newState
		else if mark is "saveAddAWarehouse"
			newState = Object.create @state
			newState.params.warehouseProperty = []
			if !@state.params.name
				Plugin.toast.show '请输入仓库名'
				return
			if !@state.params.street
				Plugin.toast.show '请输入仓详细地址'
				return
			if !@state.priceProperty.value
				Plugin.toast.show '请输入价格'
				return
			else
				newState.params.warehouseProperty.push @state.priceProperty
			if !@state.params.contacts
				Plugin.toast.show '请输入联系人姓名'
				return
			if !@state.params.phone
				Plugin.toast.show '请输入联系人电话'
				return
#仓库类型  目前都指定为驶入式
#TODO:
			typeModel = addPropertyModel '1','驶入式','1','仓库类型',''
			newState.params.warehouseProperty.push typeModel

# 增值服务
			if @state.increaseServe1 is '1'
				aPropertyModel = addPropertyModel '1','城配','2','仓库增值服务',''
				newState.params.warehouseProperty.push aPropertyModel
			if @state.increaseServe2 is '1'
				aPropertyModel = addPropertyModel '2','仓配','2','仓库增值服务',''
				newState.params.warehouseProperty.push aPropertyModel
			if @state.increaseServe3 is '1'
				aPropertyModel = addPropertyModel '3','金融','2','仓库增值服务',''
				newState.params.warehouseProperty.push aPropertyModel
			
# 温度区域面积
			if @state.temperatureChecked1 is '1'
				if !@state.temperatureArea1
					Plugin.toast.show '常温面积未填写'
					return
				else
					aPropertyModel = addPropertyModel '1','常温','3','仓库面积',@state.temperatureArea1
					newState.params.warehouseProperty.push aPropertyModel
			if @state.temperatureChecked2 is '1'
				if !@state.temperatureArea2
					Plugin.toast.show '冷藏面积未填写'
					return
				else
					aPropertyModel = addPropertyModel '2','冷藏','3','仓库面积',@state.temperatureArea2
					newState.params.warehouseProperty.push aPropertyModel
			if @state.temperatureChecked3 is '1'
				if !@state.temperatureArea3
					Plugin.toast.show '冷冻面积未填写'
					return
				else
					aPropertyModel = addPropertyModel '3','冷冻','3','仓库面积',@state.temperatureArea3
					newState.params.warehouseProperty.push aPropertyModel
			if @state.temperatureChecked4 is '1'
				if !@state.temperatureArea4
					Plugin.toast.show '急冻面积未填写'
					return
				else
					aPropertyModel = addPropertyModel '4','急冻','3','仓库面积',@state.temperatureArea4
					newState.params.warehouseProperty.push aPropertyModel
			if @state.temperatureChecked5 is '1'
				if !@state.temperatureArea5
					Plugin.toast.show '深冷面积未填写'
					return
				else
					aPropertyModel = addPropertyModel '5','深冷','3','仓库面积',@state.temperatureArea5
					newState.params.warehouseProperty.push aPropertyModel
			@setState newState

			WarehouseAction.postAddWarehouse @state.params, @state.addWarehouseImageUrl

# 仓库名称
	warehouseNameValueChange : (e)->
		newState = Object.create @state
		newState.params.name = e.target.value
		@setState newState
#选择位置 调用原生地图
	selectAddress : ()->
		Plugin.nav.push ['locationView']

# # 仓库详细地址
	detailAddressVAalueChange : (e) ->
		newState = Object.create @state
		newState.detailStreet = e.target.value
		newState.params.street = e.target.value
		@setState newState

# 价格
	priceValueChange1 :(e) ->
		newState = Object.create @state
		if @state.priceValue2.length > 0
			newState.priceValue2 = ''
		newState.priceValue1 = e.target.value
		aPriceProperty = newState.priceProperty
		aPriceProperty = aPriceProperty.set 'value',newState.priceValue1
		aPriceProperty = aPriceProperty.set 'attribute','1'
		aPriceProperty = aPriceProperty.set 'attributeName','天/托'
		newState.priceProperty = aPriceProperty
		@setState newState

	priceValueChange2 : (e) ->
		newState = Object.create @state
		if @state.priceValue1.length > 0
			newState.priceValue1 = ''
		newState.priceValue2 = e.target.value
		aPriceProperty = newState.priceProperty
		aPriceProperty = aPriceProperty.set 'value',newState.priceValue2
		aPriceProperty = aPriceProperty.set 'attribute','2'
		aPriceProperty = aPriceProperty.set 'attributeName','天/平'
		newState.priceProperty = aPriceProperty
		@setState newState

# 发票
	needInvoice : (e)->
		newState = Object.create @state
		newState.params.isinvoice = '1'
		@setState newState
	unNeedInvoice : (e)->
		newState = Object.create @state
		newState.params.isinvoice = '2'
		@setState newState

#增值服务
	increaseServe1 : (e)-> #城配
		newState = Object.create @state
		if e.target.checked
			newState.increaseServe1 = '1'
		else
			newState.increaseServe1 = '0'
		@setState newState
		console.log "增值服务",@state.params.warehouseProperty
	increaseServe2 : (e)-> #仓配
		newState = Object.create @state
		if e.target.checked
			newState.increaseServe2 = '1'
		else
			newState.increaseServe2 = '0'
		@setState newState
		console.log "增值服务",@state.params.warehouseProperty
	increaseServe3 : (e)-> #金融
		newState = Object.create @state
		if e.target.checked
			newState.increaseServe3 = '1'
		else
			newState.increaseServe3 = '0'
		@setState newState
		console.log "增值服务",@state.params.warehouseProperty

			
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
#图片 调用原生相机
	_takePhoto : ()->
		Plugin.run [8,'addWarehouse']
#获取联系人 通讯录导入
	selectContacts :()->
		Plugin.run [4,'getContectForAddWarehouse']
	
	_contactNameChange :(e)->
		newState = Object.create @state
		newState.contactName = e.target.value
		newState.params.contacts = e.target.value
		@setState newState
	_contactMobileChange :(e)->
		newState = Object.create @state
		newState.contactMobile = e.target.value
		newState.params.phone = e.target.value
		@setState newState
#备注
	markChange :(e)->
		newState = Object.create @state
		newState.params.remark = e.target.value
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
					<input readOnly="true" value={ @state.mainStreet } onClick=@selectAddress type="text" className="input-weak" placeholder="请选择地址" />
				</div>
				<div>
					<label for="packType"><span>详细地址</span></label>
					<input type="text" value={ @state.detailStreet  } className="input-weak" placeholder="详细地址" onChange=@detailAddressVAalueChange />
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
		                        <input onChange=@needInvoice defaultChecked=true className="mui-checkbox ll-font" name="xe-checkbox" type="radio"/>否
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
					<figure onClick={@_takePhoto}>
						{
							if @state.addWarehouseImageUrl
								<img className="ll-font" src={'file://' + @state.addWarehouseImageUrl} />
							else
								<span className="ll-font"></span>
						}
					</figure>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="ll-font">
					<span>联系人</span>
					<input className="input-weak" onChange={@_contactNameChange} type="text" value={@state.contactName} placeholder="请输入或点击图标导入" />
					<em onClick={@selectContacts.bind this,'sender'} className="u-personIcon ll-font"></em>
				</div>
				<div>
					<span>联系手机</span>
					<input className="input-weak" onChange={@_contactMobileChange} type="tel" value={@state.contactMobile} placeholder="电话号码" />
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-voice ll-font">
					<label for="remark"><span>备注说明</span> </label>
					<input type="text" onChange={ @markChange } className="input-weak" placeholder="请输入备注消息" id="remark"/>
				</div>
			</div>
		</div>
}

React.render <AddWarehouse />,document.getElementById('content')

# <span>{ user.name }</span> <span>{ user.mobile }</span>
# <div className="u-pay-btn">
# 	<div className="u-pay-btn">
# 		<a href="#" className="btn">发布</a>
# 	</div>
# </div>