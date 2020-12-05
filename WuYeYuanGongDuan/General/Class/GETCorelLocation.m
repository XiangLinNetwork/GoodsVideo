//
//  GETCorelLocation.m
//  PetPlanet
//
//  Created by 彭光见 on 14/12/25.
//  Copyright (c) 2014年 com.xw.cwxq. All rights reserved.
//

#import "GETCorelLocation.h"
#import "AppDelegate.h"
#import "YQLocationTransform.h"
static GETCorelLocation *getloca;

@implementation GETCorelLocation

+(id)initview
{
    if(getloca == nil)
    {
        getloca = [[GETCorelLocation alloc]init];
    }
    
    [getloca inits];
    
    return getloca;
}
-(void)inits
{
    [UIApplication sharedApplication].idleTimerDisabled = TRUE;
    self.location = [[CLLocationManager alloc]init];
    [self.location setDistanceFilter:100];
    [self.location setDesiredAccuracy:kCLLocationAccuracyBest];
    [self.location requestAlwaysAuthorization];
    [self.location setDelegate:self];
    [self.location startUpdatingLocation];
    
    
}


#pragma mark - CLLocationManager degelate
- (void)locationManager:(CLLocationManager *)manager
didUpdateToLocation:(CLLocation *)newLocation
       fromLocation:(CLLocation *)oldLocation
{
    CLLocation *location = newLocation;
    YQLocationTransform *beforeLocation = [[YQLocationTransform alloc] initWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
    //百度转化为GPS
    YQLocationTransform *afterLocation = [beforeLocation transformFromGPSToGD];
    CLLocation *locationafter = [[CLLocation alloc] initWithLatitude:afterLocation.latitude longitude:afterLocation.longitude];
    [self.degelate getlocation:locationafter];
    [manager stopUpdatingLocation];
    
    CLGeocoder *cLGeocoder = [[CLGeocoder alloc] init];
    [cLGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *place = [placemarks objectAtIndex:0];
        NSString *strtemp = place.subThoroughfare;
        if(strtemp.length==0)
        {
            strtemp = place.name;
        }
        [self.degelate getlocationInfo:strtemp];
        
    }];
    
}
- (void)locationManager:(CLLocationManager *)manager
didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if(locations.count>0)
    {
        CLLocation *location = locations.firstObject;
        YQLocationTransform *beforeLocation = [[YQLocationTransform alloc] initWithLatitude:location.coordinate.latitude andLongitude:location.coordinate.longitude];
        //百度转化为GPS
        YQLocationTransform *afterLocation = [beforeLocation transformFromGPSToGD];
        CLLocation *locationafter = [[CLLocation alloc] initWithLatitude:afterLocation.latitude longitude:afterLocation.longitude];
        [self.degelate getlocation:locationafter];
        [manager stopUpdatingLocation];
        
        CLGeocoder *cLGeocoder = [[CLGeocoder alloc] init];
        [cLGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *place = [placemarks objectAtIndex:0];
            NSString *strtemp = place.subThoroughfare;
            if(strtemp.length==0)
            {
                strtemp = place.name;
            }
            [self.degelate getlocationInfo:strtemp];
            
        }];
        
    }
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    NSString *errorString;
    CLLocation *location = [[CLLocation alloc]initWithLatitude:0.0 longitude:0.0];
    [self.degelate getlocation:location];
    switch([error code]) {
        case kCLErrorDenied:
            //Access denied by user
            errorString = @"无法获取你的位置信息！请到设置中开启定位功能！";
            
            
            //Do something...
            break;
        case kCLErrorLocationUnknown:
            //Probably temporary...
            errorString = @"位置信息不可用！请到设置中开启定位功能！";
            //Do something else...
            break;
        default:
            errorString = @"定位出现错误！请到设置中开启定位功能！";
            break;
    }


    AppDelegate *appdel = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [WYTools showNotifyHUDwithtext:errorString inView:appdel.window];
}


@end
