require 'components/common/common'


React = require 'react/addons'
Immutable = require 'immutable'

PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

Plugin = require 'util/plugin'
Validator = require 'util/validator'
Constants = require 'constants/constants'


AddGoods = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]
	componentDidMount: ->
		UserStore.addChangeListener @_change

	componentWillUnmount: ->
		UserStore.removeChangeListener @_change

	_change: (msg)->
		console.log 'event change ', msg

	_selectAddress: ->
		Plugin.nav.push ['selectAddress']

	getInitialState: ->
		{
		}
	render: ->
		<section>
		<div onClick={@_selectAddress} className="m-releasehead ll-font">
			<div className="g-adr-end ll-font g-adr-end-line">
				<input type="type" placeholder="输入终点"/>
			</div>
			<div className="g-adr-pass ll-font g-adr-pass-line">
				<input type="type" placeholder="北京海淀区中关村泰鹏大厦"/>
			</div>
			<div className="g-adr-middle ll-font">
				<input type="type" placeholder="途径地"/>
			</div>
			<div className="g-adr-start ll-font g-adr-start-line">
				<input type="type" placeholder="输入起点"/>
			</div>
			<a href="#" className="u-addIcon"></a>
		</div>

		<div className="m-releaseitem">
			<div className="u-arrow-right ll-font">
				<span>货物类型</span>
			</div>
			<div>
				<label for="proName"><span>货物名称</span></label>
				<input type="text" placeholder="选填" id="proName"/>
			</div>
			<div>
				<span>货物重量</span>
				<input type="text" className="weight"/><span>吨</span>
				<input type="text"  className="weight"/><span>千克</span>
			</div>
			<div>
				<label for="packType"><span>包装类型</span></label>
				<input type="text" placeholder="选填" id="packType"/>
			</div>
			<div className="choicePic">
				<span>货物照片</span> <i>选填</i>
				<figure>
					<span className="ll-font"></span>
				</figure>
				<input type="file" accept="image/*"/>
			</div>
		</div>
		<div className="m-releaseitem">
			<div className="u-arrow-right ll-font">
				<span>装车时间</span> <i>选填</i>
			</div>
			<div className="u-arrow-right ll-font">
				<span>货到时间</span> <i>选填</i>
			</div>
		</div>
		<div className="m-releaseitem">
			<div className="g-radio">
				<span>使用冷库</span>
				<div className="radio-box">
					<label className="label-checkbox">
						<input type="radio" name="xe-checkbox" /><span className="item-media ll-font"></span><span>否</span>
					</label>
					<label className="label-checkbox">
						<input type="radio" name="xe-checkbox" /><span className="item-media ll-font" ></span><span>是</span>
					</label>
					<label className="label-checkbox">
						<input type="radio" name="xe-checkbox" /><span className="item-media ll-font" ></span><span>发地</span>
					</label>
					<label className="label-checkbox">
						<input type="radio" name="xe-checkbox" /><span className="item-media ll-font" ></span><span>终点</span>
					</label>
				</div>
			</div>
		</div>
		<div className="m-releaseitem">
			<div className="g-releaseDl">
				<dl className="clearfix">
					<dt className="fl"><span>价格类型</span></dt>
					<dd className="fl">
						<div>
							<label className="label-checkbox">
								<input type="radio" name="xe-checkbox01" /><span className="item-media ll-font"></span><span>一口价</span>
							</label>
						</div>
						<div>
							<label className="label-checkbox">
								<input type="radio" name="xe-checkbox01" /><span className="item-media ll-font"></span><span>竞价</span>
							</label>
							<input type="text" placeholder="请输入基础价" className="price"/>
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
							<label className="label-checkbox">
								<input type="radio" name="xe-checkbox02" /><span className="item-media ll-font"></span><span>货到付款</span>
							</label>
						</div>
						<div>
							<label className="label-checkbox">
								<input type="radio" name="xe-checkbox02" /><span className="item-media ll-font"></span><span>回单付款</span>
							</label>
						</div>
						<div>
							<label className="label-checkbox">
								<input type="radio" name="xe-checkbox02" /><span className="item-media ll-font"></span><span>预付款</span>
							</label>
							<input type="text" placeholder="请输入预付款" className="price"/>
						</div>						
					</dd>
				</dl>
			</div>	
		</div>
		<div className="m-releaseitem">
			<div className="g-radio">
				<span>需要发票</span>
				<div className="radio-box">
					<label className="label-checkbox">
						<input type="radio" name="xe-checkbox03" /><span className="item-media ll-font"></span><span>否</span>
					</label>
					<label className="label-checkbox">
						<input type="radio" name="xe-checkbox03" /><span className="item-media ll-font"></span><span>是</span>
					</label>
				</div>
			</div>
		</div>
		<div className="m-releaseitem">
			<div className="u-personIcon ll-font">
				<span>发货人</span><span>柠静</span>
			</div>
			<div>
				<span>手机号</span><span>13412356854</span>
			</div>
		</div>
		<div className="m-releaseitem">
			<div className="u-personIcon ll-font">
				<span>收货人</span><span>柠静</span>
			</div>
			<div>
				<span>手机号</span><span>13412356854</span>
			</div>
		</div>
		<div className="m-releaseitem">
			<div className="u-voice ll-font">
				<label for="remark"><span>备注说明</span> </label>
				<input type="text" placeholder="请输入备注消息" id="remark"/>
			</div>
		</div>
					
		<div className="u-pay-btn">
			<div className="u-pay-btn">
				<a href="#" className="btn">发布</a>
			</div>
		</div>
		</section>
}


React.render <AddGoods  />, document.getElementById('content')


