//
//  SelectCarWidget.m
//  HelloCordova
//
//  Created by ywen on 15/10/3.
//
//

#import "SelectCarWidget.h"
#import "Global.h"
#import "SelectCarTableViewCell.h"
#import "Net.h"

@implementation SelectCarWidget

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void) createUI {
    self.backgroundColor = [UIColor WY_ColorWithHex:0x000000 alpha:0.3];
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(20, self.center.y - 110, SCREEN_WIDTH-40, 260) style:UITableViewStylePlain];
    _tabView.center = self.center;
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.backgroundColor = [UIColor whiteColor];
    [_tabView registerClass:[SelectCarTableViewCell class] forCellReuseIdentifier:@"select_car_cell"];
    [self addSubview:_tabView];
    
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-33, self.center.y-117, 20, 20)];
    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    [_closeBtn WY_SetBgColor:0x1987c6 title:@"X" titleColor:0xffffff corn:10 fontSize:15];
    _closeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
    [self addSubview:_closeBtn];
    
    //    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    //    [self addGestureRecognizer:tapGes];
}

-(void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    [_tabView reloadData];
}

+(void)show:(id<SelectCarDelegate>)delegate carId:(NSString *)carId
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    SelectCarWidget *widget = [[SelectCarWidget alloc] initWithFrame:window.bounds];
    widget.hidden = YES;
    [window addSubview:widget];
    widget.delegate = delegate;
    widget. carId= carId;
    [widget requestData];
}

-(void) requestData {
    NSDictionary *user = [Global getUser];
    NSString *userId = [user objectForKey:@"id"];
    if (userId != nil) {
        [Net post:MY_GOODS params:@{@"userId": userId, @"resourceStatus": @"1", @"priceType":@"1"} cb:^(NSDictionary *responseDic) {
            DDLogDebug(@"MY goods %@", responseDic);
            if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
                NSMutableArray *goodsList = [NSMutableArray new];
                for (NSDictionary *dic in [[responseDic objectForKey:@"data"] objectForKey:@"GoodsResource"]) {
                    
                    //MARK: 描述字段
                    NSString *priceType;
                    switch ([[dic objectForKey:@"priceType"] integerValue]) {
                        case 1:
                            priceType = @"一口价";
                            break;
                            
                        case 2:
                            priceType = @"竞价";
                            
                        default:
                            priceType = @"";
                            break;
                    }
                    
                    NSString *price = [dic objectForKey:@"price"];
                    
                    NSString *priceStr;
                    if ([price isKindOfClass:[NSNull class]]) {
                        priceStr = priceType;
                    }
                    else
                    {
                        priceStr = [NSString stringWithFormat:@"价格类型： %@ %@元", priceType, price];
                    }
                    
                    NSString *descStr;
                    
                    NSString *typeStr;
                    switch ([[dic objectForKey:@"goodsType"] integerValue]) {
                        case 1:
                            typeStr = @"常温";
                            break;
                            
                        case 2:
                            typeStr = @"冷藏";
                            break;
                            
                        case 3:
                            typeStr = @"冷冻";
                            break;
                            
                        case 4:
                            typeStr = @"急冻";
                            break;
                            
                        case 5:
                            typeStr = @"深冷";
                            break;
                            
                        default:
                            typeStr = @"其他";
                            break;
                    }
                    
                    
                    
                    NSString *name = [dic objectForKey:@"name"];
                    
                    NSString *weightStr;
                    
                    NSString *weight = [dic objectForKey:@"weight"];
                    
                    if (weight != nil && ![weight isKindOfClass:[NSNull class]] ) {
                        weightStr = [NSString stringWithFormat:@"%@吨", weight];
                    }
                    else
                    {
                        weightStr = [NSString stringWithFormat:@"%@方", [dic objectForKey:@"cube"]];
                    }
                    
                    if (![name isKindOfClass:[NSNull class]]) {
                        descStr = [NSString stringWithFormat:@"货物描述： %@ %@ %@", name, weightStr, typeStr];
                    }
                    else
                    {
                        descStr = [NSString stringWithFormat:@"货物描述： %@ %@", weightStr, typeStr];
                    }
                    
                    
                    
                    //MARK: 起始地
                    NSMutableArray *addressList = [NSMutableArray new];
                    
                    NSString *toStr = [NSString stringWithFormat:@"%@%@%@", [dic objectForKey:@"toProvinceName"], [dic objectForKey:@"toCityName"], [dic objectForKey:@"toAreaName"]];
                    [addressList addObject:@{@"type": @(TO), @"text": toStr}];
                    
                    
                    for (NSDictionary *route in [dic objectForKey:@"mjGoodsRoutes"]) {
                        NSString *passby = [NSString stringWithFormat:@"%@%@%@", [route objectForKey:@"provinceName"], [route objectForKey:@"cityName"], [route objectForKey:@"areaName"]];
                        [addressList addObject:@{@"type": @(PASSBY), @"text": passby}];
                    }
                    
                    NSString *fromStr = [NSString stringWithFormat:@"%@%@%@", [dic objectForKey:@"fromProvinceName"], [dic objectForKey:@"fromCityName"], [dic objectForKey:@"fromAreaName"]];
                    [addressList addObject:@{@"type": @(FROM), @"text": fromStr}];
                    
                    
                    
                    
                    [goodsList addObject:@{
                                           @"data": @{
                                                   @"id": [dic objectForKey:@"id"]
                                                   },
                                           @"infoList": @[priceStr, descStr],
                                           @"addressList": addressList
                                           }];
                    
                    
                }
                
                if (goodsList.count > 0) {
                    self.dataList = goodsList;
                    [self showAnim];
                }
                else
                {
                    [[Global sharedInstance] showErr:@"没有可用货源，请添加货源后重试"];
                    [self hide];
                }
                
                
                
            }
            else
            {
                [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
                [self hide];
            }
            
        } loading:NO];
    }

}

-(void) showAnim {
    self.hidden = NO;
    _closeBtn.alpha = 0;
    _tabView.frame = CGRectMake(self.center.x, self.center.y, 0, 0);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:0 animations:^{
        _tabView.frame = CGRectMake(20 , self.center.y - 110, SCREEN_WIDTH -40, 260);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _closeBtn.alpha = 1;
        }];
    }];
    
}

-(void) hide {
    [self removeFromSuperview];
}

#pragma mark- tableview functions

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"select_car_cell";
    SelectCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.infoList = [_dataList[indexPath.row] objectForKey:@"infoList"];
    cell.addressList = [_dataList[indexPath.row] objectForKey:@"addressList"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [_dataList[indexPath.row] objectForKey:@"data"];
    DDLogDebug(@"select %@", dic);
    [self.delegate selectCar:self.carId goods:[dic objectForKey:@"id"]];
    [self hide];
}

@end
