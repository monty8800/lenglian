//
//  LocationBubbleView.h
//  HelloCordova
//
//  Created by ywen on 15/10/4.
//
//

#import <UIKit/UIKit.h>

@interface LocationBubbleView : UIView
{
    UILabel *_addressLabel;
    UILabel *_streetLabel;
}

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *street;

@end
