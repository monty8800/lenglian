React = require 'react'
PureRenderMixin = React.addons.PureRenderMixin
LinkedStateMixin = React.addons.LinkedStateMixin

CarStore = require 'stores/car/car'
CarAction = require 'actions/car/car'
DB = require 'util/storage'

# 头部筛选菜单
ScreenMenu = React.createClass {
	mixins: [PureRenderMixin, LinkedStateMixin]

	getInitialState: ->
		{
			isShowLen: 1
			isShowHea: 1
			isInvoince: 1

			# 车辆长度
			lenCheckAll: false
			lenCheck38: false
			lenCheck42: false
			lenCheck48: false
			lenCheck58: false
			lenCheck62: false
			lenCheck68: false
			lenCheck74: false
			lenCheck78: false
			lenCheck86: false
			lenCheck96: false
			lenCheck13: false
			lenCheck15: false

			# 可在重货
			heaCheckAll: false
			heaCheck2: false
			heaCheck3: false
			heaCheck4: false
			heaCheck5: false
			heaCheck6: false
			heaCheck8: false
			heaCheck10: false
			heaCheck12: false
			heaCheck15: false
			heaCheck18: false
			heaCheck20: false
			heaCheck25: false
			heaCheck28: false
			heaCheck30: false
			heaCheck40: false

			# 提交给服务器的字段
			isinvoice: ''

			invAll: false
			invNeed: false
			invNot: false

		}

	_showLen: ->
		if @state.isShowLen is 1
			@setState {
				isShowLen: 2
			}
		else 
			@setState {
				isShowLen: 1
			}

	_showHea: ->
		if @state.isShowHea is 1
			@setState {
				isShowHea: 2
			}
		else 
			@setState {
				isShowHea: 1
			}

	_showInvoince: ->
		if @state.isInvoince is 1
			@setState {
				isInvoince: 2
			}
		else 
			@setState {
				isInvoince: 1
			}

	# 车辆长度--全部
	len_all: (e)->
		if e.target.checked
			CarAction.checkedLenAll()
		else
			CarAction.unCheckedLenAll()
		checkedLinkAll.requestChange e.target.value

	len38: (e)->
		if e.target.checked
			CarAction.checkedLen_who('38','3.8')
		else
			CarAction.uncheckedLen_who('38', '3.8');

	len42: (e)->
		if e.target.checked
			CarAction.checkedLen_who('42', '4.2')
		else
			CarAction.uncheckedLen_who('42', '4.2');

	len48: (e)->
		if e.target.checked
			CarAction.checkedLen_who('48', '4.8')
		else
			CarAction.uncheckedLen_who('48', '4.8');

	len58: (e)->
		if e.target.checked
			CarAction.checkedLen_who('58', '5.8')
		else
			CarAction.uncheckedLen_who('58', '5.8');

	len62: (e)->
		if e.target.checked
			CarAction.checkedLen_who('62', '6.2')
		else
			CarAction.uncheckedLen_who('62', '6.2');

	len68: (e)->
		if e.target.checked
			CarAction.checkedLen_who('68', '6.8')
		else
			CarAction.uncheckedLen_who('68', '6.8');

	len74: (e)->
		if e.target.checked
			CarAction.checkedLen_who('74', '7.4')
		else
			CarAction.uncheckedLen_who('74', '7.4');

	len78: (e)->
		if e.target.checked
			CarAction.checkedLen_who('78', '7.8')
		else
			CarAction.uncheckedLen_who('78', '7.8');

	len86: (e)->
		if e.target.checked
			CarAction.checkedLen_who('86', '8.6')
		else
			CarAction.uncheckedLen_who('86', '8.6');

	len96: (e)->
		if e.target.checked
			CarAction.checkedLen_who('96', '9.6')
		else
			CarAction.uncheckedLen_who('96', '9.6');

	len13: (e)->
		if e.target.checked
			CarAction.checkedLen_who('13', '13')
		else
			CarAction.uncheckedLen_who('13', '13');

	len15: (e)->
		if e.target.checked
			CarAction.checkedLen_who('15', '15')
		else
			CarAction.uncheckedLen_who('15', '15');


	# 可在重货--全部
	hea_all: (e)->
		if e.target.checked
			CarAction.checkedHeaAll()
		else
			CarAction.unCheckedHeaAll()
		heaCheckedLinkAll.requestChange e.target.value

	hea2: (e)->
		if e.target.checked
			CarAction.checkedHea_who('2','2')
		else
			CarAction.hahaha('2', '2')

	hea3: (e)->
		if e.target.checked
			CarAction.checkedHea_who('3', '3')
		else
			CarAction.hahaha('3', '3')

	hea4: (e)->
		if e.target.checked
			CarAction.checkedHea_who('4', '4')
		else
			CarAction.hahaha('4', '4');

	hea5: (e)->
		if e.target.checked
			CarAction.checkedHea_who('5', '5')
		else
			CarAction.hahaha('5', '5');

	hea6: (e)->
		if e.target.checked
			CarAction.checkedHea_who('6', '6')
		else
			CarAction.hahaha('6', '6');

	hea8: (e)->
		if e.target.checked
			CarAction.checkedHea_who('8', '8')
		else
			CarAction.hahaha('8', '8');

	hea10: (e)->
		if e.target.checked
			CarAction.checkedHea_who('10', '10')
		else
			CarAction.hahaha('10', '10');

	hea12: (e)->
		if e.target.checked
			CarAction.checkedHea_who('12', '12')
		else
			CarAction.hahaha('12', '12');

	hea15: (e)->
		if e.target.checked
			CarAction.checkedHea_who('15', '15')
		else
			CarAction.hahaha('15', '15');

	hea18: (e)->
		if e.target.checked
			CarAction.checkedHea_who('18', '18')
		else
			CarAction.hahaha('18', '18');

	hea20: (e)->
		if e.target.checked
			CarAction.checkedHea_who('20', '20')
		else
			CarAction.hahaha('20', '20');

	hea25: (e)->
		if e.target.checked
			CarAction.checkedHea_who('25', '25')
		else
			CarAction.hahaha('25', '25');

	hea28: (e)->
		if e.target.checked
			CarAction.checkedHea_who('28', '28')
		else
			CarAction.hahaha('28', '28');

	hea30: (e)->
		if e.target.checked
			CarAction.checkedHea_who('30', '30')
		else
			CarAction.hahaha('30', '30');

	hea40: (e)->
		if e.target.checked
			CarAction.checkedHea_who('40', '40')
		else
			CarAction.hahaha('40', '40');

	needInvoice: (e)->
		if e.target.checked
			@setState {
				isinvoice: '1'
			}
			CarAction.updateInvState('1')
	unNeedInvoice: (e)->
		if e.target.checked
			@setState {
				isinvoice: '2'
			}
			CarAction.updateInvState('2')

	cinvAll: (e)->
		if e.target.checked
			CarAction.invStChecked 3
		else
			CarAction.invStNotChecked 3

	cinvNeed: (e)->
		if e.target.checked
			CarAction.invStChecked 1
		else
			CarAction.invStNotChecked 1

	cinvNot: (e)->
		if e.target.checked
			CarAction.invStChecked 2
		else
			CarAction.invStNotChecked 2

	componentDidMount: ->
		CarStore.addChangeListener @_onChange

	componentWillUnmount: ->
		CarStore.removeChangeListener @_onChange

	_onChange: (params)->
		if params[0] is 'checked_len_all'
			@setState {
				lenCheckAll: true
				lenCheck38: true
				lenCheck42: true
				lenCheck48: true
				lenCheck58: true
				lenCheck62: true
				lenCheck68: true
				lenCheck74: true
				lenCheck78: true
				lenCheck86: true
				lenCheck96: true
				lenCheck13: true
				lenCheck15: true
			}
		else if params[0] is 'unchecked_len_all'
			@setState {
				lenCheckAll: false
				lenCheck38: false
				lenCheck42: false
				lenCheck48: false
				lenCheck58: false
				lenCheck62: false
				lenCheck68: false
				lenCheck74: false
				lenCheck78: false
				lenCheck86: false
				lenCheck96: false
				lenCheck13: false
				lenCheck15: false
			}
		else if params[0] is 'lencheck'
			temp = params[1]
			if temp is 'lenCheck38'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck38: true
					}
				else 
					@setState {
						lenCheck38: true
					}
			else if temp is 'lenCheck42'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck42: true
					}
				else 
					@setState {
						lenCheck42: true
					}
			else if temp is 'lenCheck48'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck48: true
					}
				else 
					@setState {
						lenCheck48: true
					}
			else if temp is 'lenCheck58'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck58: true
					}
				else 
					@setState {
						lenCheck58: true
					}
			else if temp is 'lenCheck62'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck62: true
					}
				else 
					@setState {
						lenCheck62: true
					}
			else if temp is 'lenCheck62'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck62: true
					}
				else 
					@setState {
						lenCheck62: true
					}
			else if temp is 'lenCheck68'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck68: true
					}
				else 
					@setState {
						lenCheck68: true
					}
			else if temp is 'lenCheck74'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck74: true
					}
				else 
					@setState {
						lenCheck74: true
					}
			else if temp is 'lenCheck78'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck78: true
					}
				else 
					@setState {
						lenCheck78: true
					}
			else if temp is 'lenCheck86'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck86: true
					}
				else 
					@setState {
						lenCheck86: true
					}
			else if temp is 'lenCheck96'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck96: true
					}
				else 
					@setState {
						lenCheck96: true
					}
			else if temp is 'lenCheck13'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck13: true
					}
				else 
					@setState {
						lenCheck13: true
					}
			else if temp is 'lenCheck15'
				if params[2] is 12
					@setState {
						lenCheckAll: true
						lenCheck15: true
					}
				else 
					@setState {
						lenCheck15: true
					}
		else if params[0] is 'unlencheck'
			temp = params[1]
			if temp is 'lenCheck38'
				@setState {
					lenCheckAll: false
					lenCheck38: false
				}
			else if temp is 'lenCheck42'
				@setState {
					lenCheckAll: false
					lenCheck42: false
				}
			else if temp is 'lenCheck48'
				@setState {
					lenCheckAll: false
					lenCheck48: false
				}
			else if temp is 'lenCheck58'
				@setState {
					lenCheckAll: false
					lenCheck58: false
				}
			else if temp is 'lenCheck62'
				@setState {
					lenCheckAll: false
					lenCheck62: false
				}
			else if temp is 'lenCheck62'
				@setState {
					lenCheckAll: false
					lenCheck62: false
				}
			else if temp is 'lenCheck68'
				@setState {
					lenCheckAll: false
					lenCheck68: false
				}
			else if temp is 'lenCheck74'
				@setState {
					lenCheckAll: false
					lenCheck74: false
				}
			else if temp is 'lenCheck78'
				@setState {
					lenCheckAll: false
					lenCheck78: false
				}
			else if temp is 'lenCheck86'
				@setState {
					lenCheckAll: false
					lenCheck86: false
				}
			else if temp is 'lenCheck96'
				@setState {
					lenCheckAll: false
					lenCheck96: false
				}
			else if temp is 'lenCheck13'
				@setState {
					lenCheckAll: false
					lenCheck13: false
				}
			else if temp is 'lenCheck15'
				@setState {
					lenCheckAll: false
					lenCheck15: false
				}
		else if params[0] is 'close_car_len'
			@setState {
				isShowLen: 1
			}
		else if params[0] is 'checked_hea_all'
			@setState {
				heaCheckAll: true
				heaCheck2: true
				heaCheck3: true
				heaCheck4: true
				heaCheck5: true
				heaCheck6: true
				heaCheck8: true
				heaCheck10: true
				heaCheck12: true
				heaCheck15: true
				heaCheck18: true
				heaCheck20: true
				heaCheck25: true
				heaCheck28: true
				heaCheck30: true
				heaCheck40: true
			}
		else if params[0] is 'unchecked_hea_all'
			@setState {
				heaCheckAll: false
				heaCheck2: false
				heaCheck3: false
				heaCheck4: false
				heaCheck5: false
				heaCheck6: false
				heaCheck8: false
				heaCheck10: false
				heaCheck12: false
				heaCheck15: false
				heaCheck18: false
				heaCheck20: false
				heaCheck25: false
				heaCheck28: false
				heaCheck30: false
				heaCheck40: false
			}
		else if params[0] is 'heacheck'
			temp = params[1]
			if temp is 'heaCheck2'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck2: true
					}
				else
					@setState {
						heaCheck2: true
					}
			else if temp is 'heaCheck3'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck3: true
					}
				else
					@setState {
						heaCheck3: true
					}
			else if temp is 'heaCheck4'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck4: true
					}
				else
					@setState {
						heaCheck4: true
					}
			else if temp is 'heaCheck5'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck5: true
					}
				else
					@setState {
						heaCheck5: true
					}
			else if temp is 'heaCheck6'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck6: true
					}
				else
					@setState {
						heaCheck6: true
					}
			else if temp is 'heaCheck8'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck8: true
					}
				else
					@setState {
						heaCheck8: true
					}
			else if temp is 'heaCheck10'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck10: true
					}
				else
					@setState {
						heaCheck10: true
					}
			else if temp is 'heaCheck12'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck12: true
					}
				else
					@setState {
						heaCheck12: true
					}
			else if temp is 'heaCheck15'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck15: true
					}
				else
					@setState {
						heaCheck15: true
					}
			else if temp is 'heaCheck18'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck18: true
					}
				else
					@setState {
						heaCheck18: true
					}
			else if temp is 'heaCheck20'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck20: true
					}
				else
					@setState {
						heaCheck20: true
					}
			else if temp is 'heaCheck25'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck25: true
					}
				else
					@setState {
						heaCheck25: true
					}
			else if temp is 'heaCheck28'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck28: true
					}
				else
					@setState {
						heaCheck28: true
					}
			else if temp is 'heaCheck30'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck30: true
					}
				else
					@setState {
						heaCheck30: true
					}
			else if temp is 'heaCheck40'
				if params[2] is 15
					@setState {
						heaCheckAll: true
						heaCheck40: true
					}
				else
					@setState {
						heaCheck40: true
					}
		else if params[0] is 'unheacheck'
			temp = params[1]
			if temp is 'heaCheck2'
				@setState {
					heaCheckAll: false
					heaCheck2: false
				}
			else if temp is 'heaCheck3'
				@setState {
					heaCheckAll: false
					heaCheck3: false
				}
			else if temp is 'heaCheck4'
				@setState {
					heaCheckAll: false
					heaCheck4: false
				}
			else if temp is 'heaCheck5'
				@setState {
					heaCheckAll: false
					heaCheck5: false
				}
			else if temp is 'heaCheck6'
				@setState {
					heaCheckAll: false
					heaCheck6: false
				}
			else if temp is 'heaCheck8'
				@setState {
					heaCheckAll: false
					heaCheck8: false
				}
			else if temp is 'heaCheck10'
				@setState {
					heaCheckAll: false
					heaCheck10: false
				}
			else if temp is 'heaCheck12'
				@setState {
					heaCheckAll: false
					heaCheck12: false
				}
			else if temp is 'heaCheck15'
				@setState {
					heaCheckAll: false
					heaCheck15: false
				}
			else if temp is 'heaCheck18'
				@setState {
					heaCheckAll: false
					heaCheck18: false
				}
			else if temp is 'heaCheck20'
				@setState {
					heaCheckAll: false
					heaCheck20: false
				}
			else if temp is 'heaCheck25'
				@setState {
					heaCheckAll: false
					heaCheck25: false
				}
			else if temp is 'heaCheck28'
				@setState {
					heaCheckAll: false
					heaCheck28: false
				}
			else if temp is 'heaCheck30'
				@setState {
					heaCheckAll: false
					heaCheck30: false
				}
			else if temp is 'heaCheck40'
				@setState {
					heaCheckAll: false
					heaCheck40: false
				}
		else if params[0] is 'close_car_hea'
			@setState {
				isShowHea: 1
			}
		else if params[0] is 'close_car_inv'
			@setState {
				isInvoince: 1
			}
		else if params[0] is 'one_need'
			@setState {
				invoinceNeed: true
				invoinceNotNeed: false
			}
		else if params[0] is 'one_not_need'
			@setState {
				invoinceNeed: false
				invoinceNotNeed: true
			}
		else if params[0] is 'inv_need'
			length = params[1]
			istrue = false
			if parseInt(length) is 2
				istrue = true
			else
				istrue = false
			@setState {
				invAll: istrue
				invNeed: true
			}
		else if params[0] is 'inv_not_need'
			length = params[1]
			istrue = false
			if parseInt(length) is 2
				istrue = true
			else
				istrue = false
			@setState {
				invAll: istrue
				invNot: true
			}
		else if params[0] is 'inv_need_all'
			length = params[1]
			@setState {
				invNot: true
				invNeed: true
				invAll: true	
			}
		else if params[0] is 'inv2_need'
			length = params[1]
			istrue = false
			if parseInt(length) is 2
				istrue = true
			else
				istrue = false
			@setState {
				invAll: istrue
				invNeed: false
			}
		else if params[0] is 'inv2_not_need'
			length = params[1]
			istrue = false
			if parseInt(length) is 2
				istrue = true
			else
				istrue = false
			@setState {
				invAll: istrue
				invNot: false
			}
		else if params[0] is 'inv2_need_all'
			length = params[1]
			@setState {
				invNot: false
				invNeed: false
				invAll: false	
			}

	# 车辆长度确定
	carLenSub: ->
		CarAction.info([''])
		CarAction.closeCarLen()

	carHeaSub: ->
		CarAction.info([''])
		CarAction.closeCarHea()

	carInvoince: ->
		CarAction.info([@state.isinvoice])
		CarAction.closeCarInvoince()

	render: ->
		# 车辆长度
		checkedLinkAll = this.linkState 'lenCheckAll'
		checkedLink38 = this.linkState 'lenCheck38'
		checkedLink42 = this.linkState 'lenCheck42'
		checkedLink48 = this.linkState 'lenCheck48'
		checkedLink58 = this.linkState 'lenCheck58'
		checkedLink62 = this.linkState 'lenCheck62'
		checkedLink68 = this.linkState 'lenCheck68'
		checkedLink74 = this.linkState 'lenCheck74'
		checkedLink78 = this.linkState 'lenCheck78'
		checkedLink86 = this.linkState 'lenCheck86'
		checkedLink96 = this.linkState 'lenCheck96'
		checkedLink13 = this.linkState 'lenCheck13'
		checkedLink15 = this.linkState 'lenCheck15'

		# 可在重货
		heaCheckedLinkAll = this.linkState 'heaCheckAll'
		heaCheckedLink2 = this.linkState 'heaCheck2'
		heaCheckedLink3 = this.linkState 'heaCheck3'
		heaCheckedLink4 = this.linkState 'heaCheck4'
		heaCheckedLink5 = this.linkState 'heaCheck5'
		heaCheckedLink6 = this.linkState 'heaCheck6'
		heaCheckedLink8 = this.linkState 'heaCheck8'
		heaCheckedLink10 = this.linkState 'heaCheck10'
		heaCheckedLink12 = this.linkState 'heaCheck12'
		heaCheckedLink15 = this.linkState 'heaCheck15'
		heaCheckedLink18 = this.linkState 'heaCheck18'
		heaCheckedLink20 = this.linkState 'heaCheck20'
		heaCheckedLink25 = this.linkState 'heaCheck25'
		heaCheckedLink28 = this.linkState 'heaCheck28'
		heaCheckedLink30 = this.linkState 'heaCheck30'
		heaCheckedLink40 = this.linkState 'heaCheck40'

		# 是否需要发票
		needInvoinceLink = this.linkState 'invoinceNeed'
		notNeedInvoinceLink = this.linkState 'invoinceNotNeed'

		invAll = this.linkState 'invAll'
		invNeed = this.linkState 'invNeed'
		invNot = this.linkState 'invNot'

		<div className="m-nav03">
			<ul>
				<li>
					<div onClick={ this._showLen } className={ if @state.isShowLen is 1 then "g-div01 ll-font u-arrow-right" else "g-div01 ll-font u-arrow-right g-div01-act"} dangerouslySetInnerHTML={{__html:'车辆长度<span>全部</span>'}}>
					</div> 
					<div id="menu" className="g-div02" style={{ display: if @state.isShowLen is 1 then 'none' else 'block' }}>
						<div className="g-div02-item">
							<label className="u-label"><input checked={checkedLinkAll.value} onChange={@len_all} className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'全部'}} /></label><label className="u-label"><input checked={checkedLink38.value} onChange=@len38 className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'3.8米'}} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'4.2米'}} checked={checkedLink42.value} onChange=@len42 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'4.8米'}} checked={checkedLink48.value} onChange=@len48 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'5.8米'}} checked={checkedLink58.value} onChange=@len58 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'6.2米'}} checked={checkedLink62.value} onChange=@len62 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'6.8米'}} checked={checkedLink68.value} onChange=@len68 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'7.4米'}} checked={checkedLink74.value} onChange=@len74 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'7.8米'}} checked={checkedLink78.value} onChange=@len78 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'8.6米'}} checked={checkedLink86.value} onChange=@len86 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'9.6米'}} checked={checkedLink96.value} onChange=@len96 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'13~15'}} checked={checkedLink13.value} onChange=@len13 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'15~米'}} checked={checkedLink15.value} onChange=@len15 /></label>
						</div>
						<div className="g-div02-btn" style={{display: 'none'}}>
							<a href="###" onClick={@carLenSub} className="u-btn u-btn-small">确定</a>
						</div>
					</div>
				</li>
				<li>
					<div  onClick={ this._showHea } className={ if @state.isShowHea is 1 then "g-div01 ll-font u-arrow-right" else "g-div01 ll-font u-arrow-right g-div01-act"}  dangerouslySetInnerHTML={{__html:'可载重货<span>全部</span>'}}>
					</div>
					<div id="menu" className="g-div02" style={{ display: if @state.isShowHea is 1 then 'none' else 'block' }}>
						<div className="g-div02-item">
							<label className="u-label"><input checked={heaCheckedLinkAll.value} onChange={@hea_all} className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'全部'}} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'2吨'}} checked={heaCheckedLink2.value} onChange=@hea2 /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'3吨'}} checked={heaCheckedLink3.value} onChange={@hea3} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'4吨'}} checked={heaCheckedLink4.value} onChange={@hea4}/></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'5吨'}} checked={heaCheckedLink5.value} onChange={@hea5} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'6吨'}} checked={heaCheckedLink6.value} onChange={@hea6} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'8吨'}} checked={heaCheckedLink8.value} onChange={@hea8} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'10吨'}} checked={heaCheckedLink10.value} onChange={@hea10} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'12吨'}} checked={heaCheckedLink12.value} onChange={@hea12} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'15吨'}} checked={heaCheckedLink15.value} onChange={@hea15} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'18吨'}} checked={heaCheckedLink18.value} onChange={@hea18} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'20吨'}} checked={heaCheckedLink20.value} onChange={@hea20} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'25吨'}} checked={heaCheckedLink25.value} onChange={@hea25} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'28吨'}} checked={heaCheckedLink28.value} onChange={@hea28} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'30吨'}} checked={heaCheckedLink30.value} onChange={@hea30} /></label><label className="u-label"><input className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'30~40'}} checked={heaCheckedLink40.value} onChange={@hea40} /></label>
						</div>
						<div className="g-div02-btn" style={{display: 'none'}}>
							<a href="###" onClick={@carHeaSub} className="u-btn u-btn-small">确定</a>
						</div>
					</div>
				</li>
				<li>
					<div onClick={ this._showInvoince } className={ if @state.isInvoince is 1 then "g-div01 ll-font u-arrow-right" else "g-div01 ll-font u-arrow-right g-div01-act"} dangerouslySetInnerHTML={{__html:'提供发票<span>全部</span>'}}>		
					</div>
					<div id="menu" className="g-div02" style={{ display: if @state.isInvoince is 1 then 'none' else 'block' }}>
						<div className="g-div02-item">
							<label className="u-label"><input checked={invAll.value} onChange={@cinvAll} className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'全部'}} /></label><label className="u-label"><input onChange={@cinvNeed} checked={invNeed.value} className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'是'}} /></label><label onChange={@cinvNot} className="u-label"><input checked={invNot.value} className="ll-font" type="checkbox" dangerouslySetInnerHTML={{__html:'否'}} onChange=@unNeedInvoice /></label>
						</div>
						<div className="g-div02-btn" style={{display: 'none'}}>
							<a href="###" onClick={@carInvoince} className="u-btn u-btn-small">确定</a>
						</div>
					</div>
				</li>
			</ul>
		</div>
}

module.exports = ScreenMenu
