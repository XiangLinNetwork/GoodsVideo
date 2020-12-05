//
//  AppDelegate.m
//  WuYeYuanGongDuan
//
//  Created by Mac on 2020/6/23.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarControllerConfig.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    if (@available(iOS 13.0, *)) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
//    if([WYTools getToken].length>1)
//    {
//        TabBarControllerConfig *config = [[TabBarControllerConfig alloc] init];
//        [self.window setRootViewController:config.tabBarController];
//    }
//    else
//    {
//        LoginViewController *lvc = [[LoginViewController alloc] init];
//        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:lvc];
//        [self.window setRootViewController:nvc];
//    }
    
    
    
    ///退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutNotifi) name:@"kNetworkWairningOnload" object:nil];
    
    [[UITabBar appearance] setTranslucent:NO];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    return YES;
}
///退出登录
-(void)loginOutNotifi
{
    
}


@end
