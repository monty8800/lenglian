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
#import "SelectGoodsWidget.h"

@interface NearByViewController : UIViewController <SelectTabProtocl, BMKMapViewDelegate, SelectWarehouseDelegate, SelectCarDelegate, SelectGoodsDelegate>
{
    BMKMapView *_mapView;
    
    
    NSMutableArray *_annoList;
    
    BOOL _refresh;
}

@property (assign, nonatomic) NSInteger tabIndex;
@property (strong, nonatomic) SelectTab *tab;

@end
