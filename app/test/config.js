(function() {
  module.exports = {
    timeout: 15000,
    use_crypto: false,
    des_key: '12345678',
    paylod: {
      uuid: 'app_unit_test',
      client_type: '2',
      version: '1.0.0',
      data: {}
    },
    api: {
      server: 'http://192.168.26.177:7080/llmj-app/',
      LOGIN: '/loginCtl/userLogin.shtml',
      REGISTER: '/register/registerUser.shtml',
      SMS_CODE: '/register/sendMobileMsg.shtml',
      RESET_PWD: '/register/retrievePWD.shtml',
      CHANGE_PWD: '/loginCtl/changPwd.shtml',
      HAS_PAY_PWD: '/myWalletCtl/isPayPassword.shtml',
      PAY_PWD: '/myWalletCtl/payPassword.shtml',
      RESET_PAY_PWD: '/myWalletCtl/resetPayPassword.shtml',
      USER_CENTER: '/userInfo/userCenter.shtml',
      ADDR_LIST: '/userInfo/queryMjUserAddressList.shtml',
      QUERY_BANK_BY_CARD: '/mjUserBankCard/queryBankType.shtml',
      NEARBY_CAR: '/findNear/nearCar.shtml',
      SEARCH_CAR_DETAIL: '/searchCarCtl/searchCar.shtml',
      NEARBY_WAREHOUSE: '/findNear/nearWarehouse.shtml',
      SEARCH_WAREHOUSE_DETAIL: '/searchWarehouseCtl/searchWarehouse.shtml',
      NEARBY_GOODS: '/findNear/nearGoods.shtml',
      SEARCH_GOODS_DETAIL: '/carFindGoods/list.shtml',
      COMPANY_AUTH: '/enterprise/enterpriseAuthentication.shtml',
      GET_WAREHOUSE: '/mjWarehouseCtl/queryMjWarehouse.shtml',
      DELETE_WAREHOUSE: '/mjWarehouseCtl/deleteMjWarehouse.shtml',
      UPDATE_WAREHOUSE: '/mjWarehouseCtl/updateMjWarehouse.shtml',
      WAREHOUSE_DETAIL: '/mjWarehouseCtl/queryMjWarehouseLoad.shtml',
      WAREHOUSE_ADD: '/mjWarehouseCtl/addMjWarehouse.shtml',
      SEARCH_WAREHOUSE: '/searchWarehouseCtl/searchWarehouse.shtml',
      PERSONINFO_AUTH: '/mjPersonInfoAuthCtl/personInfoAuth.shtml',
      COMMENT_ADD: '/mjRate/addMjRate.shtml',
      GET_COMMENT: '/mjRate/queryMjRateList.shtml',
      DRIVER_FIND_GOODS: '/carFindGoods/list.shtml',
      GET_CARS_FOR_BIND_ORDER: '/carFindGoods/listCarResources.shtml',
      DRIVER_BIND_ORDER: '/carFindGoods/orderTrade.shtml',
      DRIVER_BID_FOR_GOODS: '/carFindGoods/orderBid.shtml',
      GET_ORDER_BID_LIST: '/carFindGoods/orderBidList.shtml',
      GOODS_BIND_WAREHOUSE_ORDER: '/mjOrderWarhouse/addGoodsFoundWarhouseOrder.shtml',
      WAREHOUSE_SEARCH_GOODS: '/warehouseSearchGoods/warehouseSearchGoodsList.shtml',
      GET_GOODS_LIST: '/mjGoodsResource/queryMjGoodsResourceList.shtml',
      GET_GOODS_DETAIL: '/mjGoodsResource/queryMjGoodsResource.shtml',
      GET_WALLET_IN_OUT: '/myWalletCtl/queryPayIncomeOrOut.shtml',
      ADD_BANK_CARD_COMMPANY: '/mjUserBankCard/addMjEnterPriseUserBankCard.shtml',
      ADD_BANK_CARD_PRIVET: '/mjUserBankCard/addMjUserBankCard.shtml',
      VERITY_PHONE_FOR_BANK: '/mjUserBankCard/validateMjUserBankCard.shtml',
      GET_BANK_CARD_INFO: '/mjUserBankCard/queryBankType.shtml',
      GET_BANK_LIST: '/mjUserBankCard/queryBankCardList.shtml',
      attention_list: '/userInfo/queryMjWishlstList.shtml',
      my_car_list: '/mjCarinfoCtl/queryMjCarinfo.shtml',
      add_car: '/mjCarinfoCtl/addMjCarinfo.shtml',
      car_detail: '/mjCarinfoCtl/queryMjCarinfoLoad.shtml',
      location_list: '/dictionaryCtl/provinceList.shtml',
      found_car: '/searchCarCtl/searchCar.shtml',
      add_attention: '/userInfo/addDeleteMjWishlst.shtml',
      cancel_attention: '/userInfo/addDeleteMjWishlst.shtml',
      add_address: '/userInfo/addMjUserAddress.shtml',
      del_address: '/userInfo/deleteMjUserAddress.shtml',
      modify_address: '/userInfo/updateMjUserAddress.shtml',
      message_list: '/mjMymessageCtl/queryMymessage.shtml',
      carowner_order_list: '/ownerOrderCtl/ownerOrderlst.shtml',
      carowner_order_detail: '/ownerOrderCtl/ownerOrderDetail.shtml',
      goods_order_list: '/orderGoods/list.shtml',
      goods_order_detail: '/orderGoods/detail.shtml',
      store_order_List: '/mjOrderWarhouse/queryWarhousefoundGoodsOrderList.shtml',
      store_order_detail: '/mjOrderWarhouse/queryWarhousefoundGoodsOrderInfo.shtml',
      release_car: '/mjCarinfoCtl/addCarResource.shtml'
    }
  };

}).call(this);
