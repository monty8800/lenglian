require 'components/common/common'
crypto = require 'util/crypto'

React = require 'react'
HelloStore = require 'stores/hello/hello'
HelloAction = require 'actions/hello/hello'
Main = require 'components/hello/main'
Header = require 'components/hello/Header'

getHelloState = ->
	{
		helloText: HelloStore.getText()
		hello: HelloStore.getHello()
	}

nativeCallJs = ->
	alert 'call from native!'
window.nativeCallJs = nativeCallJs

Hello = React.createClass {
	getInitialState: ->
		getHelloState()

	componentDidMount: ->
		HelloStore.addChangeListener @_onChange

	componentWillUnmount: ->
		HelloStore.removeChangeListener @_onChange

	_onChange: ->
		@setState getHelloState()

	render: ->
		<div>
		<br/>
		<br/>
		aes加密 { crypto.aesEncrypt('1234567890123456', 'hello ywen')}
		<br/>
		aes解密 { crypto.aesDecrypt('1234567890123456', 'Rd+h/p/i87nxh4dImkhzwQ==')}
		<br/>
		<br/>
		des加密 { crypto.desEncrypt('12345678', 'hello ywen')}
		<br/>
		des解密 
		<p>这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字这是很长很长的文字</p>
		<br/>
		<Header hello={ this.state.hello } />
		<p>这是hello.page.cjsx中的文字</p>
		<br />
		<br />
		<Main helloText={ this.state.helloText } />
		</div>
}

React.render <Hello  />, document.getElementById('content')