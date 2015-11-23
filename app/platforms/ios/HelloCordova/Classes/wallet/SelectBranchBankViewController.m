//
//  SelectBranchBankViewController.m
//  HelloCordova
//
//  Created by ywen on 15/11/23.
//
//

#import "SelectBranchBankViewController.h"

@interface SelectBranchBankViewController ()

@end

@implementation SelectBranchBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"assets" ofType:@"db" inDirectory:@"assets/db"];
    DDLogDebug(@"sqlite path %@", path);
    
    _db = [FMDatabase databaseWithPath:@""];
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
