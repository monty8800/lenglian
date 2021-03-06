//
//  RegisterViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "RegisterViewController.h"
#import "AgreementViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"register.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"注册";
}

-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
    if ([params[0] integerValue] == 1) {
        if ([params[1] isEqualToString:@"toAgreement"]) {
            AgreementViewController *agreementVC = [AgreementViewController new];
            [self.navigationController pushViewController:agreementVC animated:YES];
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
