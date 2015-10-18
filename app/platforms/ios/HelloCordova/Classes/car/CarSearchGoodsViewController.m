//
//  CarSearchGoodsViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/5.
//
//

#import "CarSearchGoodsViewController.h"
#import "CarbidGoodsViewController.h"
#import "SearchGoodsDetailViewController.h"
#import "Net.h"

@interface CarSearchGoodsViewController ()

@end

@implementation CarSearchGoodsViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"carFindGoods.html";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"司机找货";
    UIButton *addWarehouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addWarehouseButton setFrame:CGRectMake(0, 0, 40, 44)];
    [addWarehouseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [addWarehouseButton setTitle:@"搜索" forState:UIControlStateNormal];
    [addWarehouseButton addTarget:self action:@selector(sureToSearch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addWarehouseButton];
}
-(void)sureToSearch{
    [self.commandDelegate evalJs:@"(function(){window.doCarSearchGoods()})()"];
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    if ([params[0] integerValue] == 3) {
        if ([params [1] isEqualToString:@"order:car:select:goods:done"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
            //TODO: 跳转到订单页面
        }
        else if ([params[1] isEqualToString:@"select:car"])
        {
            [SelectGoodsWidget show:self goods:params[2] type:Cars];
            _bid = [params[3] boolValue];
        }
    }
    else if ([params[0] integerValue] == 1)
    {
        if ([params[1] isEqualToString:@"carBidGoods"]) {
            CarbidGoodsViewController *bidVC = [CarbidGoodsViewController new];
            [self.navigationController pushViewController:bidVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"searchGoodsDetail"])
        {
            SearchGoodsDetailViewController *detailVC = [SearchGoodsDetailViewController new];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

-(void)selectGoods:(NSString *)goodsId car:(NSString *)carId
{
    if (_bid) {
        NSString *js = [NSString stringWithFormat:@"(function(){window.goBid('%@', '%@')})()", carId, goodsId];
        [self.commandDelegate evalJs: js];
    }
    else{
        NSDictionary *params = @{
                                 @"userId": [[Global getUser] objectForKey:@"id"],
                                 @"goodsResourceId": goodsId,
                                 @"carResourceId": carId
                                 };
        [Net post:ORDER_CAR_SELECT_GOODS params:params cb:^(NSDictionary *responseDic) {
            DDLogDebug(@"goods select car result %@", responseDic);
            if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
                [[Global sharedInstance] showSuccess:@"抢单成功！"];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
            }
        } loading:YES];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
