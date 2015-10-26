require 'components/common/common'
require 'user-center-style'
require 'index-style'
require 'majia-style'

React = require 'react/addons'
Helper = require 'util/helper'
CommentStore = require 'stores/order/commentStore'
CommentAction = require 'actions/order/commentAction'
PureRenderMixin = React.addons.PureRenderMixin
CSSTransitionGroup = React.addons.CSSTransitionGroup
DB = require 'util/storage'
headerImg = require 'user-01.jpg'
Raty = require 'components/common/raty'
XeImage = require 'components/common/xeImage'



CommentItem = React.createClass {
	render: ->

		resultList = @props.list
		items = resultList.map (item,i) ->
			<div>
				<div className="m-dis-item">
					<div className="item-pic fl">
						<p>
							<XeImage src={''} size="130x130" type="avatar" />
						</p>
						<p>匿名用户</p>
					</div>
					<div className="item-msg">
						<div className="item-star ll-font">
							<Raty score={ item.score } />
						</div>
						<div className="item-text">{ item.content }</div>
						<div className="item-status">
							<p className="fl">{ item.createTime }</p>
						</div>
					</div>
				</div>
			</div>
		,this
		<div>
		<CSSTransitionGroup transitionName="list">
			{ items }
		</CSSTransitionGroup>
		</div>
		
}


MyComment = React.createClass {
	mixins : [PureRenderMixin]
	#1：货主 2:车主 3：仓库主
	showDriverComments: ->
		if @state.showType is '2'
			return
		newState = Object.create @state
		newState.showType = '2'
		newState.commentList = []
		@setState newState
		CommentAction.getCommentList '2','0','10'

	showWarehouseComments: ->
		if @state.showType is '3'
			return
		newState = Object.create @state
		newState.showType = '3'
		newState.commentList = []
		@setState newState
		CommentAction.getCommentList '3','0','10'

	showGoodsOwnerComments: ->
		if @state.showType is '1'
			return
		newState = Object.create @state
		newState.showType = '1'
		newState.commentList = []
		@setState newState
		CommentAction.getCommentList '1','0','10'

	getInitialState: ->
		{
			commentList:[]
			showType:'2'		#默认车主 2 
		}
	componentDidMount: ->
		CommentStore.addChangeListener @_onChange	
		CommentAction.getCommentList '2','0','10'

	componentWillUnmount: ->
		CommentStore.removeChangeListener @_onChange

	_onChange: (mark)->
		if mark is 'getCommentList'
			@setState { 
				commentList:CommentStore.getCommentList()
				showType:@state.showType
			}
			console.log '##########',@state.commentList.length
		
	render: ->
		<div>
			<div className="m-tab01">
				<ul>
					<li onClick={ @showDriverComments }>
						<span className={ if @state.showType == '2' then "active" else "" }>
							司机的评价
						</span>
					</li>
					<li onClick={ @showGoodsOwnerComments }>
						<span className={ if @state.showType == '1' then "active" else "" }>
							货主的评价
						</span>
					</li>
					<li onClick={ @showWarehouseComments }>
						<span className={ if @state.showType == '3' then "active" else "" }>
							仓库的评价
					</span>
					</li>
				</ul>
			</div>
			<CommentItem list={ @state.commentList } />

		</div>
}



React.render <MyComment />, document.getElementById('content')