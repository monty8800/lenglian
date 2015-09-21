//
//  LoginViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ResetPasswdViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"login.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"登录";
}

-(void)commonCommand:(NSArray *)params {
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"register"]) {
            RegisterViewController *registerVC = [RegisterViewController new];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
        else if ([params[1] isEqualToString:@"resetPasswd"])
        {
            ResetPasswdViewController *resetPwdVC = [ResetPasswdViewController new];
            [self.navigationController pushViewController:resetPwdVC animated:YES];
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
