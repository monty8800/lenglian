//
//  SearchCarsViewController.m
//  HelloCordova
//
//  Created by YYQ on 15/9/26.
//
//

#import "SearchCarsViewController.h"

@interface SearchCarsViewController ()

@end

@implementation SearchCarsViewController


-(instancetype)init {
    self = [super init];
    if (self) {
        self.startPage = @"foundCar.html";
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
    self.title = @"我要找车";
}

-(void)commonCommand:(NSArray *)params {
    [super commonCommand:params];
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
