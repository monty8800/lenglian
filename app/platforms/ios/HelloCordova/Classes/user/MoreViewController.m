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
        if ([params[1] isEqualToString:@"changePasswd"]) {
            ChangePasswdViewController *changePwdVC = [ChangePasswdViewController new];
            [self.navigationController pushViewController:changePwdVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"resetPasswd"])
        {
            ResetPasswdViewController *resetPwdVC = [ResetPasswdViewController new];
            [self.navigationController pushViewController:resetPwdVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"login"])
        {
            LoginViewController *loginVC = [LoginViewController new];
            [self.navigationController pushViewController:loginVC animated:YES];
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
