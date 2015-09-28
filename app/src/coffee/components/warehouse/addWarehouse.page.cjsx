require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

AddWarehouse = React.createClass {
	render : ->
		<div>
			<div className="m-releaseitem">
				<div>
					<label for="packType"><span>仓库名称</span></label>
					<input type="text" className="input-weak" placeholder="仓库名"/>
				</div>
				<div>
					<label for="packType"><span>仓库地址</span></label>
					<input type="text" className="input-weak" placeholder="请输入地址"/>
				</div>
				<div>
					<label for="packType"><span>详细地址</span></label>
					<input type="text" className="input-weak" placeholder="详细地址"/>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-arrow-right ll-font">
					<span>仓库类型</span>
				</div>
				<div>
					<span>仓库价格</span>
					<input type="text" className="weight"/><span className="text-span">天/托</span>
					<input type="text"  className="weight"/><span className="text-span">天/平</span>
				</div>
				<div>
					<div className="g-radio">
						<span>提供发票</span> 
						<div className="radio-box">
							<label className="label-checkbox">
								<input type="radio" name="xe-checkbox"/><span className="item-media ll-font"></span><span>否</span>
							</label>
							<label className="label-checkbox">
								<input type="radio" name="xe-checkbox"/><span className="item-media ll-font"></span><span>是</span>
							</label>
						</div>
					</div>
				</div>
				<div>
					<div className="g-radio">
						<span>增值服务</span> 
						<div className="radio-box">
							<label className="label-checkbox">
								<input type="checkbox" name="xe-checkbox1"/><span className="item-media ll-font"></span><span>城配</span>
							</label>
							<label className="label-checkbox">
								<input type="checkbox" name="xe-checkbox1"/><span className="item-media ll-font"></span><span>仓配</span>
							</label>
							<label className="label-checkbox">
								<input type="checkbox" name="xe-checkbox1"/><span className="item-media ll-font"></span><span>金融</span>
							</label>
						</div>
					</div>
				</div>
			</div>
			
			<div className="m-releaseitem">
				<div className="g-releaseDl">
					<dl className="clearfix">
						<dt className="fl"><span>仓库面积</span></dt>
						<dd className="fl">
							<div>
								<label className="label-checkbox">
									<input type="checkbox" name="xe-checkbox02"/><span className="item-media ll-font"></span><span>常温</span>
								</label>
								<input type="text" placeholder="" className="price"/>
								<span>平方米</span>
							</div>
							<div>
								<label className="label-checkbox">
									<input type="checkbox" name="xe-checkbox02"/><span className="item-media ll-font"></span><span>冷藏</span>
								</label>
								<input type="text" placeholder="" className="price"/>
								<span>平方米</span>
							</div>
							<div>
								<label className="label-checkbox">
									<input type="checkbox" name="xe-checkbox02"/><span className="item-media ll-font"></span><span>冷冻</span>
								</label>
								<input type="text" placeholder="" className="price"/>
								<span>平方米</span>
							</div>	
							<div>
								<label className="label-checkbox">
									<input type="checkbox" name="xe-checkbox02"/><span className="item-media ll-font"></span><span>急冻</span>
								</label>
								<input type="text" placeholder="" className="price"/>
								<span>平方米</span>
							</div>	
							<div>
								<label className="label-checkbox">
									<input type="checkbox" name="xe-checkbox02"/><span className="item-media ll-font"></span><span>深冷</span>
								</label>
								<input type="text" placeholder="" className="price"/>
								<span>平方米</span>
							</div>						
						</dd>
					</dl>
				</div>	
				
			</div>

			<div className="m-releaseitem">
				<div className="choicePic">
					<span>货物照片</span> <i>选填</i>
					<figure>
						<span className="ll-font"></span>
					</figure>
					<input type="file" accept="image/*"/>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-personIcon ll-font">
					<span>联系人</span><span>柠静</span>
				</div>
				<div>
					<span>联系手机</span><span>13412356854</span>
				</div>
			</div>
			<div className="m-releaseitem">
				<div className="u-voice ll-font">
					<label for="remark"><span>备注说明</span> </label>
					<input type="text" className="input-weak" placeholder="请输入备注消息" id="remark"/>
				</div>
			</div>
						
			<div className="u-pay-btn">
				<div className="u-pay-btn">
					<a href="#" className="btn">发布</a>
				</div>
			</div>
		</div>
}

React.render <AddWarehouse />,document.getElementById('content')