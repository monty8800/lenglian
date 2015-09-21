//
//  UserCenterViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "UserCenterViewController.h"
#import "MoreViewController.h"

@interface UserCenterViewController ()

@end

@implementation UserCenterViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"userCenter.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"我的";
}

-(void)commonCommand:(NSArray *)params {
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"more"]) {
            MoreViewController *moreVC = [MoreViewController new];
            [self.navigationController pushViewController:moreVC animated:YES];
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
