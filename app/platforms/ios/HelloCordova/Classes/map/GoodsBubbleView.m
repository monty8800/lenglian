//
//  GoodsBubbleView.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "GoodsBubbleView.h"
#import "Global.h"
#import "SelectGoodsWidget.h"
#import "UIImageView+XE.h"
#import "NearByViewController.h"

@implementation GoodsBubbleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) createUI {
    [super createUI];
    _avatar = [[UIImageView alloc] initWithFrame:CGRectMake(10, 2, 32, 32)];
    [_avatar WY_MakeCorn:16];
    [self addSubview:_avatar];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 17, 167, 18)];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor WY_ColorWithHex:0x333333];
    [self addSubview:_nameLabel];
    
    _fromToView = [[FromToView alloc] initWithFrame:CGRectMake(10, 45, self.bounds.size.width-20, 74)];
    _fromToView.tabView.contentInset = UIEdgeInsetsMake(10, 0, 10, 0);
    [_fromToView WY_MakeBorder:Top|Bottom borderColor:[UIColor WY_ColorWithHex:0xececec] lineWidth:0.5];
    [self addSubview:_fromToView];
    
    _infoView = [[InfoView alloc] initWithFrame:CGRectMake(10, 130, self.bounds.size.width-20, 64)];
    [self addSubview:_infoView];
}

-(void)setData:(NSDictionary *)data {
//TODO: 更新界面
    [super setData:data];
    
    [_avatar XE_setImage:[data objectForKey:@"userImgUrl"] size:s130x130 type:Avatar];
    
    _nameLabel.text = [data objectForKey:@"userName"];
    _fromToView.addressList = @[
                                @{
                                    @"type": @(TO),
                                    @"text": [NSString stringWithFormat:@"%@%@%@",[data objectForKey:@"toProvinceName"], [data objectForKey:@"toCityName"], [data objectForKey:@"toAreaName"]]
                                    },
                                @{
                                    @"type": @(FROM),
                                    @"text": [NSString stringWithFormat:@"%@%@%@", [data objectForKey:@"fromProvinceName"], [data objectForKey:@"fromCityName"], [data objectForKey:@"fromAreaName"]]
                                    }
                                ];
    
    NSMutableAttributedString *price = [[NSMutableAttributedString alloc] initWithString:@"价格类型： "];
    if ([[data objectForKey:@"priceType"] integerValue] == 1) {
        [price appendAttributedString:[[NSAttributedString alloc] initWithString: @"一口价"]];
        NSString *priceStr = [NSString stringWithFormat:@"%@元", [data objectForKey:@"price"]];
        [price appendAttributedString:[[NSAttributedString alloc] initWithString:priceStr  attributes: @{NSForegroundColorAttributeName: [UIColor WY_ColorWithHex:0xfe8500]}]];
        
        [_btn setTitle:@"抢单" forState:UIControlStateNormal];
    }
    else
    {
        [price appendAttributedString:[[NSAttributedString alloc] initWithString: @"竞价"]];
        [_btn setTitle:@"竞价" forState:UIControlStateNormal];
    }
    
    NSMutableString *desc = [[NSMutableString alloc] initWithString:@"货物描述： "];
//    if (![[data objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
//        [desc appendString:[data objectForKey:@"name"]];
//    }
    
    [desc appendFormat:@"%@", [Global goodsType:[[data objectForKey:@"goodsType"] integerValue]]];
    [desc appendFormat:@" %@吨", [data objectForKey:@"weight"]];
    
    NSDate *minTime = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"installStime"] doubleValue] / 1000 ];
    NSDate *maxTime = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"installEtime"] doubleValue] / 1000 ];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSString *installStr = [NSString stringWithFormat:@"装货时间： %@ 到 %@", [formatter stringFromDate:minTime], [formatter stringFromDate:maxTime]];
    
    _infoView.dataList = @[price, desc, installStr];
}

-(void)clickBtn {
    if ([self.data objectForKey:@"id"] == nil) {
        [[Global sharedInstance] showErr:@"错误的货物数据！"];
        return;
    }
    
    NSDictionary *user = [Global getUser];
    BOOL carAuth = [[user objectForKey:@"carStatus"] integerValue] == 1;
    BOOL warehouseAuth = [[user objectForKey:@"warehouseStatus"] integerValue] == 1;
    BOOL bid = [[self.data objectForKey:@"priceType"] integerValue] == 2;
    if (carAuth) {
        ((NearByViewController *)[Global sharedInstance].mapVC).bid = bid;
        [SelectGoodsWidget show:(id<SelectGoodsDelegate>)([Global sharedInstance].mapVC) goods:[self.data objectForKey:@"id"] type:Cars];
    }
    else if (warehouseAuth)
    {
        if (!bid) {
            ((NearByViewController *)[Global sharedInstance].mapVC).bid = bid;
            [SelectGoodsWidget show:(id<SelectGoodsDelegate>)([Global sharedInstance].mapVC) goods:[self.data objectForKey:@"id"] type:Warehouses];
        }
        else
        {
            [[Global sharedInstance] showErr:@"仓库无法参与竞价"];
        }
    }
    else
    {
        [[Global sharedInstance] showErr:@"尚未进行车主或仓库主认证，请认证之后再进行操作"];
        return;
    }
    
    
    
}

@end
