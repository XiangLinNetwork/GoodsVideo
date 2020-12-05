
//
//  YuanGongDuanAllHttps.m
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/7/07.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "YuanGongDuanAllHttps.h"

@implementation YuanGongDuanAllHttps

/// 发送手机验证码
+ (void)requesSendPhoneCodeData:(UIView *)view
                          phone:(NSString *)phone
                       Callback:(completeCallback)callback
{
    NSMutableDictionary *dicpush = [NSMutableDictionary new];
    [dicpush setObject:[NSString nullToString:phone] forKey:@"phone"];
    [HTTPManager sendRequestUrlToService:@"" withParametersDictionry:dicpush view:view completeHandle:^(NSURLSessionTask *opration, id responceObjct, NSError *error) {
        BOOL state = NO;
        NSString *describle = @"";
        if (responceObjct==nil) {
            describle = @"网络错误";
        }else{
            NSString *str=[[NSString alloc]initWithData:responceObjct encoding:NSUTF8StringEncoding];
            NSDictionary *dicAll=[str JSONValue];
            describle = dicAll[@"msg"];
            if ([[NSString nullToString:dicAll[@"code"]] intValue] == 0) {
                state = YES;
            }
            else
            {
                state = NO;
            }
            if(state==YES)
            {
                callback(error,state,describle,nil);
            }
        }
        if(state==NO)
        {
            callback(error,state,describle,nil);
        }
    }];
    
}

@end
