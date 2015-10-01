//
//  BaseAuthViewController.h
//  HelloCordova
//
//  Created by ywen on 15/9/24.
//
//

#import "BaseViewController.h"
#import "ImagePicker.h"
#import "Net.h"

@interface BaseAuthViewController : BaseViewController <ImagePickerDelegate>
{
    ImagePicker *_imagePikcer;
}

@end
