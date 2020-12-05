//
//  TabBarControllerConfig.m
//  Meidebi
//
//  Created by mdb-admin on 16/7/25.
//  Copyright © 2016年 meidebi. All rights reserved.
//

#import "TabBarControllerConfig.h"

@import Foundation;
@import UIKit;
@interface BaseNavigationController : UINavigationController
@end
@implementation BaseNavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
    
    // 修改tabBra的frame
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}
@end

@interface TabBarControllerConfig ()
<
UITabBarControllerDelegate
>

@property (nonatomic, readwrite, strong) PGGTabBarViewControllerConfig *tabBarController;

///未读消息数量
@property (nonatomic , retain) UILabel *lbmessagenum;
@property (nonatomic , retain) NSString *strmessagenum;


@end

@implementation TabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (PGGTabBarViewControllerConfig *)tabBarController {
    if (_tabBarController == nil) {
        PGGTabBarViewControllerConfig *tabBarController = [[PGGTabBarViewControllerConfig alloc] init];
        _tabBarController = tabBarController;
//        ////未读消息处理
//        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(messageNumtimeerit) userInfo:nil repeats:NO];
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageNumAction:) name:@"tabbarnumessagenum" object:nil];
        
    }
    return _tabBarController;
}

-(void)timeerit
{
    CGRect frame = CGRectMake(0, 0, 30, 30);
    UIImageView *v = [[UIImageView alloc] initWithFrame:frame];
    UIImage *img = [UIImage imageNamed:@"hot_image_icon"];
    [v setContentMode:UIViewContentModeScaleAspectFit];
    v.image = img;
    [v setCenter:CGPointMake(kMainScreenW/2.0, 0)];
    [_tabBarController.tabBar insertSubview:v atIndex:0];
    
    _tabBarController.tabBar.opaque = YES;
    [_tabBarController.tabBar bringSubviewToFront:v];
    
}

-(void)messageNumtimeerit
{
    CGRect frame = CGRectMake(0, 0, 20, 20);
    
    _lbmessagenum = [[UILabel alloc] initWithFrame:frame];
    [_lbmessagenum.layer setMasksToBounds:YES];
    [_lbmessagenum.layer setCornerRadius:_lbmessagenum.height/2.0];
    [_lbmessagenum setBackgroundColor:[UIColor redColor]];
    [_lbmessagenum setTextColor:[UIColor whiteColor]];
    [_lbmessagenum setTextAlignment:NSTextAlignmentCenter];
    [_lbmessagenum setFont:[UIFont systemFontOfSize:10]];
    
    [_lbmessagenum setCenter:CGPointMake(kMainScreenW-20, 15)];
//    NSString *strtemp = [[NSUserDefaults standardUserDefaults] objectForKey:@"weiduxiaoxinumpgg"];
//    if(strtemp.integerValue>0)
//    {
//        if([MDB_UserDefault getIsLogin] == NO)
//        {
//            [_lbmessagenum setHidden:YES];
//        }
//        else
//        {
//            if(strtemp.integerValue>99)
//            {
//                strtemp = @"99";
//            }
//            [_lbmessagenum setText:strtemp];
//            [_lbmessagenum setHidden:NO];
//        }
//
//    }
//    else
//    {
//        [_lbmessagenum setHidden:YES];
//    }
    
    [_tabBarController.tabBar insertSubview:_lbmessagenum atIndex:0];
    
    _tabBarController.tabBar.opaque = YES;
    [_tabBarController.tabBar bringSubviewToFront:_lbmessagenum];
}

-(void)messageNumAction:(NSNotification *)notifi
{
    _strmessagenum = [NSString nullToString:notifi.object];
    if(_strmessagenum.integerValue>99)
    {
        _strmessagenum = @"99";
    }
    [[NSUserDefaults standardUserDefaults] setObject:_strmessagenum forKey:@"weiduxiaoxinumpgg"];
    if(_lbmessagenum!=nil)
    {
        [_lbmessagenum setText:_strmessagenum];
    }
    if(_strmessagenum.integerValue>0)
    {
        [_lbmessagenum setHidden:NO];
    }
    else
    {
        [_lbmessagenum setHidden:YES];
    }
    
}

//- (NSArray *)viewControllers {
//
//    UIStoryboard *Oneselfboard = [UIStoryboard storyboardWithName:@"Oneself" bundle:nil];
////    UIStoryboard *Mainboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    OneUserViewController *UserViewController=[Oneselfboard instantiateViewControllerWithIdentifier:@"com.mdb.OneUserViewC"];
//
////    MainSpotViewController *mainViewController=[Mainboard instantiateViewControllerWithIdentifier:@"com.mdb.rootNavigation.ViewController"];
//
//    FindCouponIndexViewController *findCouponViewController = [[FindCouponIndexViewController alloc] init];
//    /////
//    DaiGouHomeViewController *daigouViewController = [[DaiGouHomeViewController alloc] init];
//
//    OriginalHomeViewController *ShareViewController = [[OriginalHomeViewController alloc] init];
//
//
//    HomeViewController *homeViewController = [[HomeViewController alloc] init];
//
//    UIViewController *firstNavigationController = [[BaseNavigationController alloc]
//                                                   initWithRootViewController:homeViewController];
//
//    UIViewController *secondNavigationController = [[BaseNavigationController alloc]
//                                                    initWithRootViewController:findCouponViewController];
//
//    UIViewController *thirdNavigationController = [[BaseNavigationController alloc]
//                                                   initWithRootViewController:daigouViewController];
//
//
//    UIViewController *fourthNavigationController = [[BaseNavigationController alloc]
//                                                   initWithRootViewController:ShareViewController];
//
//    UIViewController *fiveNavigationController = [[BaseNavigationController alloc]
//                                                    initWithRootViewController:UserViewController];
//
//    /**
//     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
//     * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
//     * 更推荐后一种做法。
//     */
//    //tabBarController.imageInsets = UIEdgeInsetsMake(4.5, 0, -4.5, 0);
//    //tabBarController.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
//    NSArray *viewControllers = @[
//                                 firstNavigationController,
//                                 secondNavigationController,
//                                 thirdNavigationController,
//                                 fourthNavigationController,
//                                 fiveNavigationController
//                                 ];
//    return viewControllers;
//}

//- (NSArray *)tabBarItemsAttributesForController {
//    NSDictionary *firstTabBarItemsAttributes = @{
//                                                 CYLTabBarItemTitle : @"首页",
//                                                 CYLTabBarItemImage : @"home_normal",
//                                                 CYLTabBarItemSelectedImage : @"home_select",
//                                                 };
//    NSDictionary *secondTabBarItemsAttributes = @{
//                                                  CYLTabBarItemTitle : @"搜券",
//                                                  CYLTabBarItemImage : @"findcoupon_normal",
//                                                  CYLTabBarItemSelectedImage : @"findcoupon_select",
//                                                  };
//    NSDictionary *thirdTabBarItemsAttributes = @{
//                                                 CYLTabBarItemTitle : @"代购",
//                                                 CYLTabBarItemImage : @"yijiandaigou_normal",
//                                                 CYLTabBarItemSelectedImage : @"yijiandaigou_select",
//                                                 };
//    NSDictionary *fourthTabBarItemsAttributes = @{
//                                                 CYLTabBarItemTitle : @"原创",
//                                                 CYLTabBarItemImage : @"original_normal",
//                                                 CYLTabBarItemSelectedImage : @"original_select",
//                                                 };
//    NSDictionary *fiveTabBarItemsAttributes = @{
//                                                  CYLTabBarItemTitle : @"我的",
//                                                  CYLTabBarItemImage : @"user_normal",
//                                                  CYLTabBarItemSelectedImage : @"user_select"
//                                                  };
//    NSArray *tabBarItemsAttributes = @[
//                                       firstTabBarItemsAttributes,
//                                       secondTabBarItemsAttributes,
//                                       thirdTabBarItemsAttributes,
//                                       fourthTabBarItemsAttributes,
//                                       fiveTabBarItemsAttributes
//                                       ];
//    return tabBarItemsAttributes;
//}
//
///**
// *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
// */
//- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
//    // Customize UITabBar height
//    // 自定义 TabBar 高度
//    // tabBarController.tabBarHeight = 50.f;
//
//    // set the text color for unselected state
//    // 普通状态下的文字属性
//    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
//    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
//
//    // set the text color for selected state
//    // 选中状态下的文字属性  #faa159
//    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
//    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#faa159"];
////    selectedAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
//    // set the text Attributes
//    // 设置文字属性
//    UITabBarItem *tabBar = [UITabBarItem appearance];
//    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
//    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
//
//    // Set the dark color to selected tab (the dimmed background)
//    // TabBarItem选中后的背景颜色
//    // [self customizeTabBarSelectionIndicatorImage];
//
//    // update TabBar when TabBarItem width did update
//    // If your app need support UIDeviceOrientationLandscapeLeft or UIDeviceOrientationLandscapeRight，
//    // remove the comment '//'
//    // 如果你的App需要支持横竖屏，请使用该方法移除注释 '//'
//    // [self updateTabBarCustomizationWhenTabBarItemWidthDidUpdate];
//
//    // set the bar shadow image
//    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
//    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
//    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tabbar_top_line"]];
//
//    // set the bar background image
//    // 设置背景图片
//    // UITabBar *tabBarAppearance = [UITabBar appearance];
//    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
//
//
//}
//
//- (void)updateTabBarCustomizationWhenTabBarItemWidthDidUpdate {
//    void (^deviceOrientationDidChangeBlock)(NSNotification *) = ^(NSNotification *notification) {
//        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//        if ((orientation == UIDeviceOrientationLandscapeLeft) || (orientation == UIDeviceOrientationLandscapeRight)) {
//            NSLog(@"Landscape Left or Right !");
//        } else if (orientation == UIDeviceOrientationPortrait) {
//            NSLog(@"Landscape portrait!");
//        }
//        [self customizeTabBarSelectionIndicatorImage];
//    };
//    [[NSNotificationCenter defaultCenter] addObserverForName:CYLTabBarItemWidthDidChangeNotification
//                                                      object:nil
//                                                       queue:[NSOperationQueue mainQueue]
//                                                  usingBlock:deviceOrientationDidChangeBlock];
//}
//
//- (void)customizeTabBarSelectionIndicatorImage {
//    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
//    UITabBarController *tabBarController = [self cyl_tabBarController] ?: [[UITabBarController alloc] init];
//    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
//    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
//    //Get initialized TabBar if exists.
//    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
//    [tabBar setSelectionIndicatorImage:
//     [[self class] imageWithColor:[UIColor redColor]
//                             size:selectionIndicatorImageSize]];
//}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITabBarControllerDelegate
//- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    [PlusButtonSubclass resetPlusButtonState];
//    return YES;
//}

//
//-(void)selectSetItem:(NSNotification *)notifi
//{
//    
//    NSInteger itemp = [notifi.object integerValue];
//    if(itemp<0)
//    {
//        itemp=0;
//    }
//    if(itemp>=self.tabBarItemsAttributesForController.count)return;
//    self.tabBarController.selectedIndex = itemp;
//}


@end
