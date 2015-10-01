//
//  Contacts.h
//  HelloCordova
//
//  Created by ywen on 15/10/1.
//
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@protocol ContactsDelegate <NSObject>

@required
-(void) getContactsList:(NSArray *) contactsList;

@end

@interface Contacts : NSObject
{
    ABAddressBookRef _addressBook;
}
@property (weak, nonatomic) id<ContactsDelegate> delegate;

-(void) getList;


@end
