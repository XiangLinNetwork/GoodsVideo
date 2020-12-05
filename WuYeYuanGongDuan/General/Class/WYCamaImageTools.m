//
//  WYCamaImageTools.m
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/6/28.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "WYCamaImageTools.h"
#import <AVFoundation/AVFoundation.h>



@interface WYCamaImageTools () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation WYCamaImageTools

- (void)choosePicWithViewController:(UIViewController *)viewController chooseType:(ChooseType)chooseType{
    
    NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // appName
    NSString *appName = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *message;
    NSString *mediType = AVMediaTypeVideo;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediType];
    
    if (authStatus == AVAuthorizationStatusDenied) {
        
        if (chooseType == ChooseTypeTakePic) {
            
            message = [NSString stringWithFormat:@"%@%@",appName,@"不能访问相机\n请在设置中开启相机功能!"];
            
        }else if(chooseType == ChooseTypeAlbum){
            
            message = [NSString stringWithFormat:@"%@%@",appName,@"不能访问相册\n请在设置中开启相册功能!"];
            
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@%@",appName,@"不能访问相机\n请在设置中开启相机功能!"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [viewController presentViewController:alert animated:YES completion:nil];
        
        
        return;
    }
    
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        switch (chooseType) {
            case ChooseTypeTakePic: //相机
            {
                sourceType = UIImagePickerControllerSourceTypeCamera;
            }
                
                break;
            case ChooseTypeAlbum: //相册{
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
                
                break;
                
        }
        
    }else {
        
        sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = sourceType;
    
    [viewController presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark imagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    NSLog(@"111111111111222222");
    picker.title = @"取消";
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if ([self.delegate respondsToSelector:@selector(didEndChoosePic:)]) {
        [self.delegate didEndChoosePic:image];
    }
}

@end
