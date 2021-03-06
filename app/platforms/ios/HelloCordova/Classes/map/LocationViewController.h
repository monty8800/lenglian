//
//  LoactionViewController.h
//  HelloCordova
//
//  Created by ywen on 15/9/26.
//
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "LocationBubbleView.h"

@protocol LocationDelegate <NSObject>

@required
-(void) select:(BMKAddressComponent *) address coor:(CLLocationCoordinate2D) coor;

@end

@interface LocationViewController : UIViewController <BMKMapViewDelegate>
{
    BMKMapView *_mapView;
    BMKPointAnnotation *_pointAnno;
    BMKAddressComponent *_address;
    LocationBubbleView *_bubble;
    CGPoint _pt;
}

@property (weak, nonatomic) id<LocationDelegate> delegate;

@end
