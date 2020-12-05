//
//  NSDate+compare.m
//  Meidebi
//
//  Created by mdb-admin on 2017/1/9.
//  Copyright © 2017年 meidebi. All rights reserved.
//

#import "NSDate+compare.h"
@implementation NSDate (compare)

/**
 * @brief 判断当前时间是否在fromHour和toHour之间。如，fromHour=8，toHour=23时，即为判断当前时间是否在8:00-23:00之间
 */
- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *date8 = [self getCustomDateWithHour:8];
    NSDate *date23 = [self getCustomDateWithHour:23];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %ld:00-%ld:00 之间！", (long)fromHour, (long)toHour);
        return YES;
    }
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}

+ (BOOL)checkDateWithEndDate:(NSString *)endDateStr {
    /**
     NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:beginDate];
     NSInteger days = timeInterval/(3600*24);
     NSLog(@"----days:----%ld",days);
     **/
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSDate *endDate = [dateFormatter dateFromString:endDateStr];
    //截止日期大于当天日期
    if ([endDate compare:currentDate] != NSOrderedAscending) {
        return YES;
    }
    
//    //起始日期大于截止日期
//    if ([beginDate compare:endDate] == NSOrderedDescending) {
//        return -2;
//    }
//    
//    //起始日期与截止日期间隔不能大于3个月
//    if ([[beginDate dateByAddingTimeInterval:3*30*24*60*60] compare:endDate] == NSOrderedDescending) {
//        return 1;
//    }
//    //起始日期与截止日期间隔大于3个月
    return NO;
}

@end
