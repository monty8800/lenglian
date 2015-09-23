//
//  ImagePicker.m
//  HelloCordova
//
//  Created by ywen on 15/9/23.
//
//

#import "ImagePicker.h"
#import "Global.h"

@implementation ImagePicker

-(void)show:(NSString *)name vc:(UIViewController *)vc {
    _name = name;
    _vc = vc;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [actionSheet showFromTabBar:[Global sharedInstance].tabVC.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    DDLogDebug(@"click %@", @(buttonIndex));
    if (buttonIndex == 2) {
        return;
    }
    
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    pickVC.sourceType = buttonIndex == 0 ? UIImagePickerControllerSourceTypePhotoLibrary : UIImagePickerControllerSourceTypeCamera;
    pickVC.delegate = self;
    pickVC.allowsEditing = YES;
    [_vc presentViewController:pickVC animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *data;
    NSString *type;
    if (UIImagePNGRepresentation(img) == nil) {
        data = UIImageJPEGRepresentation(img, 0.3);
        type = @".jpg";
    }
    else
    {
        data = UIImagePNGRepresentation(img);
        type = @".png";
    }
    NSString *path = [[AUTH_PIC_FOLDER stringByAppendingPathComponent:_name] stringByAppendingString:type];
    [data writeToFile:path atomically:YES];
    [self.delegate selectImage:path type:_name];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
