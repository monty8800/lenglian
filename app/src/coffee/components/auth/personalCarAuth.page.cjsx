require 'components/common/common'
require 'index-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin
Plugin = require 'util/plugin'

Auth = React.createClass {
	mixin: [PureRenderMixin]

	getInitialState: ->
		{
			type: 'personal'
		}
	render: ->
		<section>
		<div className="m-cert-cons">
			<ul>
				<li><h6 className="xert-h6">车牌号码</h6><input className="input-weak" type="text" placeholder="请输入车牌号码" /></li>
				<li><h6 className="xert-h6">车架号码</h6><input className="input-weak" type="text" placeholder="请输入车架号码" /></li>
				<li><h6 className="xert-h6">车主姓名</h6><input className="input-weak" type="text" placeholder="请输入车主姓名" /></li>
				<li><h6 className="xert-h6 xert-h6-large01">车主身份证号码</h6><input className="input-weak" type="text" placeholder="请输入车主姓名" /></li>
			</ul>
		</div>
		<div className="m-file-upload m-file-many">
			<div className="m-file-div">
				<div className="m-file-btn">
					<div className="m-file-icon ll-font"></div>
					<p>行驶证照片</p>
				</div>
				<input type="file" />
			</div>
			<div className="m-file-div">
				<div className="m-file-btn">
					<div className="m-file-icon ll-font"></div>
					<p>身份证照片</p>
				</div>
				<input type="file" />
			</div>
			<div className="m-file-div">
				<div className="m-file-btn">
					<div className="m-file-icon ll-font"></div>
					<p>运营证照片<br><span>(非必填)</span></p>
				</div>
				<input type="file" />
			</div>
		</div>
		<div className="u-certBtn-con">
			<a href="#" className="u-btn">提交认证</a>
		</div>
		</section>
}

React.render <Auth />, document.getElementById('content')