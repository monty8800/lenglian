# 发布车源
require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

Vehicle = React.createClass {
	render: ->
		<div>
			<div className="m-releasehead ll-font">
				<div className="g-adr-end ll-font g-adr-end-line g-adr-car">
					<input type="type" placeholder="出发地"/>
				</div>
				<div className="g-adr-start ll-font g-adr-start-line  g-adr-car">
					<input type="type" placeholder="终点(选填)"/>
				</div>
			</div>	
			<div className="m-releaseitem">
				<div className="u-arrow-right ll-font">
					<span>选择车辆 </span>
				</div>
				<div className="carType">京B12345  普通车型</div>
				<div className="carType">京B12345  普通车型</div>
				<div className="u-arrow-right ll-font">
					<span>装货时间</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="g-radio">
					<span>提供发票</span>
					<input type="radio" name="invoice" value="no" id="no" class="radio ll-font"/>
					<label for="no">否</label>
					<input type="radio" name="invoice" value="yes" id="yes" class="radio ll-font checked"/>
					<label for="yes">是</label>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>联系人</span><span>柠静</span>
				</div>
				<div>
					<span>手机号</span><span>13412356854</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-voice ll-font">
					<label for="remark"><span>备注说明</span> </label>
					<input type="text" placeholder="选填" id="remark"/>
				</div>
			</div>		
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a href="#" className="btn">发布</a>
				</div>
			</div>
		</div>
}

React.render <Vehicle />, document.getElementById('content')




