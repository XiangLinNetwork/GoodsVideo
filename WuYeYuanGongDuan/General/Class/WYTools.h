//
//  WYTools.h
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/6/24.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYTools : NSObject
///图片前缀
@property (nonatomic , strong) NSString *baseUploadUrl;
///token
@property (nonatomic , strong) NSString *token;
///姓名
@property (nonatomic , strong) NSString *name;
///手机号
@property (nonatomic , strong) NSString *phone;
///头像
@property (nonatomic , strong) NSString *headPortrait;
///小区ID
@property (nonatomic , strong) NSString *housResourcesId;
///小区名
@property (nonatomic , strong) NSString *resourceName;

///退出登录
-(void)loginOut;

///
+(NSString *)getToken;
///
+(NSString *)getName;
///
+(NSString *)getPhone;
///
+(NSString *)getHeadPortrait;
////小区ID
+(NSString *)getHousResourcesId;
//////小区名
+(NSString *)getResourceName;
///图片前缀
+(NSString *)getBaseUploadUrl;

//lb计算文本的宽和高
+(CGSize)countTextSize:(CGSize)size andtextfont:(UIFont *)font andtext:(NSString *)str;



///数据处理 将字典转换成model
+(id)initDicValue:(NSDictionary *)value andclassname:(NSString *)classname;
///数组形数据 数组转换成model
+(NSMutableArray *)initArrValue:(NSArray *)value andclassname:(NSString *)classname;

///提示框
+(void)showNotifyHUDwithtext:(NSString *)notify_str inView:(UIView *)view;

///获取当前时间字符串
+(NSString *)dateChangeStringWith:(NSDate *)date format:(NSString *)format;


///时间字符串转换成date
+(NSDate *)dateStringChangeToDateWith:(NSString *)time format:(NSString *)format;

///比较连个日期大小 1:结束时间大于开始时间 -1相反
+ (NSInteger)compareDate:(NSString*)startTime withDate:(NSString*)endTime type:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
