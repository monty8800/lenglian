require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

AddCar = React.createClass {

	handleSubmit: (e)->
		e.preventDefault()
		# 车牌号
		carNo = React.findDOMNode(this.refs.carNo).value.trim()
		# 可载泡货
		bulky = React.findDOMNode(@refs.bulky).value.trim()
		# 随车司机
		driver = React.findDOMNode(@refs.driver).value.trim()
		# 手机号码
		mobile = React.findDOMNode(@refs.mobile).innerHTML.trim()
		alert mobile

	render: ->
		<div>
			<div className="m-releaseitem">
				<div>
					<span>车牌号码</span>
					<input type="text" ref="carNo" className="weight car" placeholder="例：渝B622B5"/>
				</div>
				<div className="u-arrow-right ll-font">
					<span>车辆类型</span>
				</div>
				<div className="u-arrow-right ll-font">
					<span>车辆类别</span>
				</div>
			</div>
			<div className="m-releaseitem">
				
				<div className="u-arrow-right ll-font">
					<span>可载重货</span>
				</div>
				<div>
					<span>可载泡货</span>
					<input ref="bulky" type="text" className="weight car"/>
					<span>方</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<label htmlFor="remark"><span>随车司机</span> </label>
					<input ref="driver" type="text" placeholder="请输入随车司机" id="remark"/>
				</div>
				<div>
					<span>联系电话</span>
					<span ref="mobile">13586865952</span>
				</div>
			</div>	
			<div className="u-green ll-font u-tip">
				温馨提示：单张图片大小不能超过1M
			</div>
			<div className="g-uploadPic">
				<ul className="clearfix">
					<li>
						<a href="#">
							<span className="ll-font"></span>
							<p>车辆图片</p>
						</a>
					</li>
					<li>
						<a href="#">
							<span className="ll-font"></span>
							<p>行驶证图片</p>
						</a>
					</li>
					<li>
						<a href="#">
							<span className="ll-font"></span>
							<p>道路运输许可证</p>
						</a>
					</li>
				</ul>
			</div>
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a href="#" className="btn" onClick={@.handleSubmit.bind this}>新增车辆</a>
				</div>
			</div>
		</div>
}

React.render <AddCar />, document.getElementById('content')

