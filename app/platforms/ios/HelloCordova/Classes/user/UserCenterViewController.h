//
//  UserCenterViewController.h
//  HelloCordova
//
//  Created by ywen on 15/9/21.
//
//

#import "BaseViewController.h"
#import "ImagePicker.h"

@interface UserCenterViewController : BaseViewController<ImagePickerDelegate>
{
    UIImage *_navBg;
    UIImage *_navBgBlue;
    
    ImagePicker *_imagePicker;
}

@end
