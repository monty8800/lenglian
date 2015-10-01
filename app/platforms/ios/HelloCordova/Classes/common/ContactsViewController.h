//
//  ContactsViewController.h
//  HelloCordova
//
//  Created by ywen on 15/10/1.
//
//

#import <UIKit/UIKit.h>
#import "Contacts.h"

@protocol SelectContactDelegate <NSObject>

@required
-(void) select:(NSDictionary *) contact type:(NSString *) type;

@end

@interface ContactsViewController : UITableViewController<ContactsDelegate>
{
    NSMutableDictionary *_contactsMap;
    NSArray *_indexArray;
}
@property (strong, nonatomic) NSString *type;
@property (weak, nonatomic) id<SelectContactDelegate> delegate;

@end
