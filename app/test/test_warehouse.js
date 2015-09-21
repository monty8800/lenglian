(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('库相关', function() {
    it('查询我的仓库', function(done) {
      var params;
      params = {
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        status: '1',
        pageNow: 1,
        pageSize: 10
      };
      return request.post(config.api.GET_WAREHOUSE, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    it('删除我的仓库', function(done) {
      var params;
      params = {
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        warehouseId: '1221223456789'
      };
      return request.post(config.api.DELETE_WAREHOUSE, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    it('修改我的仓库', function(done) {
      var params;
      params = {
        userId: '3456789',
        warehouseId: '4567890',
        remark: "刁兄的仓库。。。",
        phone: "1381231231232",
        contacts: "刁兄"
      };
      return request.post(config.api.UPDATE_WAREHOUSE, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    it('我的仓库详情', function(done) {
      var params;
      params = {
        userId: '7714d0d83c7f47f4bcfac62b9a1bf101',
        warehouseId: '9bea9e8f561d4922bc5709cc267ee0eb'
      };
      return request.post(config.api.WAREHOUSE_DETAIL, params, function(result) {
        should.exists(result);
        return done();
      });
    });
    return it('增加仓库', function(done) {
      var params;
      params = {
        area: "1",
        city: "1",
        contacts: "张三",
        isinvoice: "1",
        latitude: "111",
        longitude: "112",
        name: "qw",
        phone: "15535355533",
        province: "1",
        remark: "备注",
        street: "北京市",
        userId: "7714d0d83c7f47f4bcfac62b9a1bf101",
        file: '',
        warehouseProperty: [
          {
            type: "1",
            attribute: "1",
            value: "",
            typeName: "仓库类型",
            attributeName: "驶入式"
          }, {
            type: "2",
            attribute: "1",
            value: "",
            typeName: "仓库增值服务",
            attributeName: "城配"
          }, {
            type: "2",
            attribute: "2",
            value: "",
            typeName: "仓库增值服务",
            attributeName: "仓配"
          }, {
            type: "3",
            attribute: "1",
            value: "1000",
            typeName: "仓库面积",
            attributeName: "常温"
          }, {
            type: "3",
            attribute: "3",
            value: "2000",
            typeName: "仓库面积",
            attributeName: "冷冻"
          }, {
            type: "4",
            attribute: "2",
            value: "",
            typeName: "价格",
            attributeName: "天/平"
          }
        ]
      };
      return request.post(config.api.WAREHOUSE_ADD, params, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
