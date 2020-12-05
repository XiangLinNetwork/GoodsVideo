//
//  GETCorelLocation.h
//  PetPlanet
//  ios 自带获取位置
//  Created by 彭光见 on 14/12/25.
//  Copyright (c) 2014年 com.xw.cwxq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol GETLOCGTION <NSObject>
///当前位置经纬度
-(void)getlocation:(CLLocation *)loca;
///当前位置名称
-(void)getlocationInfo:(NSString *)locainfo;

@end

@interface GETCorelLocation : NSObject<CLLocationManagerDelegate>

    
@property (nonatomic , strong) CLLocationManager *location;

@property (nonatomic , strong) id <GETLOCGTION> degelate;

+(id)initview;

@end
