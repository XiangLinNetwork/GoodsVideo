//
//  WYCamaImageTools.h
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/6/28.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN

/**
 类型
 */
typedef enum : NSUInteger {
    ChooseTypeTakePic,//**拍照 */
    ChooseTypeAlbum,//**从相册 */
} ChooseType;




@protocol WYCamaImageToolsDelegate <NSObject>

- (void)didEndChoosePic:(UIImage *)image;

@end

@interface WYCamaImageTools : NSObject

@property (nonatomic, weak) id<WYCamaImageToolsDelegate>delegate;

- (void)choosePicWithViewController:(UIViewController *)viewController chooseType:(ChooseType)chooseType;


@end

NS_ASSUME_NONNULL_END
