//
//  AgreementViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/10/15.
//
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"agreement.html";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    self.title = @"协议";
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
