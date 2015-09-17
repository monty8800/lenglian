React = require 'react'

Request = React.createClass {
	render: ->
		requests = this.props.items.map (item, i)->
			cls = 'll-font nav0' + (i + 1) 
			<li key={i}>
				<div className={cls}></div>
				<div className="nav-text">{item}</div>
			</li>
		, this
		<div className="m-nav">
			<ul className="clearfix">
				{requests}
			</ul>
		</div>
}

module.exports = Request