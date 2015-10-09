React = require 'react/addons'


FromTo = React.createClass {
	render: ->
		<div className="g-item">
			<div className="g-adr-start ll-font g-adr-start-line">
				{@props.from}
			</div>
			<div className="g-adr-end ll-font g-adr-end-line">
				{@props.to}
			</div>
		</div>
}

module.exports = FromTo