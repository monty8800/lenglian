require 'components/common/common'
require 'user-center-style'
require 'index-style'
require 'majia-style'

React = require 'react/addons'

CommentStore = require 'stores/order/commentStore'
CommentAction = require 'actions/order/commentAction'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

DoComment = React.createClass {
	submitBtnClick: ->
		userRole = '2'
		targetId = '7201beba475b49fd8b872e2d1493844a'
		targetRole = '3'
		startStage = @state.startStage
		orderNo = 'd8b872e2d1493844a'
		commentValue = @state.commentValue
		CommentAction.submitComment userRole,targetId,targetRole,startStage,orderNo,commentValue
	textareaValueChange : (e)->
		newState = Object.create @state
		newState.commentValue = e.target.value
		@setState newState

	getInitialState: ->
		{
			startStage:	'0'
			commentValue:''		 
		}
	componentDidMount: ->
		CommentStore.addChangeListener @_onChange	

	componentWillUnmount: ->
		CommentStore.removeChangeListener @_onChange

	_onChange : (mark)->
		if mark is 'addNewCommentSucc'
			alert 'comment succ'
		else if mark is 'addNewCommentFaile'
			alert 'comment faile'


	render : ->
		<div>
			<div className="m-releaseitem">
				<div>
					<p dangerouslySetInnerHTML = {{ __html : "给货主评分"}}/> 
					<p className="star">
						<i className="ll-font">&#xe62f;</i>
						<i className="ll-font">&#xe62f;</i>
						<i className="ll-font">&#xe62f;</i>
						<i className="ll-font">&#xe62f;</i>
						<i className="ll-font">&#xe62f;</i>
					</p>
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<p dangerouslySetInnerHTML = {{ __html : "货主等待着您宝贵的评价！"}}/> 
					<div className="u-comment">
						<textarea placeholder="写点评论吧！" className="text" onChange=@textareaValueChange></textarea>
					</div>
					
				</div>
			</div>
			<div className="u-pay-btn">
				<a onClick=@submitBtnClick className="btn">下一步</a>
			</div>
		</div>
}




React.render <DoComment />,document.getElementById('content')