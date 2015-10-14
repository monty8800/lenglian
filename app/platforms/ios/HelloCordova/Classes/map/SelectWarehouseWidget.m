//
//  SelectWarehouseWidget.m
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "SelectWarehouseWidget.h"
#import "Global.h"
#import "Net.h"

@implementation SelectWarehouseWidget

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
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 220) style:UITableViewStylePlain];
    _tabView.center = self.center;
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.backgroundColor = [UIColor whiteColor];
    [_tabView registerClass:[SelectWarehouseTableViewCell class] forCellReuseIdentifier:@"select_warehouse_cell"];
    [self addSubview:_tabView];
    
    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-33, _tabView.frame.origin.y-7, 20, 20)];
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



+(void)show:(id<SelectWarehouseDelegate>)delegate warehouseId:(NSString *)warehouseId {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
     SelectWarehouseWidget *widget = [[SelectWarehouseWidget alloc] initWithFrame:window.bounds];
    [window addSubview:widget];
    widget.delegate = delegate;
    widget.warehouseId = warehouseId;
    [widget showAnim];
    
}

-(void) showAnim {
    _closeBtn.alpha = 0;
    _tabView.frame = CGRectMake(self.center.x, self.center.y, 0, 0);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:0 animations:^{
        _tabView.frame = CGRectMake(20 , self.center.y - 110, SCREEN_WIDTH -40, 240);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _closeBtn.alpha = 1;
        }];
    }];
    
    NSDictionary *user = [Global getUser];
    NSString *userId = [user objectForKey:@"id"];
    if (userId != nil) {
        [Net post:MY_GOODS params:@{@"userId": userId, @"resourceStatus": @"1"} cb:^(NSDictionary *responseDic) {
            DDLogDebug(@"MY goods %@", responseDic);
            if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
                NSMutableArray *goodsList = [NSMutableArray new];
                for (NSDictionary *dic in [[responseDic objectForKey:@"data"] objectForKey:@"GoodsResource"]) {
//                    NSString *addr;
//                    switch ([[dic objectForKey:@"coldStoreFlag"] integerValue]) {
//                        case 2:
//                            addr = [NSString stringWithFormat:@"需要仓库地： %@, %@", [dic objectForKey:@"fromProvinceName"], [dic objectForKey:@"toProvinceName"]];
//                            break;
//                            
//                        case 3:
//                            addr = [NSString stringWithFormat:@"需要仓库地： %@", [dic objectForKey:@"toProvinceName"]];
//                            break;
//                            
//                        case 4:
//                            addr = [NSString stringWithFormat:@"需要仓库地： %@", [dic objectForKey:@"fromProvinceName"]];
//                            break;
//                            
//                        default:
//                            addr = @"不需要仓库";
//                            break;
//                    }
//                    
//                    NSAttributedString *addrStr = [[NSAttributedString alloc] initWithString:addr attributes:@{NSForegroundColorAttributeName: [UIColor WY_ColorWithHex:0x333333], NSFontAttributeName: [UIFont boldSystemFontOfSize:15]}];
                    
                    NSString *typeStr;
                    switch ([[dic objectForKey:@"goodsType"] integerValue]) {
                        case 1:
                            typeStr = @"货物种类： 常温";
                            break;
                            
                        case 2:
                            typeStr = @"货物种类： 冷藏";
                            break;
                            
                        case 3:
                            typeStr = @"货物种类： 冷冻";
                            break;
                            
                        case 4:
                            typeStr = @"货物种类： 急冻";
                            break;
                            
                        case 5:
                            typeStr = @"货物种类： 深冷";
                            break;
                            
                        default:
                            typeStr = @"货物种类： 其他";
                            break;
                    }
                    
                    NSString *weightStr;
                    
                    NSString *weight = [dic objectForKey:@"weight"];
                    
                    if (weight != nil && ![weight isKindOfClass:[NSNull class]] ) {
                        weightStr = [NSString stringWithFormat:@"货物重量： %@吨", weight];
                    }
                    else
                    {
                        weightStr = [NSString stringWithFormat:@"货物体积： %@方", [dic objectForKey:@"cube"]];
                    }
                    
                    NSMutableArray *infoList = [NSMutableArray new];
                    
                    NSString *name = [dic objectForKey:@"name"];
                    if (![name isKindOfClass:[NSNull class]]) {
                        [infoList addObject:[NSString stringWithFormat:@"货物名称： %@", name]];
                    }
                    
                    [infoList addObject:typeStr];
                    [infoList addObject:weightStr];
                    
                    
                    [goodsList addObject:@{
                                           @"data": @{
                                                   @"id": [dic objectForKey:@"id"]
                                                   },
                                           @"infoList": infoList
                                           }];
                    
                    if (goodsList.count > 0) {
                        self.dataList = goodsList;
                    }
                    else
                    {
                        [UIView animateWithDuration:0.15 animations:^{
                            self.alpha = 0;
                        } completion:^(BOOL finished) {
                            [self hide];
                            [[Global sharedInstance] showErr:@"没有可用货源，请添加货源后重试"];
                        }];
                        
                    }
                    
                }
            }
            else
            {
                [[Global sharedInstance] showErr:@"服务器异常！"];
            }
        } loading:NO];
    }
    

}

-(void) hide {
    [self removeFromSuperview];
}

#pragma mark- tableview functions

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"select_warehouse_cell";
    SelectWarehouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.infoList = [_dataList[indexPath.row] objectForKey:@"infoList"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [_dataList[indexPath.row] objectForKey:@"data"];
    DDLogDebug(@"select %@", dic);
    [self.delegate selectWarehouse:_warehouseId goods:[dic objectForKey:@"id"]];
    [self hide];
}

@end
