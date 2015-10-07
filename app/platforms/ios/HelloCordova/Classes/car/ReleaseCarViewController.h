//
//  ReleaseCarViewController.h
//  HelloCordova
//
//  Created by YYQ on 15/10/2.
//
//

#import "BaseViewController.h"
#import "DatePicker.h"
#import "ContactsViewController.h"

@interface ReleaseCarViewController : BaseViewController<DatePickerDelegate, SelectContactDelegate>
{
    DatePicker *_datePicker;
}

@end
