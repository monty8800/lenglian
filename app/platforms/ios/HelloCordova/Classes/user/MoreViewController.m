//
//  MoreViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "MoreViewController.h"

#import "ChangePasswdViewController.h"
#import "ResetPasswdViewController.h"
#import "LoginViewController.h"
#import "AboutUsViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"more.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"更多";
}


-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"aboutUs"]) {
            AboutUsViewController *aboutUsVC = [AboutUsViewController new];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
    }else if ([params[0] integerValue] == 7){
        if ([params[1] isEqualToString:@"orderList_userChange"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_user_logout" object:nil];
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
