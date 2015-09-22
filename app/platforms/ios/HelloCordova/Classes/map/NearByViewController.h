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

@interface NearByViewController : UIViewController <SelectTabProtocl>
{
    BMKMapView *_mapView;
    
    SelectTab *_tab;
    
}

@end
