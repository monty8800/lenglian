//
//  InfoTableViewCell.h
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import <UIKit/UIKit.h>

@interface InfoTableViewCell : UITableViewCell
{
    UILabel *_infoLabel;
}

@property (strong, nonatomic) NSString *infoText;

@end
