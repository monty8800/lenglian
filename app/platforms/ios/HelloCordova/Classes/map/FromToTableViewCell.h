//
//  FromToTableViewCell.h
//  HelloCordova
//
//  Created by ywen on 15/10/2.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FROM,
    TO,
    PASSBY,
} AddressType;

@interface FromToTableViewCell : UITableViewCell
{
    UIImageView *_iconView;
    UILabel *_addressLabel;
    
    UIImage *_imageFrom;
    UIImage *_imageTo;
    UIImage *_imagePassby;
}

@property (strong, nonatomic) NSDictionary *addressDic;
@property (assign, nonatomic) AddressType type;

@end
