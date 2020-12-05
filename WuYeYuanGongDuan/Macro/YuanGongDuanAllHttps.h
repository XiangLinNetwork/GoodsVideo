//
//  YuanGongDuanAllHttps.h
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/7/17.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YuanGongDuanAllHttps : NSObject

/*
 发送手机验证码
 
 */
/// 发送手机验证码
+ (void)requesSendPhoneCodeData:(UIView *)view
                          phone:(NSString *)phone
                       Callback:(completeCallback)callback;


@end

NS_ASSUME_NONNULL_END
