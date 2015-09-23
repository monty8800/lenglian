React = require 'react'
Plugin = require 'util/plugin'

Post = React.createClass {

	_goPage: (page)->
		Plugin.nav.push [page]

	render: ->
		posts = this.props.items.map (item, i)->
			cls = 'll-font nav0' + (i + 1)
			<li key={i} onClick={ @_goPage.bind this, item.page }>
				<div className={cls}></div>
				<div className="nav-text">{item.title}</div>
			</li>
		, this
		<div className="m-nav02">
			<ul className="clearfix">
				{posts}
			</ul>
		</div>
}

module.exports = Post