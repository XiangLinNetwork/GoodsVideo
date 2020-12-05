//
//  PGGTabBarViewControllerConfig.m
//  Meidebi
//
//  Created by mdb-losaic on 2018/6/7.
//  Copyright © 2018年 meidebi. All rights reserved.
//

#import "PGGTabBarViewControllerConfig.h"
@import Foundation;
@import UIKit;
@interface PGGBaseNavigationController : UINavigationController
@end
@implementation PGGBaseNavigationController
- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置右滑返回手势的代理为自身
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakself;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    @try {
        
        if([self.viewControllers containsObject:viewController])
        {
            return;
        }
        
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        [super pushViewController:viewController animated:animated];
        
        // 修改tabBra的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}
#pragma mark - UIGestureRecognizerDelegate
//这个方法是在手势将要激活前调用：返回YES允许右滑手势的激活，返回NO不允许右滑手势的激活
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        //屏蔽调用rootViewController的滑动返回手势，避免右滑返回手势引起死机问题
        if (self.viewControllers.count < 2 ||
            self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    //这里就是非右滑手势调用的方法啦，统一允许激活
    return YES;
}

@end

@interface PGGTabBarViewControllerConfig ()

///页面
@property (nonatomic , retain) NSArray *arrVC;
///选中后的图片
@property (nonatomic , retain) NSMutableArray *arrSelectimg;
///默认图片
@property (nonatomic , retain) NSMutableArray *arrnomimg;
///按钮标题
@property (nonatomic , readwrite) NSMutableArray *arrbttitle;
///选中的字体颜色
@property (nonatomic , retain) UIColor *colorSelect;
///默认颜色
@property (nonatomic , retain) UIColor *colornomo;
///当前选中的是那个按钮
@property (nonatomic , retain) UIButton *btnowselect;


@property (nonatomic , retain) NSMutableArray *arrallbt;

@end

@implementation PGGTabBarViewControllerConfig
@synthesize viewTabBar;

//数组数据和颜色
-(void)writeData
{
    self.arrVC = [self PGGviewControllers];
    self.arrbttitle = [[NSMutableArray alloc]initWithObjects:@"首页",@"我的", nil];
    self.colornomo = RGB(91, 91, 91);
    self.colorSelect = RGB(10, 10, 10);
    self.arrSelectimg = [[NSMutableArray alloc]initWithObjects:@"首页1",@"首页2", nil];
    self.arrnomimg = [[NSMutableArray alloc]initWithObjects:@"首页11",@"首页22", nil];
    
    
}

- (NSArray *)PGGviewControllers {
    
//    HomeViewController *vc = [[HomeViewController alloc] init];
//    MyViewController *vc1 = [[MyViewController alloc] init];
//    ///这里占用了部分cup20%
//    PGGBaseNavigationController *firstNavigationController = [[PGGBaseNavigationController alloc]
//                                                   initWithRootViewController:vc];
//
//    PGGBaseNavigationController *secondNavigationController = [[PGGBaseNavigationController alloc]
//                                                    initWithRootViewController:vc1];

    
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    //tabBarController.imageInsets = UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    //tabBarController.titlePositionAdjustment = UIOffsetMake(0, MAXFLOAT);
//    NSArray *viewControllers = @[
//                                 homeViewController,
//                                 findCouponViewController,
//                                 daigouViewController,
//                                 ShareViewController,
//                                 UserViewController
//                                 ];
//    NSArray *viewControllers = @[
//                                 firstNavigationController,
//                                 secondNavigationController
//                                 ];
    
    return [NSArray array];
}

-(NSMutableDictionary *)dictiaozhuanitem:(NSArray *)arr andident:(NSString *)strident
{
    
    NSMutableDictionary *dicitemtemp = [NSMutableDictionary new];
    [dicitemtemp setObject:arr forKey:@"title"];
    [dicitemtemp setObject:strident forKey:@"identifier"];
    return dicitemtemp;
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor
{
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    tabbarItem.imageInsets = UIEdgeInsetsMake(0, -10, -6, -10);
    if(title.length==0)
    {
        tabbarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self writeData];

    for(int i = 0 ; i <_arrVC.count ; i++)
    {
        UIViewController *homeVC=_arrVC[i];
        [self setTabBarItem:homeVC.tabBarItem
                      title:self.arrbttitle[i]
                  titleSize:11.0
              titleFontName:@"HeiTi SC"
              selectedImage:self.arrSelectimg[i]
         selectedTitleColor:self.colorSelect
                normalImage:self.arrnomimg[i]
           normalTitleColor:self.colornomo];
    }
    self.viewControllers = _arrVC;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSetItem:) name:@"tabbarselectother" object:nil];
    
    UIImage *i = [UIImage imageNamed:@"write_back_tabbar.png"];
    
    [self.tabBar setBackgroundImage:i];
    
    [self.tabBar setShadowImage:i];
    
    self.tabBar.tintColor = self.colorSelect;
    
    UIView *viewline = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.tabBar.width, 1)];
    [viewline setBackgroundColor:RGB(245, 245, 245)];
    [self.tabBar addSubview:viewline];
//    self.tabBar.layer.shadowColor = RGB(0, 0, 0).CGColor;
//    // 设置阴影偏移量
//    self.tabBar.layer.shadowOffset = CGSizeMake(0,-2);
//    // 设置阴影透明度
//    self.tabBar.layer.shadowOpacity = 0.2;
//    // 设置阴影半径
//    self.tabBar.layer.shadowRadius = 4;
    
    
}


-(void)selectSetItem:(NSNotification *)notifi
{
    NSInteger itemp = [notifi.object integerValue];
    if(itemp<0)
    {
        itemp=0;
    }
    if(itemp>=self.arrVC.count)return;
    self.selectedIndex = itemp;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
