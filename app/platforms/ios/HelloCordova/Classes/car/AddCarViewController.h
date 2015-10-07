//
//  AddCarViewController.h
//  HelloCordova
//
//  Created by YYQ on 15/10/1.
//
//

#import "BaseViewController.h"
#import "ImagePicker.h"

@interface AddCarViewController : BaseViewController<ImagePickerDelegate>
{
    ImagePicker *_imagePicker;
}

@end
