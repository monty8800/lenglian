UserStore = require 'stores/user/user'
Plugin = require 'util/plugin'

needLogin = (cb)->
	console.log UserStore.getUser()
	if not UserStore.getUser()?.id
		console.log 'need login!'
		Plugin.nav.push ['login']
	else
		console.log 'user id', UserStore.getUser()?.id
		cb()

needAuth = (type, cb)->
	user = UserStore.getUser()
	switch type
		when 'car'
			if user.carStatus is 0
				Plugin.alert '尚未通过车主认证，是否去认证？', '提示', (index)->
					if index is 1
						switch user.certification
							when 0 then Plugin.nav.push ['auth']
							when 1 then Plugin.nav.push ['personalCarAuth']
							when 2 then Plugin.nav.push ['companyCarAuth']
				, ['去认证', '取消']
			else if user.carStatus is 2
				Plugin.toast.err '车主还在认证中'
			else
				cb()
		when 'goods'
			if user.goodsStatus is 0
				Plugin.alert '尚未通过货主认证，是否去认证？', '提示', (index)->
					if index is 1
						switch user.certification
							when 0 then Plugin.nav.push ['auth']
							when 1 then Plugin.nav.push ['personalGoodsAuth']
							when 2 then Plugin.nav.push ['companyGoodsAuth']
				, ['去认证', '取消']
			else if user.goodsStatus is 2
				Plugin.toast.err '货主还在认证中'
			else
				cb()
		when 'warehouse'
			if user.warehouseStatus is 0
				Plugin.alert '尚未通过仓库主认证，是否去认证？', '提示', (index)->
					if index is 1
						switch user.certification
							when 0 then Plugin.nav.push ['auth']
							when 1 then Plugin.nav.push ['personalWarehouseAuth']
							when 2 then Plugin.nav.push ['companyWarehouseAuth']
				, ['去认证', '取消']
			else if user.warehouseStatus is 2
				Plugin.toast.err '仓库主还在认证中'
			else
				cb()
		when 'any'
			Plugin.alert (if cb then cb else '尚未通过任何角色认证，是否去认证？'), '提示', (index)->
				if index is 1
					Plugin.nav.push ['auth']
			, ['去认证', '取消']
			


module.exports = {
	needLogin: needLogin
	needAuth: needAuth
}

