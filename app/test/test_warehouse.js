(function() {
  var config, request, should;

  request = require('./common');

  should = require('should');

  config = require('./config');

  describe('库相关', function() {
    return it('增加仓库', function(done) {
      var file, params;
      params = {
        area: "东城区",
        city: "北京市",
        contacts: "张某三",
        isinvoice: "1",
        latitude: "111",
        longitude: "112",
        name: "起个名字费脑筋",
        phone: "18088889999",
        province: "北京市",
        remark: "我在代码里下毒,你造么?",
        street: "天安门脚下",
        userId: "5b3d93775a22449284aad35443c09fb6",
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
      file = [
        {
          filed: 'file',
          path: 'src/images/car-02.jpg',
          name: 'addWarehouse.jpg'
        }
      ];
      return request.postFile(config.api.WAREHOUSE_ADD, params, file, function(result) {
        should.exists(result);
        return done();
      });
    });
  });

}).call(this);
