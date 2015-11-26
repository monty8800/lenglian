//
//  SearchCarsViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/26.
//
//

#import "SearchCarsViewController.h"
#import "Net.h"
#import "CarOwnerDetailViewController.h"

@interface SearchCarsViewController ()

@end

@implementation SearchCarsViewController


-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"foundCar.html";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void) createUI {
    self.title = @"我要找车";
//    UIButton *addWarehouseButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addWarehouseButton setFrame:CGRectMake(0, 0, 40, 44)];
//    [addWarehouseButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
//    [addWarehouseButton setTitle:@"搜索" forState:UIControlStateNormal];
//    [addWarehouseButton addTarget:self action:@selector(sureToSearch) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addWarehouseButton];
}
//-(void)sureToSearch{
//    NSString *js = [NSString stringWithFormat:@"(function(){window.searchMyCar()})()"];
//    [self.commandDelegate evalJs: js];
//}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"select_goods"]) {
            [SelectCarWidget show:self carId:params[2]];
        }
        else if ([params[1] isEqualToString:@"carOwnerDetail"])
        {
            CarOwnerDetailViewController *carOwnerVC = [CarOwnerDetailViewController new];
            [self.navigationController pushViewController:carOwnerVC animated:YES];
        }
    }
}

-(void)selectCar:(NSString *)carId goods:(NSString *)goodsId {
    NSDictionary *params = @{
                             @"userId": [[Global getUser] objectForKey:@"id"],
                             @"goodsResouseId": goodsId,
                             @"carResouseId": carId
                             };
    [Net post:ORDER_GOODS_SELECT_CAR params:params cb:^(NSDictionary *responseDic) {
        DDLogDebug(@"goods select car result %@", responseDic);
        if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
            [[Global sharedInstance] showSuccess:@"成功选择该车辆"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
        }
    } loading:YES];
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
