//
//  MyGoodsListViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/3.
//
//

#import "MyGoodsListViewController.h"
#import "GoodsDetailViewController.h"
#import "AddGoodsViewController.h"
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
//
-(void)createUI{
    self.title = @"我的货源";
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(0, 0, 60, 44)];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [saveButton setTitle:@"发布货源" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(releaseGoodsResource) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.commandDelegate evalJs:@"(function(){window.tryReloadMyGoodsList()})()"];
    
}
-(void)releaseGoodsResource{
    AddGoodsViewController *addGoodsVC = [AddGoodsViewController new];
    [self.navigationController pushViewController:addGoodsVC animated:YES];
}
-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"goodsDetail"]) {
            GoodsDetailViewController *goodsDetailVC = [GoodsDetailViewController new];
            [self.navigationController pushViewController:goodsDetailVC animated:YES];
        }
    }else if ([params[0] integerValue] == 3){
        if ([params[1] isEqualToString:@"shouldScrollEnable"]) {
            [self.webView.scrollView setScrollEnabled:([params[1] integerValue] == 0)];
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
