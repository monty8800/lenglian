require 'components/common/common'


React = require 'react/addons'
Immutable = require 'immutable'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'

GoodsStore = require 'stores/goods/goods'

GoodsAction = require 'actions/goods/goods'

FromTo = require 'components/goods/fromTo'

Helper = require 'util/helper'

UserStore = require 'stores/user/user'


AddGoods = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	componentDidMount: ->
		GoodsStore.addChangeListener @_change

	componentWillUnmount: ->
		GoodsStore.removeChangeListener @_change
		GoodsAction.clearGoods()

	_change: (msg)->
		console.log 'event change ', msg
		if msg.msg is 'set:goods:photo:done'
			newState = Object.create @state
			newState.photo = msg.url
			console.log 'newState', newState
			@setState newState
		else if msg is 'clear:goods:pic'
			newState = Object.create @state
			newState.photo = null
			@setState newState
		else if msg.msg is 'goods:time:install'
			newState = Object.create @state
			newState.installMinTime = msg.start
			newState.installMaxTime = msg.end
			@setState newState
		else if msg.msg is 'goods:time:arrive'
			newState = Object.create @state
			newState.arriveMinTime = msg.start
			newState.arriveMaxTime = msg.end
			@setState newState
		else if msg.msg is 'select:contacts:sender'
			newState = Object.create @state
			newState.sender = msg.name
			newState.senderMobile = msg.mobile
			@setState newState
		else if msg.msg is 'select:contacts:reciver'
			newState = Object.create @state
			newState.reciver = msg.name
			newState.reciverMobile = msg.mobile
			@setState newState

	_selectPic: ->
		console.log '_selectPic'
		Plugin.run [8, 'select:goods:photo']

	_selectTime: (type)->
		Plugin.run [6, 'select:time:' + type]

	_selectContacts: (type)->
		Plugin.run [4, 'select:contacts:' + type]

	_pic404: ->
		GoodsAction.clearPhoto()

	_selectRefrigeration: (e)->
		console.log 'event', e
		if e.target.checked
			newState = @state
			newState.refrigeration = parseInt e.target.value
			@setState newState

	_selectPriceType1: (e)->
		console.log 'event', e
		newState = Object.create @state
		if e.target.checked
			newState.priceType = 1
		@setState newState

	_selectPriceType2: (e)->
		console.log 'event', e
		newState = Object.create @state
		if e.target.checked
			newState.priceType = 2
		@setState newState

	_selectPayType: (e)->
		console.log 'event', e
		if e.target.checked
			newState = @state
			newState.payType = parseInt e.target.value
			@setState newState

	_selectInvoice: (e)->
		console.log 'event', e
		if e.target.checked
			newState = @state
			newState.invoice = parseInt e.target.value
			@setState newState

	_submit: ->
		from = GoodsStore.getFrom()
		to = GoodsStore.getTo()
		passBy = GoodsStore.getPassBy()
		if not from.lati
			Plugin.toast.err '请输入起点'
		else if not to.lati
			Plugin.toast.err '请输入终点'
		else if not @state.type
			Plugin.toast.err '请选择货物类型'
		else if (@state.weight?.length > 0 and not Validator.float(@state.weight))  or (@state.cube?.length > 0 and not Validator.float @state.cube)
			Plugin.toast.err '请填写正确的货物规格, 最多两位小数'
		else if not @state.installMinTime or not @state.installMaxTime
			Plugin.toast.err '请填写装车时间'
		else if not Validator.price @state.price
			Plugin.toast.err '请输入正确的价格， 最多两位小数，最大不超过9999999.99'
		else if @state.payType is 3 and not Validator.price @state.prePay 
			Plugin.toast.err '请输入正确的预付款， 最多两位小数，最大不超过9999999'
		# else if @state.payType is 3 and parseFloat(@state.prePay) > parseFloat(@state.price)
		# 	Plugin.toast.err '预付款金额不能大于'
		else if not Validator.name @state.sender
			Plugin.toast.err '发货人姓名不正确'
		else if not Validator.mobile @state.senderMobile
			Plugin.toast.err '发货人手机号不正确'
		else if not Validator.name @state.reciver
			Plugin.toast.err '收货人姓名不正确'
		else if not Validator.mobile @state.reciverMobile
			Plugin.toast.err '收货人手机号不正确'
		else if @state.remark?.length > 0 and not Validator.remark @state.remark
			Plugin.toast.err '备注要1~30个字符哦'
		else
			files = []
			files.push {
					filed: 'imgurl'
					path: @state.photo
				} if @state.photo
			goodsRoute = ({
				province: address.provinceName
				city: address.cityName
				area: address.areaName
				street: address.street
				sort: index
				provinceName: address.provinceName
				cityName: address.cityName
				areaName: address.areaName
				} for address, index in passBy.toArray() when address.lati isnt null)
			GoodsAction.addGoods {
				goodsResource: {
					userId: UserStore.getUser()?.id
					fromProvince: from.provinceName
					fromCity: from.cityName
					fromArea: from.areaName
					fromStreet: from.street
					fromLat: from.lati
					fromLng: from.longi
					toProvince: to.provinceName
					toCity: to.cityName
					toArea: to.areaName
					toStreet: to.street
					toLat: to.lati
					toLng: to.longi
					goodsType: @state.type
					packType: @state.packType if @state.packType
					name: @state.name if @state.name
					weight: @state.weight if @state.weight
					cube: @state.cube if @state.cube
					installStime: @state.installMinTime
					installEtime: @state.installMaxTime
					arrivalStime: @state.arriveMinTime if @state.arriveMinTime
					arrivalEtime: @state.arriveMaxTime if @state.arriveMaxTime
					payType: @state.payType
					advance: @state.prePay if @state.payType is 3
					coldStoreFlag: @state.refrigeration
					contacts: @state.sender
					phone: @state.senderMobile
					remark: @state.remark if @state.remark
					priceType: @state.priceType
					price: @state.price
					isinvoice: @state.invoice
					receiver: @state.reciver
					receiverMobile: @state.reciverMobile
				}
				goodsRoute: goodsRoute or []
				
			}, files

	getInitialState: ->
		{
			name: null #货物名称
			type: 1 #货物类型 1常温，2冷藏，3冷冻，4急冻， 5深冷
			weight: '' #货物重量
			cube: ''   #货物体积
			packType: ''  #包装类型
			photo: null  #货物图片
			installMinTime: null #最早装车时间
			installMaxTime: null  #最晚装车时间
			arriveMinTime: null  #最早到货时间
			arriveMaxTime: null #最迟到货时间
			refrigeration: 1 #需要冷库 1不需要，2需要，3目的地需要，4起始地需要
			priceType: 1 #价格类型 1一口价， 2竞价
			price: null
			payType: 1 #支付方式 1货到付款， 2回单付款， 3预付款
			prePay: null #预付款
			invoice: 2 #是否需要发票 1需要 2不需要

			sender: null #发货人
			senderMobile: null #发货人电话
			reciver: null #收货人
			reciverMobile: null #收货人电话

			remark: '' #备注
		}
	render: ->
		console.log 'state', @state
		<section>
		<FromTo type="addGoods" />

		<div className="m-releaseitem">
			<div className="u-arrow-right ll-font">
				<span>货物类型</span>
				<i className="arrow-i">{Helper.goodsType @state.type }</i>
				<select className="select" valueLink={@linkState 'type'} name="">
					<option value="1">常温</option>
					<option value="2">冷藏</option>
					<option value="3">冷冻</option>
					<option value="4">急冻</option>
					<option value="5">深冷</option>
				</select>
			</div>
			<div>
				<label htmlFor="proName"><span>货物名称</span></label>
				<input valueLink={@linkState 'name'} type="text" placeholder="选填" id="proName"/>
			</div>
			<div>
				<span>货物规格</span>
				<input valueLink={@linkState 'weight'} type="text" className="weight"/><span>吨</span>
				<input valueLink={@linkState 'cube'} type="text"  className="weight"/><span>方</span>
			</div>
			<div>
				<label htmlFor="packType"><span>包装类型</span></label>
				<input valueLink={@linkState 'packType'} type="text" placeholder="选填" id="packType"/>
			</div>
			<div className="choicePic">
				<span>货物照片</span> 
				<i>选填</i>
				{
					if @state.photo?.length > 0
						<img onClick={@_selectPic} width="50 rem" height="50 rem" src={@state.photo} onError={@_pic404} />
					else
						<figure onClick={@_selectPic}><span className="ll-font"></span></figure>
				}
			</div>
		</div>
		<div className="m-releaseitem">
			<div onClick={@_selectTime.bind this, 'install'} className="u-arrow-right ll-font">
				<span>装车时间</span> 
			    <i>{if @state.installMinTime then @state.installMinTime + '到' + @state.installMaxTime else ''}</i>
			</div>
			<div onClick={@_selectTime.bind this, 'arrive'} className="u-arrow-right ll-font">
				<span>到货时间</span> 
				<i>{if @state.arriveMinTime then @state.arriveMinTime + '到' + @state.arriveMaxTime else '选填'}</i>
			</div>
		</div>
		<div className="m-releaseitem">
			<div className="g-radio">
				<span>使用冷库</span>
				<div className="radio-box">
					<label className="mr5">
						<input className="mui-checkbox ll-font" onChange={@_selectRefrigeration} value="1" defaultChecked=true type="radio" name="xe-checkbox" dangerouslySetInnerHTML={{__html: '否'}} />
					</label>
					<label className="mr5">
						<input className="mui-checkbox ll-font" onChange={@_selectRefrigeration} value="2"  type="radio" name="xe-checkbox" dangerouslySetInnerHTML={{__html: '是'}} />
					</label>
					<label className="mr5">
						<input className="mui-checkbox ll-font" onChange={@_selectRefrigeration} value="4"  type="radio" name="xe-checkbox"  dangerouslySetInnerHTML={{__html: '发地'}} />
					</label>
					<label className="mr5">
						<input className="mui-checkbox ll-font" onChange={@_selectRefrigeration} value="3"  type="radio" name="xe-checkbox" dangerouslySetInnerHTML={{__html: '终点'}} />
					</label>
				</div>
			</div>
		</div>
		<div className="m-releaseitem">
			<div className="g-releaseDl">
				<dl className="clearfix">
					<dt className="fl"><span>价格类型</span></dt>
					<dd className="fl">
						<div className="u-tip01">
							此价格仅为运费不包含其他费用
						</div>
						<div>
							<label>
								<input className="mui-checkbox ll-font" onChange={@_selectPriceType1} defaultChecked=true value="1" type="radio" name="xe-checkbox01" dangerouslySetInnerHTML={{__html: '一口价'}} />
							</label>
							{
								if parseInt(@state.priceType) is 1
									<input type="number" valueLink={@linkState 'price'} placeholder="请输入一口价" className="price input-weak"/>
								else
									<input disabled='disabled' type="number" placeholder="请输入一口价" className="price input-weak"/>
							}
						</div>
						<div>
							<label>
								<input className="mui-checkbox ll-font" onChange={@_selectPriceType2} value="2" type="radio" name="xe-checkbox01" dangerouslySetInnerHTML={{__html: '竞价'}} />
							</label>
							{
								if parseInt(@state.priceType) is 2
									<input type="number" valueLink={@linkState 'price'} placeholder="请输入基础价" className="price input-weak"/>
								else
									<input disabled='disabled' type="number" placeholder="请输入基础价" className="price input-weak"/>
							}
						</div>					
					</dd>
				</dl>
			</div>	
			
		</div>
		<div className="m-releaseitem">
			<div className="g-releaseDl">
				<dl className="clearfix">
					<dt className="fl"><span>支付方式</span></dt>
					<dd className="fl">
						<div>
							<label >
								<input className="mui-checkbox ll-font" value="1" onChange={@_selectPayType} defaultChecked=true type="radio" name="xe-checkbox02" dangerouslySetInnerHTML={{__html: '货到付款'}} />
							</label>
						</div>
						<div>
							<label>
								<input className="mui-checkbox ll-font" value="2" onChange={@_selectPayType} type="radio" name="xe-checkbox02" dangerouslySetInnerHTML={{__html: '回单付款'}} />
							</label>
						</div>
						<div>
							<label>
								<input className="mui-checkbox ll-font" value="3" onChange={@_selectPayType} type="radio" name="xe-checkbox02" dangerouslySetInnerHTML={{__html: '预付款'}} />
							</label>
							<input valueLink={@linkState 'prePay'} type="number" placeholder="请输入预付款" className="price"/>
						</div>						
					</dd>
				</dl>
			</div>	
		</div>
		<div className="m-releaseitem">
			<div className="g-radio">
				<span>需要发票</span>
				<div className="radio-box">
					<label>
						<input className="mui-checkbox ll-font" defaultChecked=true value="2" onChange={@_selectInvoice} type="radio" name="xe-checkbox03" dangerouslySetInnerHTML={{__html: '否'}} />
					</label>
					<label >
						<input className="mui-checkbox ll-font" value="1" onChange={@_selectInvoice} type="radio" name="xe-checkbox03" dangerouslySetInnerHTML={{__html: '是'}} />
					</label>
				</div>
			</div>
		</div>
		<div className="m-releaseitem">
			<div>
				<span>发货人</span>
				<input className="input-weak" valueLink={@linkState 'sender'} type="text" placeholder="请输入或点击图标导入" />
				<em onClick={@_selectContacts.bind this, 'sender'} className="u-personIcon ll-font"></em>
			</div>
			<div>
				<span>手机号</span>
				<input className="input-weak" valueLink={@linkState 'senderMobile'} type="tel" placeholder="电话号码" />
			</div>
		</div>
		<div className="m-releaseitem">
			<div >
				<span>收货人</span>
				<input className="input-weak" valueLink={@linkState 'reciver'} type="text" placeholder="请输入或点击图标导入" />
				<em onClick={@_selectContacts.bind this, 'reciver'} className="u-personIcon ll-font"></em>
			</div>
			<div>
				<span>手机号</span>
				<input className="input-weak" valueLink={@linkState 'reciverMobile'} type="tel" placeholder="请输入或点击图标导入" />
			</div>
		</div>
		<div className="m-releaseitem">			
			<div className="ll-font">
				<label htmlFor="remark"><span>备注说明</span> </label>
				<input className="input-weak" valueLink={@linkState 'remark'} type="text" placeholder="请输入备注消息" id="remark"/>
			</div>
		</div>
					
		<div className="u-pay-btn">
			<div onClick={@_submit} className="u-pay-btn">
				<a className="btn">发布</a>
			</div>
		</div>
		</section>
}

React.render <AddGoods  />, document.getElementById('content')

