//
//  ResetPasswdViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "ResetPasswdViewController.h"

@interface ResetPasswdViewController ()

@end

@implementation ResetPasswdViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"resetPasswd.html";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"重置密码";
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
