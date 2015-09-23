//
//  ImagePicker.h
//  HelloCordova
//
//  Created by ywen on 15/9/23.
//
//

#import <Foundation/Foundation.h>

@protocol ImagePickerDelegate <NSObject>

@required
-(void) selectImage:(NSString *) imagePath type: (NSString *) type;

@end

@interface ImagePicker : NSObject <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSString *_name;
    __weak UIViewController *_vc;
}

@property (weak, nonatomic) id<ImagePickerDelegate> delegate;

-(void) show:(NSString *) name vc:(UIViewController *) vc;

@end
