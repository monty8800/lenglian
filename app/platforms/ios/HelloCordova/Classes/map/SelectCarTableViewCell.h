//
//  SelectCarTableViewCell.h
//  HelloCordova
//
//  Created by ywen on 15/10/3.
//
//

#import <UIKit/UIKit.h>
#import "InfoView.h"
#import "FromToView.h"

#define SELECT_CAR_CELL @"select_car_cell"

@interface SelectCarTableViewCell : UITableViewCell
{
    InfoView *_infoView;
    FromToView *_fromToView;
}

@property (strong, nonatomic) NSArray *infoList;
@property (strong, nonatomic) NSArray *addressList;

@end
