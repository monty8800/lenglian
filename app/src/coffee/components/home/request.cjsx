React = require 'react'
Plugin = require 'util/plugin'

Request = React.createClass {
	_goPage: (page)->
		Plugin.nav.push [page]

	render: ->
		console.log 'rquest.cjsx ---- ', @props.items
		requests = this.props.items.map (item, i)->
			cls = 'll-font nav0' + (i + 1) 
			<li key={i} onClick={ @_goPage.bind this, item.page }>
				<div className={cls}></div>
				<div className="nav-text">{item.title}</div>
			</li>
		, this
		<div className="m-nav">
			<ul className="clearfix">
				{requests}
			</ul>
		</div>
}

module.exports = Request