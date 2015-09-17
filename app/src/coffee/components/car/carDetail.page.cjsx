# 车辆详情
require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'
PureRenderMixin = React.addons.PureRenderMixin

CarPic01 = require 'car-02.jpg'
CarPic02 = require 'car-03.jpg'
CarPic03 = require 'car-04.jpg'

CarDetail = React.createClass {
	render: ->
		<div>
			<div className="m-item03">
				<div className="g-itemList">
					<span>车牌号码:</span> <span>津2767383</span>	
					<div className="u-item-btn">
						<span href="#">求货中</span>
					</div>
				</div>
				<div className="g-itemList">
					<span>车辆类型:</span> <span>普通货车</span>			
				</div>
				<div className="g-itemList">
					<dl className="clearfix">
						<dt className=" fl">
							<img src={ CarPic01 }/>
						</dt>
						<dd className=" fl">
							<p>车辆类别: <span>前四后四</span></p>
							<p>可载货重: <span>20吨</span></p>
							<p>可载泡货: <span>50方</span></p>
							<p>车辆长度: <span>4米</span></p>
						</dd>
					</dl>			
				</div>
			</div>
		
			<div className="m-releaseitem">
				<div>
					<label for="packType"><span>随车司机:</span></label>
					<input type="text" placeholder="请输入姓名" id="packType"/>
				</div>
				<div>
					<label for="packType"><span>联系电话:</span></label>
					<input type="tel" placeholder="请输入联系电话" id="packType"/>
				</div>
			</div>
			
			<div className="g-uploadPic">
				<ul className="clearfix">
					<li>
						<img src={ CarPic02 }/>
					</li>
					<li>
						<img src={ CarPic03 }/>
					</li>
				</ul>
			</div>
			
			<div className="m-detail-bottom">
				<div className="g-pay-btn">
					<a href="#" className="u-btn02">删除仓库</a>
				</div>
			</div>
		</div>
}

React.render <CarDetail />, document.getElementById('content')

