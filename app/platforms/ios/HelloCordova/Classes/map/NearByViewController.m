//
//  NearByViewController.m
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "NearByViewController.h"
#import "Net.h"
#import "XeAnnotationView.h"
#import "XeAnnotation.h"
#import "XeBubbleView.h"

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
    
    _tabIndex = 0;
    
    _annoList = [NSMutableArray new];

    [self.view addSubview:_tab];

    
    //地图
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0,  tabHeight, SCREEN_WIDTH, self.view.bounds.size.height - tabHeight)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
}

-(void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    self.tabIndex = _tabIndex;
}

-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    [self mapViewDidFinishLoading:mapView];
}

-(void)selectTab:(NSInteger)index {
    DDLogDebug(@"select tab %@", @(index));
    self.tabIndex = index;
}

-(void)setTabIndex:(NSInteger)tabIndex {
    _tabIndex = tabIndex;
    NSString *api = NEARBY_CAR;
    NSString *loadingString = @"正在获取";
    switch (tabIndex) {
        case 0:
            api = NEARBY_CAR;
            loadingString = @"正在获取车源详情。。。";
            break;
            
        case 1:
            api = NEARBY_GOODS;
            loadingString = @"正在获取货源详情。。。";
            break;
            
        case 2:
            api = NEARBY_WAREHOUSE;
            loadingString = @"正在获取库源详情。。。";
            break;
            
        default:
            break;
    }
    
    
    CLLocationCoordinate2D rightTop = [_mapView convertPoint:CGPointMake(SCREEN_WIDTH, 0) toCoordinateFromView:_mapView];
    CLLocationCoordinate2D leftBottom = [_mapView convertPoint:CGPointMake(0, _mapView.bounds.size.height) toCoordinateFromView:_mapView];
    
    DDLogDebug(@"rightTop %f, %f, leftBottom %f, %f", rightTop.latitude, rightTop.longitude, leftBottom.latitude, leftBottom.longitude);
    
    NSDictionary *params = @{
                             @"leftLng": [NSString stringWithFormat:@"%f", leftBottom.longitude],
                             @"leftLat": [NSString stringWithFormat:@"%f", leftBottom.latitude],
                             @"rightLng": [NSString stringWithFormat:@"%f", rightTop.longitude],
                             @"rightLat": [NSString stringWithFormat:@"%f", rightTop.latitude],
                             };
    
    [Net post: api params: params cb:^(NSDictionary *responseDic) {
        DDLogDebug(@"result---- %@", responseDic);
        if ([[responseDic objectForKey:@"code"] isEqualToString:@"0000"]) {
            DDLogDebug(@"data:--%@", [responseDic objectForKey:@"data"]);
            NSArray *arr = [responseDic objectForKey:@"data"];
            if ([arr isKindOfClass:[NSArray class]]) {
                BOOL exist = NO;
                for (NSDictionary *dic in arr) {
                    for (XeAnnotation *oldAnno in _annoList) {
                        if ([[oldAnno.data objectForKey:@"id"] isEqualToString:[dic objectForKey:@"id"]]) {
                            exist = YES;
                            break;
                        }
                    }
                    
                    if (!exist) {
                        XeAnnotation *anno = [XeAnnotation new];
                        anno.coordinate = CLLocationCoordinate2DMake([[dic objectForKey:@"lat"] floatValue], [[dic objectForKey:@"lng"] floatValue]);
                        anno.title = loadingString;
                        anno.data = dic;
                        
                        [_mapView addAnnotation:anno];
                        [_annoList addObject:anno];
                    }
                    
                }
            }
            
        }
        else
        {
            [[Global sharedInstance] showErr:[responseDic objectForKey:@"msg"]];
        }
        
    }];
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSString *identifier = @"anno";
    XeAnnotationView *annoView = (XeAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annoView == nil) {
        annoView = [[XeAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"anno"];
    }
    
    switch (_tabIndex) {
        case 0:
            annoView.type = CAR;
            break;
            
        case 1:
            annoView.type = GOODS;
            break;
            
        case 2:
            annoView.type = WAREHOUSE;
            break;
            
        default:
            break;
    }
    XeBubbleView *bubble = [[XeBubbleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20, 250)];
//    bubble.backgroundColor = [UIColor redColor];
    annoView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:bubble];
    annoView.data = ((XeAnnotation *)annotation).data;
    annoView.calloutOffset = CGPointMake(0, 250 + annoView.bounds.size.height);
    return annoView;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    XeAnnotationView *xeAnnoView = (XeAnnotationView *) view;
    DDLogDebug(@"click %@", xeAnnoView.data);
    CGPoint pt = [_mapView convertCoordinate:xeAnnoView.annotation.coordinate toPointToView:_mapView];
    CLLocationCoordinate2D center = [_mapView convertPoint:CGPointMake(pt.x, pt.y + 100) toCoordinateFromView:_mapView];
    [_mapView setCenterCoordinate:center animated:YES];
    NSString *api;
    switch (xeAnnoView.type) {
        case CAR:
            api = NEARBY_CAR_DETAIL;
            break;
            
        case GOODS:
            api = NEARBY_GOODS_DETAIL;
            break;
            
        case WAREHOUSE:
            api = NEARBY_WAREHOUSE_DETAIL;
            break;
            
        default:
            break;
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
