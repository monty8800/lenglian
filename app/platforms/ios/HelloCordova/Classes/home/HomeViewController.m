//
//  HomeViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "HomeViewController.h"
#import "SearchWarehouseViewController.h"
#import "WarehouseSearchGoodsViewController.h"
#import "MyWarehouseViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"home.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"首页";
    self.webView.frame = CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT);
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"searchCar"]) {
            NSLog(@"找车");
        }
        else if ([params[1] isEqualToString:@"searchWarehouse"])
        {
            NSLog(@"找库");
            SearchWarehouseViewController *searchWarehouse = [SearchWarehouseViewController new];
            [self.navigationController pushViewController:searchWarehouse animated:YES];
        }
        else if ([params[1] isEqualToString:@"dirverSearchWarehouse"])
        {
            NSLog(@"司机找库");
        }
        else if ([params[1] isEqualToString:@"warehouseSearchGoods"])
        {
            NSLog(@"仓库找货");
            WarehouseSearchGoodsViewController *wSG = [WarehouseSearchGoodsViewController new];
            [self.navigationController pushViewController:wSG animated:YES];
        }
        else if ([params[1] isEqualToString:@"releaseCar"])
        {
            NSLog(@"发布车源");
        }
        else if ([params[1] isEqualToString:@"releaseGoods"])
        {
            NSLog(@"发布货源");
        }
        else if ([params[1] isEqualToString:@"releaseWarehouse"])
        {
            NSLog(@"发布库源");
        }
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
