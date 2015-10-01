//
//  AddGoodsViewController.h
//  HelloCordova
//
//  Created by ywen on 15/9/26.
//
//

#import "BaseViewController.h"
#import "ImagePicker.h"
#import "DatePicker.h"
#import "ContactsViewController.h"
#import "ContactsViewController.h"

@interface AddGoodsViewController : BaseViewController <ImagePickerDelegate, DatePickerDelegate, SelectContactDelegate>
{
    ImagePicker *_imagePicker;
    DatePicker *_datePicker;
}

@end
