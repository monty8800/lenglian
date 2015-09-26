//
//  AddGoodsViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/26.
//
//

#import "AddGoodsViewController.h"

@interface AddGoodsViewController ()

@end

@implementation AddGoodsViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"addGoods.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"发布货源";
    UIImage *navBgBlue = [UIImage WY_ImageWithColor:0x2a7df5 size:CGSizeMake(1, self.navigationController.navigationBar.bounds.size.height+20)];
    
    [self.navigationController.navigationBar setBackgroundImage:navBgBlue forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
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
