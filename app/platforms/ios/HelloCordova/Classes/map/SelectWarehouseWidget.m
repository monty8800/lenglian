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
    
    _commonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 260 + 44)];
    [_commonView setCenter:self.center];
    [self addSubview:_commonView];

    
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, 260) style:UITableViewStylePlain];
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.backgroundColor = [UIColor whiteColor];
    [_tabView registerClass:[SelectWarehouseTableViewCell class] forCellReuseIdentifier:@"select_warehouse_cell"];
    [_commonView addSubview:_tabView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(_tabView.frame.origin.x, _tabView.frame.origin.y + _tabView.frame.size.height, _tabView.frame.size.width, 44)];
    [bottomView setBackgroundColor:[UIColor WY_ColorWithHex:0xececec]];
    [_commonView addSubview:bottomView];
    
    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeBtn setFrame:CGRectMake(0, 1, bottomView.frame.size.width/2 - 0.5, bottomView.frame.size.height - 1)];
    [_closeBtn setBackgroundColor:[UIColor whiteColor]];
    [_closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_closeBtn];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setBackgroundColor:[UIColor whiteColor]];
    [_sureBtn setFrame:CGRectMake(bottomView.frame.size.width/2 + 0.5, 1, bottomView.frame.size.width/2 - 0.5, bottomView.frame.size.height - 1)];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sureBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

    [_sureBtn addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sureBtn setEnabled:NO];
    [bottomView addSubview:_sureBtn];
    

}

-(void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    [_tabView reloadData];
}



+(void)show:(id<SelectWarehouseDelegate>)delegate warehouseId:(NSString *)warehouseId {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
     SelectWarehouseWidget *widget = [[SelectWarehouseWidget alloc] initWithFrame:window.bounds];
    widget.hidden = YES;
    [window addSubview:widget];
    widget.delegate = delegate;
    widget.warehouseId = warehouseId;
    [widget requestData];
    
}

-(void) requestData {
    NSDictionary *user = [Global getUser];
    NSString *userId = [user objectForKey:@"id"];
    if (userId != nil) {
        [Net post:MY_GOODS params:@{@"userId": userId, @"resourceStatus": @"1", @"priceType":@"1",@"coldStoreFlag":@"1"} cb:^(NSDictionary *responseDic) {
            DDLogDebug(@"MY goods %@", responseDic);
            if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
                NSMutableArray *goodsList = [NSMutableArray new];
                for (NSDictionary *dic in [[responseDic objectForKey:@"data"] objectForKey:@"GoodsResource"]) {
                    
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
                    
                    if (weight != nil && ![weight isKindOfClass:[NSNull class]] && weight.length > 0 ) {
                        weightStr = [NSString stringWithFormat:@"货物规格： %@吨", weight];
                        if ([dic objectForKey:@"cube"] != nil && ![[dic objectForKey:@"cube"] isKindOfClass:[NSNull class]]) {
                            weightStr = [NSString stringWithFormat:@"%@ %@方",weightStr, [dic objectForKey:@"cube"]];
                        }
                    }
                    else
                    {
                        weightStr = [NSString stringWithFormat:@"货物规格： %@方", [dic objectForKey:@"cube"]];
                    }
                    
                    NSString *toArea = [dic objectForKey:@"toAreaName"];
                    NSString *fromArea = [dic objectForKey:@"fromAreaName"];
                    
                    
                    NSString *addr;
                    
                    NSMutableArray *infoList = [NSMutableArray new];
                    switch ([[dic objectForKey:@"coldStoreFlag"] integerValue]) {
                        case 1:
                            addr = @"不需要仓库";
                            break;
                            
                        case 2:
                            addr = fromArea;
                            break;
                            
                        case 3:
                            addr = toArea;
                            break;
                            
                        case 4:
                            addr = [NSString stringWithFormat:@"%@, %@", fromArea, toArea];
                            break;
                            
                        default:
                            break;
                    }
                    
                    NSAttributedString *warhouseStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"需要仓库地： %@", addr] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:16]}];
                    
                    [infoList addObject:warhouseStr];
                    
                    NSString *name = [dic objectForKey:@"name"];
                    if (![name isKindOfClass:[NSNull class]]) {
                        if (name.length == 0) {
                            name = @"无名称";
                        }
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
                [[Global sharedInstance] showErr:@"服务器异常！"];
                [self hide];
            }
        } loading:NO];
    }

}

-(void) showAnim {
    self.hidden = NO;
    _commonView.alpha = 0.1;
    _commonView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [UIView animateWithDuration:0.3 animations:^{
        _commonView.alpha = 1.0;
        _commonView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            _commonView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            
        }];
    }];
    

}

-(void) hide {
    [self removeFromSuperview];
}
-(void)sureButtonClick:(UIButton *)sureButton{
    NSDictionary *dic = [_dataList[_selectedIndex] objectForKey:@"data"];
    DDLogDebug(@"select %@", dic);
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectWarehouse:goods:)] && dic[@"id"]) {
        [self.delegate selectWarehouse:self.warehouseId goods:dic[@"id"]];
        [self hide];
    }
}
#pragma mark- tableview functions

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"select_warehouse_cell";
    SelectWarehouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.infoList = [_dataList[indexPath.row] objectForKey:@"infoList"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedIndex = indexPath.row;
    
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    [_sureBtn setEnabled:YES];
}
@end
