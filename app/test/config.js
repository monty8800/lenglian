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
      USER_CENTER: '/userInfo/userCenter.shtml',
      ADDR_LIST: '/userInfo/queryMjUserAddressList.shtml',
      ware_house_detail: '/mjWarehouseCtl/queryMjWarehouseLoad.shtml',
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
      modify_address: '/userInfo/updateMjUserAddress.shtml'
    }
  };

}).call(this);
