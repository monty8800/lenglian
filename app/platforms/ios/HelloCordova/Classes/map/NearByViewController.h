//
//  NearByViewController.h
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "BaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "SelectTab.h"
#import "SelectWarehouseWidget.h"
#import "SelectCarWidget.h"

@interface NearByViewController : UIViewController <SelectTabProtocl, BMKMapViewDelegate, SelectWarehouseDelegate, SelectCarDelegate>
{
    BMKMapView *_mapView;
    
    SelectTab *_tab;
    
    NSMutableArray *_annoList;
    
    BOOL _refresh;
}

@property (assign, nonatomic) NSInteger tabIndex;

@end
