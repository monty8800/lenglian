# 我的车辆 
require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

CarPic = require 'car.jpg'

Car = React.createClass {
	render: ->
		<div>
			<div className="m-tab01">
				<ul>
					<li><span className="active">空闲中</span></li>
					<li>求货中</li>
					<li>运输中</li>
					<li>全部</li>
				</ul>
			</div>
			<div className="m-item03">
				<div className="g-itemList">
					<h5>
						车牌号码: <span>京B123456</span>				
					</h5>
					<div className="u-item-btn">
						<a href="#">发布车源</a>
					</div>
						
				</div>			
				<div className="g-itemList">
					<dl className="clearfix">
						<dt className=" fl">
							<img src={ CarPic }/>
						</dt>
						<dd className=" fl">
							<p>司机姓名: <span>柠静</span></p>
							<p>联系电话: <span>12345665456</span></p>
							<p>车辆类型: <span>普通货车</span></p>
							<p>车辆长度: <span>4米</span></p>
						</dd>
					</dl>			
				</div>
			</div>
			<div className="m-item03">
				<div className="g-itemList">
					<h5>
						车牌号码: <span>京B123456</span>				
					</h5>
					<div className="u-item-btn">
						<a href="#">发布车源</a>
					</div>
						
				</div>			
				<div className="g-itemList">
					<dl className="clearfix">
						<dt className=" fl">
							<img src={ CarPic }/>
						</dt>
						<dd className=" fl">
							<p>司机姓名: <span>柠静</span></p>
							<p>联系电话: <span>12345665456</span></p>
							<p>车辆类型: <span>普通货车</span></p>
							<p>车辆长度: <span>4米</span></p>
						</dd>
					</dl>			
				</div>
			</div>
		</div>
}

React.render <Car />, document.getElementById('content')


