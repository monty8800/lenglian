require 'components/common/common'
require 'user-center-style'
require 'majia-style'

React = require 'react/addons'
XeImage = require 'components/common/xeImage'
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

addPropertyModel = (attribute,attributeName,type,typeName,value,valueTwo) ->
	areaModel = new WarehousePropertyModel
	if parseInt(type) is 3
		areaModel = areaModel.set 'valueTwo',valueTwo
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
		priceProperty = priceProperty.set 'attribute','1'				#平托吨方
		priceProperty = priceProperty.set 'attributeName','元/天/平'

		{
			priceValue:''
			priceUnit:''
			warehouseType1:'0'
			warehouseType2:'0'
			increaseServe1:'0'
			increaseServe2:'0'
			temperatureChecked1:'0'
			temperatureChecked2:'0'
			temperatureChecked3:'0'
			temperatureChecked4:'0'
			temperatureChecked5:'0'
			temperatureArea11:''
			temperatureArea21:''
			temperatureArea31:''
			temperatureArea41:''
			temperatureArea51:''
			temperatureArea12:''
			temperatureArea22:''
			temperatureArea32:''
			temperatureArea42:''
			temperatureArea52:''
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
				isinvoice:"2"				#1:开发票 2：不开发票
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
			pa.latitude = mark.latitude
			pa.longitude = mark.longitude
			if pa.city is pa.province
				mainStreet = pa.province + pa.area
			else
				mainStreet = pa.province + pa.city + pa.area
			newState.mainStreet = mainStreet
			newState.detailStreet = mark.streetName + mark.streetNumber
			pa.street = newState.detailStreet
			newState.params = pa
			@setState newState
		else if mark.mark is 'getContectForAddWarehouse'
			newState = Object.create @state
			newState.contactName = mark.contactName
			newState.params.contacts = mark.contactName
			newState.contactMobile = mark.contactMobile
			newState.params.phone = mark.contactMobile
			@setState newState
		# else if mark is "saveAddAWarehouse"

	_addNewWarehouse : ->
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
				newState.priceProperty = newState.priceProperty.set 'attributeName',@state.priceUnit
				newState.params.warehouseProperty.push newState.priceProperty
			if !@state.params.contacts
				Plugin.toast.show '请输入联系人姓名'
				return
			if !@state.params.phone
				Plugin.toast.show '请输入联系人电话'
				return
			
# 温度区域面积
			if @state.temperatureChecked1 is '0' and @state.temperatureChecked2 is '0' and @state.temperatureChecked3 is '0' and @state.temperatureChecked4 is '0' and @state.temperatureChecked5 is '0'
				 Plugin.toast.show '请填写仓库面积'
				 return
			else
				if @state.temperatureChecked1 is '1'
					if !@state.temperatureArea11 and !@state.temperatureArea12
						Plugin.toast.show '常温面积未填写'
						return
					else
						aPropertyModel = addPropertyModel '1','常温','3','仓库面积',@state.temperatureArea11,@state.temperatureArea12
						newState.params.warehouseProperty.push aPropertyModel
				if @state.temperatureChecked2 is '1'
					if !@state.temperatureArea21 and !@state.temperatureArea22
						Plugin.toast.show '冷藏面积未填写'
						return
					else
						aPropertyModel = addPropertyModel '2','冷藏','3','仓库面积',@state.temperatureArea21,@state.temperatureArea22
						newState.params.warehouseProperty.push aPropertyModel
				if @state.temperatureChecked3 is '1'
					if !@state.temperatureArea31 and !@state.temperatureArea32
						Plugin.toast.show '冷冻面积未填写'
						return
					else
						aPropertyModel = addPropertyModel '3','冷冻','3','仓库面积',@state.temperatureArea31,@state.temperatureArea32
						newState.params.warehouseProperty.push aPropertyModel
				if @state.temperatureChecked4 is '1'
					if !@state.temperatureArea41 and !@state.temperatureArea42
						Plugin.toast.show '急冻面积未填写'
						return
					else
						aPropertyModel = addPropertyModel '4','急冻','3','仓库面积',@state.temperatureArea41,@state.temperatureArea42
						newState.params.warehouseProperty.push aPropertyModel
				if @state.temperatureChecked5 is '1'
					if !@state.temperatureArea51 and !@state.temperatureArea52
						Plugin.toast.show '深冷面积未填写'
						return
					else
						aPropertyModel = addPropertyModel '5','深冷','3','仓库面积',@state.temperatureArea51,@state.temperatureArea52
						newState.params.warehouseProperty.push aPropertyModel

# 增值服务	
			if @state.increaseServe1 is '1'
				aPropertyModel = addPropertyModel '1','提供拖车','2','配套服务','',''
				newState.params.warehouseProperty.push aPropertyModel
			if @state.increaseServe2 is '1'
				aPropertyModel = addPropertyModel '2','提供装卸','2','配套服务','',''
				newState.params.warehouseProperty.push aPropertyModel

#仓库类型
			if @state.warehouseType1 is '0' and @state.warehouseType2 is '0'
				Plugin.toast.show '请选择仓库类型'
				return
			else
				if @state.warehouseType1 is '1'
					aPropertyModel = addPropertyModel '1','平堆式','1','仓库类型','',''
					newState.params.warehouseProperty.push aPropertyModel
				if @state.warehouseType2 is '1'
					aPropertyModel = addPropertyModel '2','货架式','1','仓库类型','',''
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
	detailAddressValueChange : (e) ->
		newState = Object.create @state
		newState.detailStreet = e.target.value
		newState.params.street = e.target.value
		@setState newState

# 仓库类型
	warehouseType1 :(e)->
		newState = Object.create @state
		if e.target.checked
			newState.warehouseType1 = '1'
		else
			newState.warehouseType1 = '0'
		@setState newState
		console.log "仓库类型"
	warehouseType2 :(e)->
		newState = Object.create @state
		if e.target.checked
			newState.warehouseType2 = '1'
		else
			newState.warehouseType2 = '0'
		@setState newState

# 价格
	priceValueChange :(e) ->
		newState = Object.create @state
		aPriceProperty = newState.priceProperty
		aPriceProperty = aPriceProperty.set 'value',e.target.value
		newState.priceProperty = aPriceProperty
		@setState newState

# 发票
	_needInvoice : (e)->
		newState = Object.create @state
		newState.params.isinvoice = '1'
		@setState newState
	_unNeedInvoice : (e)->
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
		console.log "增值服务拖车",@state.params.warehouseProperty
	increaseServe2 : (e)-> #仓配
		newState = Object.create @state
		if e.target.checked
			newState.increaseServe2 = '1'
		else
			newState.increaseServe2 = '0'
		@setState newState
		console.log "增值服务装卸",@state.params.warehouseProperty

			
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
					<input type="text" value={ @state.detailStreet  } className="input-weak" placeholder="详细地址" onChange=@detailAddressValueChange />
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<div className="g-radio">
						<span>仓库类型</span>
						<div className="radio-box">
							<label className="mr5">
		                        <input onChange=@warehouseType1 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox" dangerouslySetInnerHTML={{__html: '平堆式'}} />
		                    </label>
							<label className="mr5">
		                        <input onChange=@warehouseType2 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox" dangerouslySetInnerHTML={{__html: '货架式'}} />
		                    </label>
						</div>
					</div>
				</div>
				<div>
					<span>仓库价格</span>
					<input onChange=@priceValueChange type="text" className="weight"/>	
					<select valueLink={@linkState 'priceUnit'} className="weight">
						<option value="元/天/平">元/天/平</option>
						<option value="元/天/托">元/天/托</option>
						<option value="元/天/吨">元/天/吨</option>
						<option value="元/天/方">元/天/方</option>
					</select>
				</div>
				<div>
					<div className="g-radio">
						<span>提供发票</span>
						<div className="radio-box">
							<label className="mr5">
		                        <input onChange=@_unNeedInvoice defaultChecked=true className="mui-checkbox ll-font" name="xe-checkbox" type="radio" dangerouslySetInnerHTML={{__html: '否'}}/>
		                    </label>
		                    <label className="mr5">
		                        <input onChange=@_needInvoice className="mui-checkbox ll-font" name="xe-checkbox" type="radio" dangerouslySetInnerHTML={{__html: '是'}} />
		                    </label>
						</div>
					</div>
				</div>
				<div>
					<div className="g-radio">
						<span>配套服务</span>
						<div className="radio-box">
							<label className="mr5">
		                        <input onChange=@increaseServe1 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox" dangerouslySetInnerHTML={{__html: '提供拖车'}} />
		                    </label>
							<label className="mr5">
		                        <input onChange=@increaseServe2 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox" dangerouslySetInnerHTML={{__html: '提供装卸'}} />
		                    </label>
						</div>
					</div>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<span>仓库面积</span>
				</div>
				<div className="g-storeArea">
					<label className="label-checkbox">
						<input onChange=@temperatureCheck1 type="checkbox" name="xe-checkbox2"/><span className="item-media ll-font"></span><span>常温</span>
					</label>
					{
						if @state.temperatureChecked1 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea11'} type="text" className="weight short"/>
					}
					<span className="text-span">平方米</span>
					{
						if @state.temperatureChecked1 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea12'} type="text" className="weight short"/>	
					}
					<span className="text-span">立方米</span>
				</div>
				<div className="g-storeArea">
					<label className="label-checkbox">
						<input onChange=@temperatureCheck2 type="checkbox" name="xe-checkbox2"/><span className="item-media ll-font"></span><span>冷藏</span>
					</label>
					{
						if @state.temperatureChecked2 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea21'} type="text" className="weight short"/>
					}
					<span className="text-span">平方米</span>
					{
						if @state.temperatureChecked2 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea22'} type="text" className="weight short"/>	
					}
					<span className="text-span">立方米</span>
				</div>
				<div className="g-storeArea">
					<label className="label-checkbox">
						<input onChange=@temperatureCheck3 type="checkbox" name="xe-checkbox2"/><span className="item-media ll-font"></span><span>冷冻</span>
					</label>
					{
						if @state.temperatureChecked3 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea31'} type="text" className="weight short"/>
					}
					<span className="text-span">平方米</span>
					{
						if @state.temperatureChecked3 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea32'} type="text" className="weight short"/>	
					}
					<span className="text-span">立方米</span>				</div>
				<div className="g-storeArea">
					<label onChange=@temperatureCheck4 className="label-checkbox">
						<input type="checkbox" name="xe-checkbox2"/><span className="item-media ll-font"></span><span>急冻</span>
					</label>
					{
						if @state.temperatureChecked4 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea41'} type="text" className="weight short"/>
					}
					<span className="text-span">平方米</span>
					{
						if @state.temperatureChecked4 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea42'} type="text" className="weight short"/>	
					}
					<span className="text-span">立方米</span>
				</div>
				<div className="g-storeArea">
					<label className="label-checkbox">
						<input onChange=@temperatureCheck5 type="checkbox" name="xe-checkbox2"/><span className="item-media ll-font"></span><span>深冷</span>
					</label>
					{
						if @state.temperatureChecked5 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea51'} type="text" className="weight short"/>
					}
					<span className="text-span">平方米</span>
					{
						if @state.temperatureChecked5 is '0'
							<input disabled='disabled' type="text" className="weight short"/>
						else
							<input valueLink={@linkState 'temperatureArea52'} type="text" className="weight short"/>	
					}
					<span className="text-span">立方米</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="choicePic">
					<span>仓库照片</span> <i>选填</i>					
					<figure onClick={@_takePhoto}>
						{
							if @state.addWarehouseImageUrl
								# <img className="ll-font" src={'file://' + @state.addWarehouseImageUrl} />
								<XeImage src={ @state.addWarehouseImageUrl }/>
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
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a onClick={@_addNewWarehouse} className="btn">新增仓库</a>
				</div>
			</div>
		</div>
}

React.render <AddWarehouse />,document.getElementById('content')

# <div className="m-releaseitem">
# 	<div className="g-releaseDl">
# 		<dl className="clearfix">
# 			<dt className="fl"><span>仓库面积</span></dt>
# 			<dd className="fl">
# 				<div>
# 					<label>
#                         <input onChange=@temperatureCheck1 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox" dangerouslySetInnerHTML={{__html: '常温'}} />
#                     </label>
# 					{
# 						if @state.temperatureChecked1 is '0'
# 							<input disabled='disabled' className="price" type="text" placeholder="" />
# 						else
# 							<input valueLink={@linkState 'temperatureArea1'} className="price" type="text" placeholder="" />
# 					}
#                     <span>平方米</span>
# 				</div>
# 				<div>
# 					<label>
#                         <input onChange=@temperatureCheck2 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox" dangerouslySetInnerHTML={{__html: '冷藏'}} />
#                     </label>
# 					{
# 						if @state.temperatureChecked2 is '0'
# 							<input disabled='disabled' className="price" type="text" placeholder="" />
# 						else
# 							<input valueLink={@linkState 'temperatureArea2'} className="price" type="text" placeholder="" />
# 					}
#                     <span>平方米</span>
# 				</div>
# 				<div>
# 					<label>
#                         <input onChange=@temperatureCheck3 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox" dangerouslySetInnerHTML={{__html: '冷冻'}} />
#                     </label>
#                     {
#                     	if @state.temperatureChecked3 is '0'
#                     		<input disabled='disabled' className="price" type="text" placeholder="" />
#                     	else
#                     		<input valueLink={@linkState 'temperatureArea3'} className="price" type="text" placeholder="" />
#                     }
#                     <span>平方米</span>
# 				</div>
# 				<div>
# 					<label>
#                         <input onChange=@temperatureCheck4 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox" dangerouslySetInnerHTML={{__html: '急冻'}}/>
#                     </label>
#                     {
#                     	if @state.temperatureChecked4 is '0'
#                     		<input disabled='disabled' className="price" type="text" placeholder="" />
#                     	else
#                     		<input valueLink={@linkState 'temperatureArea4'} className="price" type="text" placeholder="" />
#                     }
#                     <span>平方米</span>
# 				</div>
# 				<div>
# 					<label>
#                         <input onChange=@temperatureCheck5 className="mui-checkbox ll-font" name="xe-checkbox01" type="checkbox" dangerouslySetInnerHTML={{__html: '深冷'}} />
#                     </label>
#                     {
#                     	if @state.temperatureChecked5 is '0'
#                     		<input disabled='disabled' className="price" type="text" placeholder="" />
#                     	else
#                     		<input valueLink={@linkState 'temperatureArea5'} className="price" type="text" placeholder="" />
#                     }
#                     <span>平方米</span>
# 				</div>						
# 			</dd>
# 		</dl>
# 	</div>	
# </div>


# <div>
# 	<span>仓库价格</span>
# 	<input type="text" value={ @state.priceValue1 } className="weight" onChange=@priceValueChange1 /><span className="text-span">天/托</span>
# 	<input type="text" value={ @state.priceValue2 } className="weight" onChange=@priceValueChange2 /><span className="text-span">天/平</span>
# </div>


			# TYPE_1("1", "仓库类型"),
			# TYPE_2("2", "配套服务"),
			# TYPE_3("3", "仓库面积"),
			# TYPE_4("4", "价格"),
			
			# TYPE_1_ATTRIBUTE_1("1", "平堆式"),
			# TYPE_1_ATTRIBUTE_2("2", "货架式"),
			
			# TYPE_2_ATTRIBUTE_1("1", "提供拖车"),
			# TYPE_2_ATTRIBUTE_2("2", "提供装卸"),
			
			# TYPE_3_ATTRIBUTE_1("1", "常温"),
			# TYPE_3_ATTRIBUTE_2("2", "冷藏"),
			# TYPE_3_ATTRIBUTE_3("3", "冷冻"),
			# TYPE_3_ATTRIBUTE_4("4", "急冻"),
			# TYPE_3_ATTRIBUTE_5("5", "深冷"),
			
			# TYPE_4_ATTRIBUTE_1("1", "/元/天/平"),
			# TYPE_4_ATTRIBUTE_2("2", "/元/天/托"),
			# TYPE_4_ATTRIBUTE_3("3", "/元/天/吨"),
			# TYPE_4_ATTRIBUTE_4("4", "/元/天/方");