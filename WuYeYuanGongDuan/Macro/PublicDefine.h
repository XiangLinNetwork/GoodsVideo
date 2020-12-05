

#define kMainScreenW [UIScreen mainScreen].bounds.size.width
#define kMainScreenH [UIScreen mainScreen].bounds.size.height

#define kScale [UIScreen mainScreen].bounds.size.width / 375.0

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define RGB(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]

#define RGBAlpha(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define DateFormatter @"yyyy-MM-dd HH:mm:ss"

#define MenuColor [UIColor colorWithRed:118/255.0 green:163/255.0 blue:93/255.0 alpha:1.0]


