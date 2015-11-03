//
//  SearchGoodsDetailViewController.h
//  HelloCordova
//
//  Created by YYQ on 15/10/11.
//
//

#import "BaseViewController.h"
#import "SelectGoodsWidget.h"
#import "CarbidGoodsViewController.h"
#import "Net.h"

@interface SearchGoodsDetailViewController : BaseViewController<SelectGoodsDelegate>
{
    BOOL _bid;
}

@end
