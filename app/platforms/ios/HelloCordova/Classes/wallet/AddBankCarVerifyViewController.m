//
//  AddBankCarVerifyViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/6.
//
//

#import "AddBankCarVerifyViewController.h"

@interface AddBankCarVerifyViewController ()

@end

@implementation AddBankCarVerifyViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"addBankCardVerify.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"填写校验码";
}

-(void)commonCommand:(NSArray *)params{
    [super commonCommand:params];
//    if ([params[0] integerValue] == 2) {
//        if ([params[1] integerValue] > 0) {
//            NSInteger distance = [params[1] integerValue];
//            NSArray *currentControllers = self.navigationController.viewControllers;
//            if (distance < currentControllers.count) {
//                [self.navigationController popToViewController:currentControllers[currentControllers.count - distance - 1] animated:YES];
//            }
//        }
//    }
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
