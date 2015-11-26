//
//  SelectGoodsWidget.m
//  HelloCordova
//
//  Created by ywen on 15/10/4.
//
//

#import "SelectGoodsWidget.h"
#import "Global.h"
#import "Net.h"

@implementation SelectGoodsWidget

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
//    _tabView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.separatorStyle = self.type == Cars?UITableViewCellSeparatorStyleNone:UITableViewCellSeparatorStyleSingleLine;
    _tabView.backgroundColor = [UIColor whiteColor];
    [_tabView registerClass:[SelectGoodsTableViewCell class] forCellReuseIdentifier:SELECT_GOODS_CELL];
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
    
    
//    _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-33, self.center.y-117, 20, 20)];
//    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_closeBtn WY_SetBgColor:0x1987c6 title:@"X" titleColor:0xffffff corn:10 fontSize:15];
//    _closeBtn.hitTestEdgeInsets = UIEdgeInsetsMake(-20, -20, -20, -20);
//    [self addSubview:_closeBtn];
    
    //    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    //    [self addGestureRecognizer:tapGes];
}

-(void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    [_tabView reloadData];
}

+(void)show:(id<SelectGoodsDelegate>)delegate goods:(NSString *)goodsId type:(GoodsWidgetType)type
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    SelectGoodsWidget *widget = [[SelectGoodsWidget alloc] initWithFrame:window.bounds];
    widget.hidden = YES;
    [window addSubview:widget];
    widget.delegate = delegate;
    widget.goodsId= goodsId;
    widget.type = type;
    [widget requestData];
}


-(void) requestData {
    NSDictionary *user = [Global getUser];
    NSString *userId = [user objectForKey:@"id"];
    if (userId != nil) {
        switch (self.type) {
            case Cars:
                [self getCars:userId];
                break;
                
            case Warehouses:
                [self getWarehouses:userId];
                break;
                
            default:
                break;
        }
        
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
- (void)sureButtonClick:(UIButton *)sureButton{
    NSDictionary *dic = [_dataList[_selectedIndex] objectForKey:@"data"];
    DDLogDebug(@"select %@", dic);
    switch (self.type) {
        case Cars:
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoods:car:)]) {
                [self.delegate selectGoods:self.goodsId car:[dic objectForKey:@"id"]];
            }
            break;
            
        case Warehouses:
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectGoods:warehouse:)]) {
                [self.delegate selectGoods:self.goodsId warehouse:[dic objectForKey:@"id"]];
            }
            break;
            
        default:
            break;
    }
    
    [self hide];
}
//TODO:  这里有分页
-(void) getWarehouses:(NSString *) userId {
    [Net post:MY_WAREHOUSE params:@{@"userId": userId, @"status": @"2", @"pageNow": @"1", @"pageSize": @"10"} cb:^(NSDictionary *responseDic) {
        DDLogDebug(@"MY warehouse %@", responseDic);
        if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
            NSMutableArray *warehouseList = [NSMutableArray new];
            for (NSDictionary *dic in [[responseDic objectForKey:@"data"] objectForKey:@"myWarehouse"]) {
                
                NSAttributedString *warehouseName = [[NSAttributedString alloc] initWithString:[dic objectForKey:@"name"] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:18]}];
                
                NSString *address = [NSString stringWithFormat:@"%@%@%@%@", [dic objectForKey:@"provinceName"], [dic objectForKey:@"cityName"], [dic objectForKey:@"areaName"], [dic objectForKey:@"street"]];
                
                [warehouseList addObject:@{
                                       @"infoList":@[warehouseName, address],
                                       @"data": @{
                                               @"id": [dic objectForKey:@"mjWarehouseResourceId"],
                                               }
                                       }];
            }
            
            if (warehouseList.count > 0) {
                self.dataList = warehouseList;
                [self showAnim];
            }
            else
            {
                [[Global sharedInstance] showErr:@"没有可用库源，请添加库源后再试"];
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


-(void) getCars: (NSString *) userId {
    [Net post:MY_CARS params:@{@"userId": userId, @"goodsResourceId": self.goodsId} cb:^(NSDictionary *responseDic) {
        DDLogDebug(@"MY goods %@", responseDic);
        if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
            NSMutableArray *goodsList = [NSMutableArray new];
            for (NSDictionary *dic in [responseDic objectForKey:@"data"]) {
                
                NSString *carNo = [NSString stringWithFormat:@"车牌号码： %@", [dic objectForKey:@"carno"]];
                NSAttributedString *carNoStr = [[NSAttributedString alloc] initWithString:carNo attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}];
                
                NSString *category;
                switch ([[dic objectForKey:@"category"] integerValue]) {
                    case 1:
                        category = @"车辆类别： 单车";
                        break;
                        
                    case 2:
                        category = @"车辆类别： 前四后四";
                        break;
                        
                    case 3:
                        category = @"车辆类别： 前四后六";
                        break;
                        
                    case 4:
                        category = @"车辆类别： 前四后八";
                        break;
                        
                    case 5:
                        category = @"车辆类别： 后八轮";
                        break;
                        
                    case 6:
                        category = @"车辆类别： 五桥";
                        break;
                        
                    case 7:
                        category = @"车辆类别： 六桥";
                        break;
                        
                    case 8:
                        category = @"车辆类别： 半挂";
                        break;
                        
                    default:
                        category = @"车辆类别： 未知";
                        break;
                }
                
                
                NSString *type;
                switch ([[dic objectForKey:@"type"] integerValue]) {
                    case 1:
                        type = @"车辆类型： 普通卡车";
                        break;
                        
                    case 2:
                        type = @"车辆类型： 冷藏车";
                        break;
                        
                    case 3:
                        type = @"车辆类型： 平板";
                        break;
                        
                    case 4:
                        type = @"车辆类型： 箱式";
                        break;
                        
                    case 5:
                        type = @"车辆类型： 集装箱";
                        break;
                        
                    case 6:
                        type = @"车辆类型： 高栏";
                        break;
                        
                    default:
                        type = @"车辆类型： 未知";
                        break;
                }
                
                NSString *carLength = @"";
                switch ([[dic objectForKey:@"vehicle"] integerValue]) {
                    case 1:
                        carLength = @"车辆长度： 3.8米";
                        break;
                    case 2:
                        carLength = @"车辆长度： 4.2米";
                        break;
                    case 3:
                        carLength = @"车辆长度： 4.8米";
                        break;
                    case 4:
                        carLength = @"车辆长度： 5.8米";
                        break;
                    case 5:
                        carLength = @"车辆长度： 6.2米";
                        break;
                    case 6:
                        carLength = @"车辆长度： 6.8米";
                        break;
                    case 7:
                        carLength = @"车辆长度： 7.4米";
                        break;
                    case 8:
                        carLength = @"车辆长度： 7.8米";
                        break;
                    case 9:
                        carLength = @"车辆长度： 8.6米";
                        break;
                    case 10:
                        carLength = @"车辆长度： 9.6米";
                        break;
                    case 11:
                        carLength = @"车辆长度： 13~15米";
                        break;
                    case 12:
                        carLength = @"车辆长度： 15米以上";
                        break;
                    default:
                        carLength = @"车辆长度： 未知";
                        break;
                }
                
                [goodsList addObject:@{
                                       @"infoList":@[carNoStr, category, type, carLength],
                                       @"data": @{
                                               @"id": [dic objectForKey:@"id"],
                                               }
                                       }];
            }
            
            if (goodsList.count > 0) {
                self.dataList = goodsList;
                [self showAnim];
            }
            else
            {
                [[Global sharedInstance] showErr:@"没有可用车源，请添加车源后重试"];
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

-(void) hide {
    [self removeFromSuperview];
}

#pragma mark- tableview functions

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    switch (self.type) {
        case Cars:
            height = 90;
            break;
            
        case Warehouses:
            height = 65;
            break;
            
        default:
            break;
    }
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == Cars){
        SelectGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SELECT_GOODS_CELL];
        cell.infoList = [_dataList[indexPath.row] objectForKey:@"infoList"];
        return cell;
    }else{
        SelectWarehouseTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"warehousecell"];
        if (cell == nil) {
            cell = [[SelectWarehouseTableViewCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"warehousecell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.warehouseDic = @{@"name":_dataList[indexPath.row][@"infoList"][0],@"address":_dataList[indexPath.row][@"infoList"][1]};
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    [_sureBtn setEnabled:YES];
}
@end
