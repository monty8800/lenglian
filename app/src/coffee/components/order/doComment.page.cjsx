require 'components/common/common'
require 'user-center-style'
require 'index-style'
require 'majia-style'

React = require 'react/addons'

CommentStore = require 'stores/order/commentStore'
CommentAction = require 'actions/order/commentAction'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'
transData = DB.get 'transData'
Plugin = require 'util/plugin'

Raty = require 'components/common/raty'
RatyStore = require 'stores/common/raty'

DoComment = React.createClass {
	submitBtnClick: ->
		#TODO: 假数据
		userRole = transData.userRole
		targetId = transData.targetId
		targetRole = transData.targetRole
		orderNo = transData.orderNo
		startStage = @state.startStage
		commentValue = @state.commentValue
		CommentAction.submitComment userRole,targetId,targetRole,startStage,orderNo,commentValue
	textareaValueChange : (e)->
		newState = Object.create @state
		newState.commentValue = e.target.value
		@setState newState

	getInitialState: ->
		{
			startStage:	RatyStore.getScore()
			commentValue:''		 
		}
	componentDidMount: ->
		CommentStore.addChangeListener @_onChange	

	componentWillUnmount: ->
		CommentStore.removeChangeListener @_onChange

	_onChange : (mark)->
		if mark is 'addNewCommentSucc'
			Plugin.toast.success '评价成功！'
			Plugin.nav.pop()
		else if mark is 'addNewCommentFaile'
			Plugin.toast.err '评价失败!'
		else if mark is 'rate:change'
			score = RatyStore.getScore()
			console.log 'new score ', score
			@setState {
				startStage: score
			}

	render : ->
		target = ''
		switch parseInt(transData.targetRole)
			when 1 then target = '货主'
			when 2 then target = '车主'
			when 3 then target = '仓库主'
		<div>
			<div className="m-releaseitem">
				<div>
					<p dangerouslySetInnerHTML = {{ __html : "给" + target + "评分"}}/>
					<Raty score={@state.startStage} canRate=true />
				</div>
			</div>
			<div className="m-releaseitem">
				<div>
					<p dangerouslySetInnerHTML = {{ __html : target + "等待着您宝贵的评价！"}}/> 
					<div className="u-comment">
						<textarea placeholder="写点评论吧！" className="text" onChange=@textareaValueChange></textarea>
					</div>
					
				</div>
			</div>
			<div className="u-pay-btn">
				<a onClick=@submitBtnClick className="btn">发表评价</a>
			</div>
		</div>
}




React.render <DoComment />,document.getElementById('content')