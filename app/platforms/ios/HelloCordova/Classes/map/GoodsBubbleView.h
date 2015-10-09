//
//  GoodsBubbleView.h
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import "XeBubbleView.h"
#import "FromToView.h"
#import "InfoView.h"

@interface GoodsBubbleView : XeBubbleView
{
    UIImageView *_avatar;
    UILabel *_nameLabel;
    NSMutableArray *_starList;
    FromToView *_fromToView;
    InfoView *_infoView;
}


@end
