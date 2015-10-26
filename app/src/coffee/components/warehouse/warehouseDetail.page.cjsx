require 'components/common/common'
require 'user-center-style'
require 'majia-style'

React = require 'react/addons'
XeImage = require 'components/common/xeImage'
WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
UserStore = require 'stores/user/user'
Helper = require 'util/helper'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin
Validator = require 'util/validator'

DB = require 'util/storage'
Plugin = require 'util/plugin'

_transData = DB.get('transData')
_toShowOrder = _transData.order

warehouseStatus = '' #状态
warehouseType = []	#类型
warehousePriceValue = '' #价格
warehousePriceUnit = ''#价格单位
warehouseIncreaseValue = [] #增值服务
warehouseArea = [] #面积

conf = (aProperty) ->

	switch aProperty.type
		when '1' 
			warehouseType.push aProperty.attributeName
		when '2' 
			warehouseIncreaseValue.push aProperty.attributeName
		when '3' 
			value = aProperty.attributeName + '   '
			if aProperty.value
				value = value + aProperty.value + '平方米'
			if aProperty.valueTwo
				value = value + (if aProperty.value then ' ') + aProperty.valueTwo + '立方米'
			warehouseArea.push value
		when '4' 
			pi = aProperty.value.indexOf '.'
			if pi isnt -1
				if aProperty.value.length > pi + 2
					warehousePriceValue = aProperty.value.substr 0,(pi + 3)
				else
					warehousePriceValue = aProperty.value
			warehousePriceUnit = aProperty.attributeName


WarehouseDetail = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	getInitialState: ->
		{
			warehouseDetail:{}
			isEditing:false
			price:''
			priceUnit:''
			remark:''
			phone:''
			contacts:''
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		WarehouseAction.getDetail _transData.warehouseId

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_hasSrting: (string)->
		Letters = "1234567890."
		for st in string
			if (Letters.indexOf st) is -1
				return true
		return false

	_onChange: (mark) ->
		if mark is 'getWarehouseDetailWithId'
			detailResult = WarehouseStore.getDetail()
			conf aProperty for aProperty in detailResult.warehouseProperty
			newState = Object.create @state
			newState.warehouseDetail = detailResult
			newState.remark = detailResult.remark
			newState.phone = detailResult.contactTel
			newState.contacts = detailResult.contact
			newState.priceUnit = warehousePriceUnit
			newState.price = warehousePriceValue
			@setState newState
			if parseInt(detailResult.status) is 1
				# 状态是1 仓库才能编辑和删除 原生界面 右上角 原本隐藏的编辑按钮 改为显示
				Plugin.run [1,'warehouseDetail_showEditButton']

		else if mark is 'editWarehouseButtonClick'
			newState = Object.create @state
			newState.isEditing = true
			@setState newState
		else if mark is 'trySaveEditWarehouse'
			# TODO:保存之前先做各种判断 是否符合保存条件
			priceStr = @state.price
			if not priceStr
				# 未输入
				Plugin.toast.err '请输入正确的价格'
				return
			partArr = priceStr.split '.'
			if @_hasSrting priceStr
				# 有除了数字和小数点外的其他字符串
				Plugin.toast.err '价格格式不正确'
				return
			if partArr.length > 2 or (priceStr.substr 0,1) is '.' or ((priceStr.substr 0,1) is '0' and (priceStr.substr 1,1) isnt '.')
				# 多个小数点 或 小数点打头 或 0打头 第二位不是"."
				Plugin.toast.err '价格格式不正确'
				return
			if (priceStr.indexOf '.') + 2 < priceStr.length
				Plugin.toast.err '价格只能保留两位小数'
				return
				
			
			if not Validator.name @state.contacts
				Plugin.toast.err '请输入正确的联系人姓名'
				return
			if not Validator.mobile @state.phone
				Plugin.toast.err '请输入正确的手机号'
				return

			attribute = 1
			switch @state.priceUnit
				when '元/天/平'
					attribute = 1
				when '元/天/托'
					attribute = 2
				when '元/天/吨'
					attribute = 3
				when '元/天/方'
					attribute = 4

			params = {
				remark:@state.remark
				phone:@state.phone
				contacts:@state.contacts
				warehouseId:_transData.warehouseId
				warehouseProperty:[{type: "4",attribute: attribute,value: @state.price,valueTwo: "",typeName: "价格",attributeName: @state.priceUnit}]
			}
			WarehouseAction.doSaveEditWarehouse params

		else if mark is 'saveEditWarehouseSucc'
			# 编辑完成  编辑的信息 保留输入框中数据不再允许编辑即可
			newState = Object.create @state
			currentWarehouseDetail = newState.warehouseDetail
			currentWarehouseDetail = currentWarehouseDetail.set 'price',@state.price
			currentWarehouseDetail = currentWarehouseDetail.set 'priceUnit',@state.priceUnit
			currentWarehouseDetail = currentWarehouseDetail.set 'remark',@state.remark
			currentWarehouseDetail = currentWarehouseDetail.set 'contact',@state.contacts
			currentWarehouseDetail = currentWarehouseDetail.set 'contactTel',@state.phone
			
			newState.warehouseDetail = currentWarehouseDetail
			newState.isEditing = false
			Plugin.run [1,'warehouseDetail_saveEditSucc']

			@setState newState


	_priceInputChange:(e)->
		priceString = e.target.value
		if @_hasSrting e.target.value
			return
		if priceString is '.'
			return
		if priceString.length > 1
			if (priceString.substr 0,1) is '0' and  (priceString.substr 1,1) isnt '.'
				return
		if (priceString.split '.').length > 2
			return
		if (priceString.indexOf '.') isnt -1
			if (priceString.indexOf '.') + 3 < priceString.length
				return
		@setState {
			price: e.target.value
		}

		
	_deleteWarehouse: ->
		toDeleteWarehouseId = @state.warehouseDetail.id
		Plugin.alert '确定删除吗', '提示', (index)->
			if index is 1
				WarehouseAction.deleteWarehouse toDeleteWarehouseId
		, ['确定', '取消']

	render :->
		warehouseAreaList = warehouseArea.map (aArea,i) ->
			<p>
				<span>{if i is 0 then "仓库面积:"}</span>
				<span>{ aArea }</span>
			</p>
		, this

		<div>
			<div className="m-item03">
				<div className="g-itemList">
					<h5>
						{ @state.warehouseDetail.name }				
					</h5>		
				</div>			
				<div className="g-itemList">
					<dl className="clearfix">
						<dt className=" fl">
							<XeImage src={ @state.warehouseDetail.imageUrl } size='200x200' />
						</dt>
						<dd className=" fl">
							<p>仓库状态: 
								<span>{ Helper.warehouseStatus @state.warehouseDetail.status }</span>
							</p>
							<p>仓库类型: 
								<span>{ warehouseType.join ' ' }</span>
							</p>
							{
								if @state.isEditing 
									<p className="u-arrow-right ll-font">仓库价格:
										<input onChange={@_priceInputChange} value={@state.price} type="text" placeholder="请输入价格" className="u-inp01"/>
										<i className="arrow-i">{@state.priceUnit}</i>
										<select valueLink={@linkState 'priceUnit'} className="select weight">
											<option value='元/天/平'>元/天/平</option>
											<option value='元/天/托'>元/天/托</option>
											<option value='元/天/吨'>元/天/吨</option>
											<option value='元/天/方'>元/天/方</option>
										</select>
									</p>
								else
									<p>仓库价格:
										<span>{ @state.price + @state.priceUnit }</span>
									</p>
							}
							<p>配套服务: 
								<span>{ warehouseIncreaseValue.join ' ' }</span>
							</p>
						</dd>
					</dl>			
				</div>
			</div>
			<div className="m-detail-info m-nomargin">			
				{ warehouseAreaList }
			</div>
			<div className="m-detail-info m-nomargin">
				<p>
					<span>仓库地址:</span>
					<span>{
						detailAddr = @state.warehouseDetail
						if detailAddr
							if detailAddr.provinceName is detailAddr.cityName
								detailAddr.provinceName + detailAddr.areaName + detailAddr.street 
							else
								detailAddr.provinceName + detailAddr.cityName + detailAddr.areaName + detailAddr.street 
						else
							''
					}</span>
				</p>		
			</div>
			<div className="m-detail-info m-nomargin">			
				<p>
					<span>发票:</span>
					<span>{ Helper.invoiceStatus @state.warehouseDetail.invoice }</span>
				</p>		
			</div>
			<div className="m-detail-info">			
				<p>
					<span>联系人:</span>
					{
						if @state.isEditing
							<input valueLink={@linkState 'contacts'} className="u-inp01" type="text" placeholder="请输入联系人" id="packType"/>	
						else
							<span>{ @state.warehouseDetail.contact }</span>
					}
				</p>
				<p>
					<span>联系手机:</span>
					{
						if @state.isEditing
							<input valueLink={@linkState 'phone'} className="u-inp01" type="text" placeholder="请输入联系人电话" id="packType"/>	
						else
							<span>{ @state.warehouseDetail.contactTel }</span>
					}
				</p>
				<p>
					<span>备注说明:</span>
					{
						if @state.isEditing
							<input valueLink={@linkState 'remark'} className="u-inp01" type="text" placeholder="请输入备注信息" id="packType"/>	
						else
							<span>{ @state.warehouseDetail.remark }</span>
					}
				</p>		
			</div>
			{
				if parseInt(@state.warehouseDetail.status) is 1
					<div className="m-detail-bottom">
						<div className="g-pay-btn">
							<a onClick={ @_deleteWarehouse } className="u-btn02">删除仓库</a>
						</div>
					</div>
			}
		</div>
}


React.render <WarehouseDetail />, document.getElementById('content')

