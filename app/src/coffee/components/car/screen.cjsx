React = require 'react'

# 头部筛选菜单
ScreenMenu = React.createClass {

	getInitialState: ->
		{
			isShow: 1
		}

	_show: ->
		if @state.isShow is 1
			@setState {
				isShow: 2
			}
		else 
			@setState {
				isShow: 1
			}

	render: ->
		<div className="m-nav03">
			<ul>
				<li>
					<div onClick={ this._show } className={ if @state.isShow is 1 then "g-div01 ll-font u-arrow-right" else "g-div01 ll-font u-arrow-right g-div01-act"} dangerouslySetInnerHTML={{__html:'车辆长度<span>全部</span>'}}>
					</div> 
					<div id="menu" className="g-div02" style={{ display: if @state.isShow is 1 then 'none' else 'block' }}>
						<div className="g-div02-item">
							<label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'全部'}} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'3.8米'}} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'4.2米'}} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'4.8米'}}/></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'5.8米'}} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'6.2米'}} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'6.8米'}} /></label>
						</div>
						<div className="g-div02-btn">
							<a href="#" className="u-btn u-btn-small">确定</a>
						</div>
					</div>
				</li>
				<li>
					<div className="g-div01 ll-font u-arrow-right" dangerouslySetInnerHTML={{__html:'可载重货<span>全部</span>'}}>
					</div>
				</li>
				<li>
					<div className="g-div01 ll-font u-arrow-right" dangerouslySetInnerHTML={{__html:'需要发票<span>全部</span>'}}>
						
					</div>
				</li>
			</ul>
		</div>
}

module.exports = ScreenMenu
