//
//  CarSearchGoodsViewController.h
//  HelloCordova
//
//  Created by YYQ on 15/10/5.
//
//

#import "BaseViewController.h"
#import "SelectGoodsWidget.h"

@interface CarSearchGoodsViewController : BaseViewController<SelectGoodsDelegate>
{
    BOOL _bid;
}

@end
