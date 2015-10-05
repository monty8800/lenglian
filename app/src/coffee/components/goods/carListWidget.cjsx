require 'components/common/common'


React = require 'react/addons'

PureRenderMixin = React.addons.PureRenderMixin

Plugin = require 'util/plugin'

CarStore = require 'stores/car/car'
CarAction = require 'actions/car/car'
UserStore = require 'stores/user/user'
GoodsAction = require 'actions/goods/goods'
Helper = require 'util/helper'

OrderAction = require 'actions/order/order'



CarListWidget = React.createClass {
	mixins: [PureRenderMixin]
	componentDidMount: ->
		CarStore.addChangeListener @_change

	_getCarList: (goodsId)->
		CarAction.orderSelectCarList {
			userId: UserStore.getUser()?.id
			goodsResourceId: goodsId
		}

	componentWillReceiveProps: (nextProps)->
		@_getCarList(nextProps.goodsId) if nextProps.show

	componentWillUnmount: ->
		CarStore.removeChangeListener @_change

	_change: (msg)->
		console.log 'event change ', msg
		if msg is 'order:select:car:list:done'
			newState = Object.create @state
			newState.carList = CarStore.getOrderSelectCarList()
			if newState.carList.size is 0
				@_hide()
				Plugin.toast.err '没有可用车源，请添加车源'
				return
			if not newState.selected and newState.carList.size > 0
				newState.selected = newState.carList.first().id
			@setState newState
		

	_hide: ->
		GoodsAction.changeWidgetStatus(false)

	_select: (car)->
		newState = Object.create @state
		newState.selected = car.id
		@setState newState
		@_hide()
		OrderAction.carSelectGoods {
			userId: UserStore.getUser()?.id
			carResourceId: car.id
			goodsResourceId: @props.goodsId
		}

	getInitialState: ->
		{
			carList: CarStore.getOrderSelectCarList()
			selected: null
		}

	render: ->
		console.log 'state---', @state
		cls1 = 'u-pop-box'
		cls1 += ' u-show' if @props.show
		cls2 = 'u-mask-grid'
		cls2 += ' show' if @props.show

		carCells = @state.carList.map (car, i)->
			console.log 'car--', car
			cls3 = 'u-content-item ll-font'
			cls3 += ' u-content-act' if @state.selected is car.id
			<div onClick={@_select.bind this, car} className={cls3} key={i}>
				<h3>{'车牌号码:' + car.carno}</h3>
				<p>{'车辆类别:' + Helper.carCategoryMapper car.category} </p>
				<p>{'车辆类型:' + Helper.carTypeMapper car.type}</p>
				<p>{'车辆类别:' + car.vehicle + '米'}</p>
			</div>
		, this
		<section>
		<div className={cls1}>						
			<div className="u-content">
				{carCells}
			</div>
			
		</div>
		<div onClick={@_hide} className={cls2}></div>
		
		</section>
}


module.exports = CarListWidget


