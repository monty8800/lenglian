//
//  PersonalCarAuthViewController.h
//  HelloCordova
//
//  Created by ywen on 15/9/23.
//
//

#import "BaseViewController.h"
#import "ImagePicker.h"

@interface PersonalCarAuthViewController : BaseViewController <ImagePickerDelegate>
{
    ImagePicker *_imagePikcer;
}

@end
