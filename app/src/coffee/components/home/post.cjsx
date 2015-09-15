React = require 'react'

Post = React.createClass {
	render: ->
		posts = this.props.items.map (item, i)->
			cls = 'll-font nav0' + (i + 1)
			<li key={i}>
				<div className={cls}></div>
				<div className="nav-text">{item}</div>
			</li>
		<div className="m-nav02">
			<ul className="clearfix">
				{posts}
			</ul>
		</div>
}

module.exports = Post