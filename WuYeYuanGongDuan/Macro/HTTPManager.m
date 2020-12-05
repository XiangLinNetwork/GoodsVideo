//
//  HTTPManager.m
//  mdb
//
//  Created by 杜非 on 14/12/10.
//  Copyright (c) 2014年 meidebi. All rights reserved.
//

#import "HTTPManager.h"
#import <AFNetworking/AFNetworking.h>
#import "GMDCircleLoader.h"
#import "NSString+extend.h"

#import <sys/utsname.h>


@interface HTTPManager ()
@property (nonatomic, copy) NSURL * baseAPI_URL;
@property (nonatomic, copy) NSURL * download_URL;
//@property (nonatomic, strong) AFHTTPRequestOperationManager * manager;
@property (nonatomic, strong) AFHTTPSessionManager * manager;
@end


static BOOL kIsRightInit = NO;

@implementation HTTPManager


+ (HTTPManager *)shardInstance{
    static dispatch_once_t onceToken;
    static HTTPManager * singleton = nil;
    kIsRightInit = YES;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    kIsRightInit = NO;
    if (singleton) {
        [singleton initSomthing];
    }
    
    
    return singleton;
}
- (instancetype)init {
    NSAssert(kIsRightInit, @"请不要直接使用\"-init\"初始化");
    self = [super init];
    return self;
}
- (void)initSomthing{
    if (!_manager) {
        self.manager = [AFHTTPSessionManager manager];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        // 设置可以接收无效的证书
        [securityPolicy setAllowInvalidCertificates:YES];
        securityPolicy.validatesDomainName = NO;
        _manager.securityPolicy = securityPolicy;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    }
}

+ (NSURLSessionTask *)sendHtmlRequestUrlToService:(NSString *)url
                                        completeHandler:(void(^)(NSURLSessionTask * opration, id responceObjct, NSError * error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSURLSessionTask * op = [manager GET:url parameters:nil headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (complete) {
            complete(task,responseObject,nil);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (complete) {
            complete(task,nil,error);
        }
    }];
    [op resume];
    return op;
    
}

+ (NSURLSessionTask *)sendRequestUrlToService:(NSString *)url
                            withParametersDictionry:(NSDictionary *)parameters
                                               view:(UIView *)showView
                                     completeHandle:
(void(^)(NSURLSessionTask * opration, id responceObjct, NSError * error))complete{
    

    return [[HTTPManager shardInstance] sendRequestUrlToService:url withParametersDictionry:parameters view:showView completeHandle:complete];
}

+ (NSURLSessionTask *)sendGETRequestUrlToService:(NSString *)url
                            withParametersDictionry:(NSDictionary *)parameters
                                               view:(UIView *)showView
                                     completeHandle:
(void(^)(NSURLSessionTask * opration, id responceObjct, NSError * error))complete{
    

    return [[HTTPManager shardInstance] sendGETRequestUrlToService:url withParametersDictionry:parameters view:showView completeHandle:complete];
    
}


- (NSURLSessionTask *)sendRequestUrlToService:(NSString *)url
                                     withParametersDictionry:(NSDictionary *)parameters
                                               view:(UIView *)showView
                                          completeHandle:
(void (^)(NSURLSessionTask *, id, NSError *))complete {
  
    if (showView) {
        [GMDCircleLoader setOnView:showView withTitle:nil animated:YES];
    }
    _manager.requestSerializer.timeoutInterval=40.0;
    
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:parameters];
    
    NSDictionary *dicsss=[NSDictionary dictionaryWithDictionary:dic];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicsss options:kNilOptions error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    //设置超时时长
    request.timeoutInterval= 30;
    //设置上传数据type
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *tokenString = [WYTools getToken] ;
    if (tokenString.length > 0) {
        [request setValue:[NSString stringWithFormat:@"%@" , tokenString] forHTTPHeaderField:@"token"];
    }
    
    
    
    NSURLSessionTask * op = [_manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [GMDCircleLoader hideFromView:showView animated:YES];
        if(error==nil)
        {
            if (complete && responseObject) {
                responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
                NSDictionary *dicAll;
                NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                dicAll=[str JSONValue];
                NSLog(@"%@",dicAll);
                if ([[dicAll objectForKey:@"code"]intValue] == -1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetworkWairningOnload" object:nil];
                }else{
                    complete(nil,responseObject,nil);
                }
            }
        }
        else
        {
            complete(nil,nil,error);
        }
        
    }];
    [op resume];
    return op;
}

- (NSURLSessionTask *)sendGETRequestUrlToService:(NSString *)url
                               withParametersDictionry:(NSDictionary *)parameters
                                                  view:(UIView *)showView
                                        completeHandle:
(void (^)(NSURLSessionTask *, id, NSError *))complete {
    
    if (showView) {
        [GMDCircleLoader setOnView:showView withTitle:nil animated:YES];
    }
    _manager.requestSerializer.timeoutInterval=40.0;
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:parameters];
    
    NSDictionary *dicsss=[NSDictionary dictionaryWithDictionary:dic];
    NSURLSessionTask * op = [_manager GET:url parameters:dicsss headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GMDCircleLoader hideFromView:showView animated:YES];
        if (complete && responseObject) {
            NSDictionary *dicAll;
            responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"code"]intValue] == -1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetworkWairningOnload" object:nil];
            }else{
                complete(task,responseObject,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GMDCircleLoader hideFromView:showView animated:YES];
        if (complete) {
            complete(task,nil,error);
        }
    }];
    [op resume];
    return op;
}

///上传图片
+ (void)sendRequestImageUrlToService:(NSString *)url
                                     withParametersDictionry:(NSDictionary *)parameters
                                            imagearr:(NSMutableArray *)dataArray
                                               view:(UIView *)showView
                                          completeHandle:
(void(^)(NSURLSessionTask * opration, id responceObjct, NSError * error))complete
{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
//        //批量拼装数据
//        for (HXUploadDataModel *uploadDataModel in dataArray) {
//            [formData appendPartWithFileData:uploadDataModel.data name:uploadDataModel.name fileName:uploadDataModel.fileName mimeType:uploadDataModel.mimeType];
//        }
        
    } error:nil];
    
    NSString *tokenString = [WYTools getToken] ;
    if (tokenString.length > 0) {
        [request setValue:[NSString stringWithFormat:@"%@" , tokenString] forHTTPHeaderField:@"token"];
    }
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSURLSessionUploadTask *uploadTask = [manager
                                          uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
                                              
                                              
                                          } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                              
                                              if (error) {
                                                  
                                                  NSLog(@"上传失败:%@",[error localizedDescription]);
                                                  complete(nil,responseObject,error);
                                              } else {
                                                  
                                                  complete(nil,responseObject,nil);
                                              }
                                              
                                          }];
    
    [uploadTask resume];
    
}






////无默认参数
+ (NSURLSessionTask *)sendGETRequestNotNomoUrlToService:(NSString *)url
                                withParametersDictionry:(NSDictionary *)parameters
                                                   view:(UIView *)showView
                                         completeHandle:
(void(^)(NSURLSessionTask * opration, id responceObjct, NSError * error))complete
{
    
    return [[HTTPManager shardInstance] sendGETRequestNotNomoUrlToService:url withParametersDictionry:parameters view:showView completeHandle:complete];
}
- (NSURLSessionTask *)sendGETRequestNotNomoUrlToService:(NSString *)url
                         withParametersDictionry:(NSDictionary *)parameters
                                            view:(UIView *)showView
                                  completeHandle:
(void (^)(NSURLSessionTask *, id, NSError *))complete
{
    if (showView) {
        [GMDCircleLoader setOnView:showView withTitle:nil animated:YES];
    }
    _manager.requestSerializer.timeoutInterval=40.0;
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:parameters];
    
    NSDictionary *dicsss=[NSDictionary dictionaryWithDictionary:dic];
    NSURLSessionTask * op = [_manager GET:url parameters:dicsss headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [GMDCircleLoader hideFromView:showView animated:YES];
        if (complete && responseObject) {
            NSDictionary *dicAll;
            responseObject = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            dicAll=[str JSONValue];
            
            if ([[dicAll objectForKey:@"status"]intValue] == -1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNetworkWairningOnload" object:nil];
            }else{
                complete(task,responseObject,nil);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [GMDCircleLoader hideFromView:showView animated:YES];
        if (complete) {
            complete(task,nil,error);
        }
    }];

    [op resume];
    return op;
}

+ (void)sendRequestUrlToService:(NSString *)url
                            withParametersDictionry:(NSDictionary *)parameters
                                           fileDate:(NSData *)data
                                               name:(NSString *)name
                                           filename:(NSString *)filename
                                           mimeType:(NSString *)mimeType
                                     completeHandle:(void (^)(NSURLSessionTask *, id, NSError *))complete{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:parameters];
    [dic setObject:@"1" forKey:@"devicetype"];
    [dic setObject:[[HTTPManager shardInstance] iphoneType] forKey:@"devicename"];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:name fileName:filename mimeType:mimeType];
    } error:nil];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            complete(nil,nil,error);
        } else {
            complete(nil,responseObject,nil);
        }
    }];
    
    [uploadTask resume];
}
#pragma mark - AFNetworking
- (NSURLSessionTask *)actionRequestUrlToService:(NSString *)url actionwithParametersDictionry:(NSDictionary *)parameters
{
    
    _manager.responseSerializer=[AFJSONResponseSerializer serializer];//返回json类型
    _manager.requestSerializer.timeoutInterval=40.0;
    NSURLSessionTask * op = [_manager POST:url parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    return op;
}


- (NSString*)iphoneType {
    
    //需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone11,2"]) return@"iPhone XS";
    
    if([platform isEqualToString:@"iPhone11,4"]) return@"iPhone XS Max";
    
    if([platform isEqualToString:@"iPhone11,6"]) return@"iPhone XS Max";
    
    if([platform isEqualToString:@"iPhone11,8"]) return@"iPhone XR";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
    
}

@end
