React = require 'react'

Header = React.createClass {
	render: ->
		<p  onClick={ this._callNative }>这是header.cjsx上的文字，name: { this.props.hello.name }, age: { this.props.hello.age }点击调用native代码</p>

	_callNative: ->
		console.log 'call native from store'
		xe.run ['3', 'call from js']
}

module.exports = Header