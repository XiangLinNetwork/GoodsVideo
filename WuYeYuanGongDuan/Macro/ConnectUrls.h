//
//  ConnectUrls.h
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/6/24.
//  Copyright © 2020 Mac. All rights reserved.
//

typedef void(^completeCallback)(NSError *error, BOOL state, NSString *describle, id value);
static UIEdgeInsets kPaddingNav = {64,0,0,0};
///api
#define URL_HR @"https://yxpay.cloudjoytech.com:50081"
//#define URL_HR @"http://192.168.1.19:8085"

///发送手机验证码
#define SendVerifySMSHttpUrl [NSString stringWithFormat:@"%@/common/sendVerifySMS",URL_HR]


#ifndef ConnectUrls_h
#define ConnectUrls_h


#endif /* ConnectUrls_h */
