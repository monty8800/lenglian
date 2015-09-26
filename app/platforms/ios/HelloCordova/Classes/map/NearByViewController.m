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
    
    //导航栏标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [titleLabel WY_SetFontSize:19 textColor:0xffffff];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    titleLabel.text = @"附近";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor WY_ColorWithHex:0x1987c6];
    
    //去掉导航栏分割线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics: UIBarMetricsDefault];
    
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
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
}

-(void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    CLLocationCoordinate2D rightTop = [_mapView convertPoint:CGPointMake(SCREEN_WIDTH, 0) toCoordinateFromView:_mapView];
    CLLocationCoordinate2D leftBottom = [_mapView convertPoint:CGPointMake(0, _mapView.bounds.size.height) toCoordinateFromView:_mapView];
    
    DDLogDebug(@"rightTop %f, %f, leftBottom %f, %f", rightTop.latitude, rightTop.longitude, leftBottom.latitude, leftBottom.longitude);
}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self mapViewDidFinishLoading:mapView];
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
