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
    NSString *addr = [NSString stringWithFormat:@"仓库地址： %@%@%@", [data objectForKey:@"provinceName"], [data objectForKey:@"cityName"], [data objectForKey:@"areaName"]];
    
    NSAttributedString *addrStr = [[NSAttributedString alloc] initWithString:addr attributes:@{NSForegroundColorAttributeName: [UIColor WY_ColorWithHex:0xff8e24]}];
    
    _infoView.dataList = @[
                           addrStr,
                           [NSString stringWithFormat:@"仓库类型： %@", [data objectForKey:@"wareHouseType"]],
                           [NSString stringWithFormat:@"库温类型： %@", [data objectForKey:@"cuvinType"]],
                           [NSString stringWithFormat:@"仓库价格： %@", [data objectForKey:@"price"]]
                           ];
}

-(void)clickBtn {
    [SelectWarehouseWidget show];
}

@end
