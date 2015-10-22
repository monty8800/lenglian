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

DB = require 'util/storage'
Plugin = require 'util/plugin'

_transData = DB.get('transData')
_toShowOrder = _transData.order

warehouseStatus = '' #状态
warehouseType = []	#类型
warehousePrice = [] #价格
warehouseIncreaseValue = [] #增值服务
warehouseArea = [] #面积

conf = (aProperty) ->

	switch aProperty.type
		when '1' then warehouseType.push aProperty.attributeName
		when '2' then warehouseIncreaseValue.push aProperty.attributeName
		when '3' then warehouseArea.push aProperty.attributeName + '   ' + aProperty.value
		when '4' then warehousePrice.push  aProperty.value + '元/' + aProperty.attributeName


WarehouseDetail = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	getInitialState: ->
		{
			warehouseDetail:{}
			isEditing:false
			remark:''
			phone:''
			contacts:''
		}
	componentDidMount: ->
		WarehouseStore.addChangeListener @_onChange
		WarehouseAction.getDetail _transData.warehouseId

	componentWillUnmount: ->
		WarehouseStore.removeChangeListener @_onChange

	_onChange: (mark) ->
		if mark is 'getWarehouseDetailWithId'
			detailResult = WarehouseStore.getDetail()
			conf aProperty for aProperty in detailResult.warehouseProperty
			newState = Object.create @state
			newState.warehouseDetail = detailResult
			newState.remark = detailResult.remark
			newState.phone = detailResult.contactTel
			newState.contacts = detailResult.contact
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
			WarehouseAction.doSaveEditWarehouse @state.remark,@state.phone,@state.contacts,_transData.warehouseId

		else if mark is 'saveEditWarehouseSucc'
			# 编辑完成  编辑的信息 保留输入框中数据不再允许编辑即可
			newState = Object.create @state
			currentWarehouseDetail = newState.warehouseDetail
			currentWarehouseDetail = currentWarehouseDetail.set 'remark',@state.remark
			currentWarehouseDetail = currentWarehouseDetail.set 'contact',@state.contacts
			currentWarehouseDetail = currentWarehouseDetail.set 'contactTel',@state.phone
			newState.warehouseDetail = currentWarehouseDetail
			newState.isEditing = false
			Plugin.run [1,'warehouseDetail_saveEditSucc']

			@setState newState
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
				<span>{ aArea + '平方米'}</span>
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
							<p>仓库价格: 
								<span>{ warehousePrice.join ' ' }</span>
							</p>
							<p>增值服务: 
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
						if detailAddr.provinceName is detailAddr.cityName
							detailAddr.provinceName + detailAddr.areaName + detailAddr.street 
						else
							detailAddr.provinceName + detailAddr.cityName + detailAddr.areaName + detailAddr.street 
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
							<input valueLink={@linkState 'contacts'} type="text" placeholder="请输入联系人" id="packType"/>	
						else
							<span>{ @state.warehouseDetail.contact }</span>
					}
				</p>
				<p>
					<span>联系手机:</span>
					{
						if @state.isEditing
							<input valueLink={@linkState 'phone'} type="text" placeholder="请输入联系人电话" id="packType"/>	
						else
							<span>{ @state.warehouseDetail.contactTel }</span>
					}
				</p>
				<p>
					<span>备注说明:</span>
					{
						if @state.isEditing
							<input valueLink={@linkState 'remark'} type="text" placeholder="请输入备注信息" id="packType"/>	
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

