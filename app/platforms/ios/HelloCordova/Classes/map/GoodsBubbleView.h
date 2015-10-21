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
#import "StarView.h"

@interface GoodsBubbleView : XeBubbleView
{
    UIImageView *_avatar;
    UILabel *_nameLabel;
    FromToView *_fromToView;
    InfoView *_infoView;
    StarView *_starView;
}


@end
