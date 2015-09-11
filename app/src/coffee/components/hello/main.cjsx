React = require 'react'
HelloAction = require 'actions/hello/hello'

Main = React.createClass {
	render: ->
		<a  onClick={ this._sayHello }>这是main.cjsx上的超链接, store上的hellotext是: <br/> { this.props.helloText }</a>

	_sayHello: ->
		HelloAction.hello()
}

module.exports = Main