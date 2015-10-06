//
//  ReleaseCarViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/2.
//
//

#import "ReleaseCarViewController.h"
#import "SelectAddressViewController.h"

@interface ReleaseCarViewController ()

@end

@implementation ReleaseCarViewController


-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"releaseVehicle.html";
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
    self.title = @"发布车源";
    
    UIImage *navBgBlue = [UIImage WY_ImageWithColor:0x2a7df5 size:CGSizeMake(1, self.navigationController.navigationBar.bounds.size.height+20)];
    
    [self.navigationController.navigationBar setBackgroundImage:navBgBlue forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"select_start_address"] || [params[1] isEqualToString:@"select_end_address"]) {
            SelectAddressViewController *selectAddressVC = [SelectAddressViewController new];
            [self.navigationController pushViewController:selectAddressVC animated:YES];
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
