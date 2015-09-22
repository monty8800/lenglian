//
//  NearByViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "NearByViewController.h"

@interface NearByViewController ()

@end

@implementation NearByViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
}

-(void) createUI {
    self.title = @"附近";
    
    //导航栏
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics: UIBarMetricsDefault];
    
    //选择tab
    CGFloat tabHeight = ceilf(45 * REALSCREEN_MULTIPBY);
    DDLogDebug(@"-----tab height %f", tabHeight);
    _tab = [[SelectTab alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, tabHeight)];
    _tab.delegate = self;
    _tab.tabs = @[@"附近的车源", @"附近的货源", @"附近的库源"];

    [self.view addSubview:_tab];

    
    //地图
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0,  tabHeight, SCREEN_WIDTH, self.view.bounds.size.height - tabHeight)];
    [self.view addSubview:_mapView];
}

-(void)selectTab:(NSInteger)index {
    DDLogDebug(@"select tab %@", @(index));
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
