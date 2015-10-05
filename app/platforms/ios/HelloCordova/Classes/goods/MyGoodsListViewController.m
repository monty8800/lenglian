//
//  MyGoodsListViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/3.
//
//

#import "MyGoodsListViewController.h"
#import "GoodsDetailViewController.h"
@interface MyGoodsListViewController ()

@end

@implementation MyGoodsListViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"myGoodsList.html";
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void)createUI{
    self.title = @"我的货源";
}

-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"goodsDetail"]) {
            GoodsDetailViewController *goodsDetailVC = [GoodsDetailViewController new];
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
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
