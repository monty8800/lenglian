//
//  LoactionViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/26.
//
//

#import "LocationViewController.h"
#import "Global.h"
#import "XeAnnotationView.h"
#import "LocationBubbleView.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

-(void) createUI {
    //返回按钮
    UIBarButtonItem *backItem = [[UIBarButtonItem  alloc] initWithImage:[[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navBack)];
    self.navigationItem.leftBarButtonItem = backItem;

    
    //导航栏标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    [titleLabel WY_SetFontSize:19 textColor:0xffffff];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    titleLabel.text = @"选择地区";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor WY_ColorWithHex:0x1987c6];
    
    
    //去掉导航栏分割线
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
   // [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg"] forBarMetrics: UIBarMetricsDefault];
    
    //地图
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.zoomLevel = 11;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT -66 - 50, SCREEN_WIDTH-20, 40)];
    commitBtn.backgroundColor = [UIColor WY_ColorWithHex:0x28b3ec];
    [commitBtn WY_MakeCorn:2];
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    
   
    [Global getLocation:^(BMKUserLocation *location) {
        DDLogDebug(@"-----location:%@", location);
        __block __weak LocationViewController *weakSelf = self;
        [weakSelf addAnno:location];
    }];
}

-(void) addAnno:(BMKUserLocation *) location {
    [_mapView setCenterCoordinate:location.location.coordinate];
    _pointAnno = [BMKPointAnnotation new];
    _pointAnno.coordinate = location.location.coordinate;
    _pointAnno.title = @"我的位置";
    __block __weak LocationViewController *weakSelf = self;
    [Global reverseGeo:location.location.coordinate cb:^(BMKReverseGeoCodeResult *result) {
        [weakSelf updateAddress:result];
    }];
    _pointAnno.subtitle = @"拖拽修改位置";
    [_mapView addAnnotation:_pointAnno];
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSString *AnnotationViewID = @"renameMark";
    XeAnnotationView *annotationView = (XeAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[XeAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置可拖拽
        annotationView.draggable = YES;
        annotationView.type = POINT;
    }
    _bubble = [[LocationBubbleView alloc] initWithFrame:CGRectMake(0, 0, 190, 90)];
    annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:_bubble];
    annotationView.calloutOffset = CGPointMake(0, -10);
    return annotationView;
}

-(void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState {
    if (newState == BMKAnnotationViewDragStateEnding) {
        __block __weak LocationViewController *weakSelf = self;
        [Global reverseGeo:_pointAnno.coordinate cb:^(BMKReverseGeoCodeResult *result) {
            [weakSelf updateAddress:result];
        }];
    }
}

-(void) updateAddress:(BMKReverseGeoCodeResult *) result {
    _pointAnno.title = result.address;
    _address = result.addressDetail;
    _bubble.address = [NSString stringWithFormat:@"%@%@%@", _address.province, _address.city, _address.district];
    _bubble.street = [NSString stringWithFormat:@"%@%@", _address.streetName, _address.streetNumber];
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    if (_pointAnno == view.annotation) {
        DDLogDebug(@"%f, %f", _pointAnno.coordinate.latitude, _pointAnno.coordinate.longitude);
        
    }
    
}

-(void) commit {
    if (_address != nil) {
        [self.delegate select:_address coor:_pointAnno.coordinate];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void) navBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    _mapView.delegate = nil;
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
