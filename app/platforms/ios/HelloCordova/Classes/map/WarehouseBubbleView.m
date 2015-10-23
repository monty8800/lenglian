//
//  WarehouseBubbleView.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "WarehouseBubbleView.h"
#import "Global.h"
#import "SelectWarehouseWidget.h"

@implementation WarehouseBubbleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)createUI {
    [super createUI];
    _infoView = [[InfoView alloc] initWithFrame:CGRectMake(10, 15, self.bounds.size.width - 20, 4*22)];
    [self addSubview:_infoView];
    [_btn setTitle:@"选择仓库" forState:UIControlStateNormal];
}

-(void)setData:(NSDictionary *)data {
    [super setData:data];
    NSString *addr = [NSString stringWithFormat:@"仓库地址： %@%@%@", [data objectForKey:@"provinceName"], [data objectForKey:@"cityName"], [data objectForKey:@"areaName"]];
    
    NSAttributedString *addrStr = [[NSAttributedString alloc] initWithString:addr attributes:@{NSForegroundColorAttributeName: [UIColor WY_ColorWithHex:0xff8e24]}];
    
    _infoView.dataList = @[
                           addrStr,
                           [NSString stringWithFormat:@"仓库类型： %@", [data objectForKey:@"wareHouseType"]],
                           [NSString stringWithFormat:@"库温类型： %@", [data objectForKey:@"cuvinExtensive"]],
                           [NSString stringWithFormat:@"仓库价格： %@", [data objectForKey:@"price"]]
                           ];
}

-(void)clickBtn {
    if ([self.data objectForKey:@"id"] == nil) {
        [[Global sharedInstance] showErr:@"错误的仓库数据！"];
        return;
    }
    NSDictionary *user = [Global getUser];
    BOOL goodsAuth = [[user objectForKey:@"goodsStatus"] integerValue] == 1;
    if (!goodsAuth) {
        [[Global sharedInstance] showErr:@"尚未进行货主认证，请认证之后再进行操作"];
        return;
    }
    [SelectWarehouseWidget show: (id<SelectWarehouseDelegate>)([Global sharedInstance].mapVC) warehouseId: [self.data objectForKey:@"id"]];
}

@end
