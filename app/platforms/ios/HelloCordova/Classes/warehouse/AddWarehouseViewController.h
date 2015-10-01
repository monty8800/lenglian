//
//  AddWarehouseViewController.h
//  HelloCordova
//
//  Created by YYQ on 15/9/26.
//
//

#import "BaseViewController.h"
#import "ImagePicker.h"
@interface AddWarehouseViewController : BaseViewController <ImagePickerDelegate>
{
    ImagePicker *_imagePikcer;
}

@end
