//
//  WYTools.m
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/6/24.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "WYTools.h"
#import "BDKNotifyHUD.h"

@implementation WYTools
-(void)setBaseUploadUrl:(NSString *)baseUploadUrl
{
    _baseUploadUrl = baseUploadUrl;
    [[NSUserDefaults standardUserDefaults] setObject:baseUploadUrl forKey:@"userbaseUploadUrl"];
}
-(void)setToken:(NSString *)token
{
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"usertoken"];
}
-(void)setName:(NSString *)name
{
    _name = name;
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"username"];
}
-(void)setPhone:(NSString *)phone
{
    _phone = phone;
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"userphone"];
}
-(void)setHeadPortrait:(NSString *)headPortrait
{
    _headPortrait = headPortrait;
    [[NSUserDefaults standardUserDefaults] setObject:headPortrait forKey:@"usertheadPortrait"];
}

-(void)setHousResourcesId:(NSString *)housResourcesId
{
    _housResourcesId = housResourcesId;
    [[NSUserDefaults standardUserDefaults] setObject:housResourcesId forKey:@"userhousResourcesId"];
}

-(void)setResourceName:(NSString *)resourceName
{
    _resourceName = resourceName;
    
    [[NSUserDefaults standardUserDefaults] setObject:resourceName forKey:@"userresourceName"];
}

///退出登录
-(void)loginOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"usertoken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userphone"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"usertheadPortrait"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userhousResourcesId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userresourceName"];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"yugdIsLogin"];
}

+(NSString *)getToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"usertoken"];
}
///
+(NSString *)getName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
}
///
+(NSString *)getPhone
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userphone"];
}
///
+(NSString *)getHeadPortrait
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"usertheadPortrait"];
}
////小区ID
+(NSString *)getHousResourcesId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userhousResourcesId"];
}
//////小区名
+(NSString *)getResourceName
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userresourceName"];
}
///图片前缀
+(NSString *)getBaseUploadUrl
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userbaseUploadUrl"];
}
//lb计算文本的宽和高
+(CGSize)countTextSize:(CGSize)size andtextfont:(UIFont *)font andtext:(NSString *)str
{
    CGSize detailsLabSize = size;
    NSDictionary *detailsLabAttribute = @{NSFontAttributeName: font};
    //ios7方法，获取文本需要的size
    CGSize  msize =[str boundingRectWithSize:detailsLabSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:detailsLabAttribute context:nil].size;
    return msize;
}

+(id)initDicValue:(NSDictionary *)value andclassname:(NSString *)classname
{
    id model = [NSClassFromString(classname) new];
    [model mj_setKeyValues:value];
    
    return model;
}
///数组形数据
+(NSMutableArray *)initArrValue:(NSArray *)value andclassname:(NSString *)classname
{
    NSMutableArray *arrtemp = [NSMutableArray new];
    for(NSDictionary *dic in value)
    {
        id model = [NSClassFromString(classname) new];
        [model mj_setKeyValues:dic];
        [arrtemp addObject:model];
    }
    
    return arrtemp;
}

+(void)showNotifyHUDwithtext:(NSString *)notify_str inView:(UIView *)view{
    if (notify_str) {
        BDKNotifyHUD *noti=[BDKNotifyHUD notifyHUDWithImage:nil text:notify_str];
        noti.center = CGPointMake(view.center.x, view.center.y );
        [view addSubview:noti];
        [noti presentWithDuration:1.0 speed:0.5 inView:view completion:^{
            [noti removeFromSuperview];
        }];
    }
}

///获取当前时间字符串
+(NSString *)dateChangeStringWith:(NSDate *)date format:(NSString *)format
{
    // 初始化时间格式控制器
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];

    // 设置设计格式    [matter setDateFormat:@"yyyy-MM-dd hh:mm:ss zzz"];
    if(format==nil)
    {
        [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    else
    {
        [matter setDateFormat:format];
    }
    
    // 进行转换
    NSString *dateStr = [matter stringFromDate:date];
    return dateStr;
}

///时间字符串转换成date
+(NSDate *)dateStringChangeToDateWith:(NSString *)time format:(NSString *)format
{
    NSString *birthdayStr=time;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [dateFormatter setTimeZone:timeZone];
    NSDate *birthdayDate = [dateFormatter dateFromString:birthdayStr];
    
    return birthdayDate;;
}

+ (NSInteger)compareDate:(NSString*)startTime withDate:(NSString*)endTime type:(NSString *)type {
    
    NSInteger size;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:type];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:startTime];
    dtb = [dateformater dateFromString:endTime];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedSame)
    {
        //  相等
        size = 0;
    }else if (result == NSOrderedAscending)
    {
        //endTime比startTime大
        size = 1;
    }else {
        //endTime比startTime小
        size = -1;
    }
    return size;
}

@end
