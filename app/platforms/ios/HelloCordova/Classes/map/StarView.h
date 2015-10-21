//
//  StarView.h
//  HelloCordova
//
//  Created by ywen on 15/10/21.
//
//

#import <UIKit/UIKit.h>

@interface StarView : UIView
{
    UIImage *_fullStar;
    UIImage *_halfStar;
    UIImage *_emptyStar;
}

@property (assign, nonatomic) NSInteger score;

@end
