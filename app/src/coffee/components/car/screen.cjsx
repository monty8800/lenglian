React = require 'react'

# 头部筛选菜单
ScreenMenu = React.createClass {
	render: ->
		<div className="m-nav03">
			<ul>
				<li>
					<div className="g-div01 ll-font u-arrow-right">
						车辆长度<span>全部</span>
					</div> 
					<div className="g-div02">
						<div className="g-div02-item">
							<label className="u-label"><input className="ll-font" type="checkbox">全部</label><label className="u-label"><input className="ll-font" type="checkbox">3.8米</label><label className="u-label"><input className="ll-font" type="checkbox">4.2米</label><label className="u-label"><input className="ll-font" type="checkbox">4.8米</label><label className="u-label"><input className="ll-font" type="checkbox">5.8米</label><label className="u-label"><input className="ll-font" type="checkbox">6.2米</label><label className="u-label"><input className="ll-font" type="checkbox">6.8米</label>
						</div>
						<div className="g-div02-btn">
							<a href="#" className="u-btn u-btn-small">确定</a>
						</div>
					</div>
				</li>
				<li>
					<div className="g-div01 ll-font u-arrow-right">
						可载重货<span>全部</span>
					</div>
				</li>
				<li>
					<div className="g-div01 ll-font u-arrow-right">
						需要发票<span>全部</span>
					</div>
				</li>
			</ul>
		</div>
}

module.exports = ScreenMenu




