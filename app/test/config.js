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
      USER_CENTER: '/userInfo/userCenter.shtml',
      ware_house_detail: 'mjWarehouseCtl/queryMjWarehouseLoad.shtml'
    }
  };

}).call(this);
