//
//  Contacts.m
//  HelloCordova
//
//  Created by ywen on 15/10/1.
//
//

#import "Contacts.h"
#import "Global.h"

@implementation Contacts

-(void)getList {
    _addressBook = ABAddressBookCreate();
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status != kABAuthorizationStatusAuthorized) {
        ABAddressBookRequestAccessWithCompletion(_addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                DDLogDebug(@"granted %d, error %@", granted, (__bridge NSError *)error);
                if (!granted || error) {
                    [[Global sharedInstance] showErr:@"获取通讯录失败！"];
                }
                else
                {
                    [self parseList];
                }
            });
        });
    }
    else
    {
        [self parseList];
    }
}

-(void) parseList {
    ABAddressBookRevert(_addressBook);
    NSArray *arr = [NSArray arrayWithArray:(__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(_addressBook)];
    NSMutableArray *result = [NSMutableArray new];
    for (int i=0; i<arr.count; i++) {
        ABRecordRef person = objc_unretainedPointer(arr[i]);
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSString *mobile = @"";
        for (int j=0; j<ABMultiValueGetCount(phones); j++) {
            NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j));
            if (phone.length >= 11) {
                mobile = phone;
                break;
            }
        }
        NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
        if (name != nil) {
            [result addObject:@{
                                @"name": name,
                                @"mobile": mobile
                                }];
        }

    }
    [self.delegate getContactsList:result];
}

@end
