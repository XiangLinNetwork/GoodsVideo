//
//  WkWebviewViewController.h
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/6/29.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WkWebviewViewController : RootViewController

///链接地址
@property (nonatomic,strong) NSString *strurl;
///内容 
@property (nonatomic,strong) NSString *strcontnt;

@end

NS_ASSUME_NONNULL_END
