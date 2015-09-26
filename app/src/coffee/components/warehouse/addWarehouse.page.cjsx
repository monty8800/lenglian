require 'components/common/common'
require 'user-center-style'

React = require 'react/addons'

WarehouseStore = require 'stores/warehouse/warehouseStore'
WarehouseAction = require 'actions/warehouse/warehouseAction'
PureRenderMixin = React.addons.PureRenderMixin
DB = require 'util/storage'

#新增仓库的 html 还没有