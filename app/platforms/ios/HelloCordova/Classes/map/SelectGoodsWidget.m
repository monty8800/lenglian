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
    _tabView = [[UITableView alloc] initWithFrame:CGRectMake(20, self.center.y - 110, SCREEN_WIDTH-40, 260) style:UITableViewStylePlain];
    _tabView.center = self.center;
    _tabView.dataSource = self;
    _tabView.delegate = self;
    _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tabView.backgroundColor = [UIColor whiteColor];
    [_tabView registerClass:[SelectGoodsTableViewCell class] forCellReuseIdentifier:SELECT_GOODS_CELL];
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

+(void)show:(id<SelectGoodsDelegate>)delegate goods:(NSString *)goodsId
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    SelectGoodsWidget *widget = [[SelectGoodsWidget alloc] initWithFrame:window.bounds];
    [window addSubview:widget];
    widget.delegate = delegate;
    widget.goodsId= goodsId;
    [widget showAnim];
}



-(void) showAnim {
    _closeBtn.alpha = 0;
    _tabView.frame = CGRectMake(self.center.x, self.center.y, 0, 0);
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.7 options:0 animations:^{
        _tabView.frame = CGRectMake(20 , self.center.y - 110, SCREEN_WIDTH -40, 260);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _closeBtn.alpha = 1;
        }];
    }];
    
    NSDictionary *user = [Global getUser];
    NSString *userId = [user objectForKey:@"id"];
    if (userId != nil) {
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
                    
                    NSString *carLength = [NSString stringWithFormat:@"车辆长度： %@米", [dic objectForKey:@"vehicle"]];
                    
                    [goodsList addObject:@{
                                           @"infoList":@[carNoStr, category, type, carLength],
                                           @"data": @{
                                                   @"id": [dic objectForKey:@"id"],
                                                   }
                                           }];
                }
                
                self.dataList = goodsList;
                
            }
            else
            {
                [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
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
    return 130;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"select_car_cell";
    SelectGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.infoList = [_dataList[indexPath.row] objectForKey:@"infoList"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [_dataList[indexPath.row] objectForKey:@"data"];
    DDLogDebug(@"select %@", dic);
    [self.delegate selectGoods:self.goodsId car:[dic objectForKey:@"id"]];
    [self hide];
}

@end