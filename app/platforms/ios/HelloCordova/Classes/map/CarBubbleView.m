//
//  CarBubbleView.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "CarBubbleView.h"
#import "SelectCarWidget.h"
#import "Global.h"


@implementation CarBubbleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)createUI {
    [super createUI];
    
    _fromToView = [[FromToView alloc] initWithFrame:CGRectMake(10, 15, self.bounds.size.width - 20, 55)];
    [self addSubview:_fromToView];
    
    _infoView = [[InfoView alloc] initWithFrame:CGRectMake(10, _fromToView.frame.origin.y + _fromToView.frame.size.height + 10, self.bounds.size.width-20, 30)];
    _infoView.tabView.scrollEnabled = NO;
    [self addSubview:_infoView];
    
    [_btn setTitle:@"选择司机" forState:UIControlStateNormal];
}

-(void)setData:(NSDictionary *)data {
    [super setData:data];
    
    NSString *fromProvince = [data objectForKey:@"fromProvinceName"];
    NSString *fromCity = [data objectForKey:@"fromCityName"];
    NSString *fromArea = [data objectForKey:@"fromAreaName"];
    NSString *toProvince = [data objectForKey:@"toProvinceName"];
    NSString *toCity = [data objectForKey:@"toCityName"];
    NSString *toArea = [data objectForKey:@"toAreaName"];
    
    _fromToView.addressList = @[
                                @{@"type": @(TO),
                                  @"text": [NSString stringWithFormat:@"%@%@%@", toProvince, toCity, toArea]
                                  },
                                @{@"type": @(FROM),
                                  @"text": [NSString stringWithFormat:@"%@%@%@", fromProvince, fromCity, fromArea]
                                  },
                                
                                ];
    NSString *carType = @"";
    switch ([[data objectForKey:@"carType"] integerValue]) {
        case 1:
            carType = @"普通卡车";
            break;
            
        case 2:
            carType = @"冷藏车";
            break;
            
        case 3:
            carType = @"平板";
            break;
            
        case 4:
            carType = @"箱式";
            break;
            
        case 5:
            carType = @"集装箱";
            break;
            
        case 6:
            carType = @"高栏";
            break;
            
        default:
            carType = @"未知类型";
            break;
    }
    NSString *carLength = @"";
    switch ([[data objectForKey:@"vehicle"] integerValue]) {
        case 1:
            carLength = @"3.8米";
            break;
        case 2:
            carLength = @"4.2米";
            break;
        case 3:
            carLength = @"4.8米";
            break;
        case 4:
            carLength = @"5.8米";
            break;
        case 5:
            carLength = @"6.2米";
            break;
        case 6:
            carLength = @"6.8米";
            break;
        case 7:
            carLength = @"7.4米";
            break;
        case 8:
            carLength = @"7.8米";
            break;
        case 9:
            carLength = @"8.6米";
            break;
        case 10:
            carLength = @"9.6米";
            break;
        case 11:
            
            carLength = @"13~15米";
            break;
        case 12:
            carLength = @"15米以上";
            break;
        default:
            carLength = @"";
            break;
    }
    _infoView.dataList = @[[NSString stringWithFormat:@"车辆描述: %@ %@", carLength, carType]];
}

-(void)clickBtn {
    if ([self.data objectForKey:@"id"] == nil) {
        [[Global sharedInstance] showErr:@"错误的车辆数据！"];
        return;
    }
    
    [self checkAuth:GoodsAuth cb:^{
        [SelectCarWidget show:(id<SelectCarDelegate>)([Global sharedInstance].mapVC) carId:[self.data objectForKey:@"id"]];
    }];
    
}

@end
