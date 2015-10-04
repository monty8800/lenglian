//
//  SelectGoodsTableViewCell.h
//  HelloCordova
//
//  Created by ywen on 15/10/4.
//
//

#import <UIKit/UIKit.h>

#import "InfoView.h"

#define SELECT_GOODS_CELL @"select_goods_cell"

@interface SelectGoodsTableViewCell : UITableViewCell
{
    InfoView *_infoView;
}

@property (strong, nonatomic) NSArray *infoList;

@end
