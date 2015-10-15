React = require 'react/addons'
require 'components/common/common'
require 'majia-style'

AboutUs = React.createClass {
	render: ->
		<section>
		<div className="m-aboutUs">
			<p className="g-aboutCon">冷链马甲（www.lenglianmajia.com）是郑州金色马甲电子商务有限公司旗下的冷链物流行业公共信息服务平台。</p>
			<p className="g-aboutCon">“冷链马甲”是面向全国的冷链物流交易平台，为车源、货源、库源提供交易撮合、物流在线支付、供应链金融服务、冷链物流行情指数发布、冷链知识等服务的综合平台。</p>
			<p className="g-aboutCon">“冷链马甲”致力于以电子商务和网络公共平台为依托，整合国内冷链物流行业资源，打造厂家和商家面向物流供应商的网络物流集中采购渠道、物流供应商面向厂家和商家的网络营销渠道、物流供应商之间的同行网络共赢合作渠道，打造国内最有影响力的冷链物流行业平台。</p>
			<p className="g-aboutCon">“冷链马甲”在货源、车源、物流招投标、专线搜索、商业供求信息发布与查询功能的基础上，不断结合市场需求，为冷链物流企业、生产企业、商贸企业、专业市场、货车司机等量身定做产品和服务，完善优化功能服务，推出网上商铺、资源库、诚信指数、价格指数、手机定位、货物跟踪查询、三证验证、在线投保、短信订阅、网上银行、金融支付等实用功能和增值服务。</p>
			<p className="g-aboutCon">平台通过整合物流各节点资源，优化交易方式，创新商业模式，解决物流行业当前信息不对称和诚信缺失两大瓶颈和难题，专注于为厂家、商家、物流企业、司机和各类会员降低物流成本，提高服务效率，致力于提供”诚信、高效、省时、省心“的一站式物流服务。</p>
			<p className="g-aboutCon">“冷链马甲”将继续以更加个性化、多元化的模式引领冷链物流行业网络化的进程，促进现代冷链物流业的发展。</p>
		</div>
		</section>
}

React.render <AboutUs  />, document.getElementById('content')
