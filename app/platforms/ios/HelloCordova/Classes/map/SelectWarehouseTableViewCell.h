//
//  SelectWarehouseTableViewCell.h
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import <UIKit/UIKit.h>
#import "InfoView.h"
#import "FromToView.h"



@interface SelectWarehouseTableViewCell : UITableViewCell
{
    InfoView *_infoView;
    FromToView *_fromToView;
}

@property (strong, nonatomic) NSArray *infoList;

@end
