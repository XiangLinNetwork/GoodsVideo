//
//  UIButton+HQCustomIcon.h
//  TicketPassesAPP
//
//  Created by xiaoshiheng on 2019/8/12.
//  Copyright © 2019 macbook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (HQCustomIcon)

/** 图片在左，标题在右 */
- (void)setIconInLeft;
/** 图片在右，标题在左 */
- (void)setIconInRight;
/** 图片在上，标题在下 */
- (void)setIconInTop;
/** 图片在下，标题在上 */
- (void)setIconInBottom;

//** 可以自定义图片和标题间的间隔 */
- (void)setIconInLeftWithSpacing:(CGFloat)Spacing;
- (void)setIconInRightWithSpacing:(CGFloat)Spacing;
- (void)setIconInTopWithSpacing:(CGFloat)Spacing;
- (void)setIconInBottomWithSpacing:(CGFloat)Spacing;

- (void)setTitleIconInRight:(NSString *)string;

- (void)setTitleIconInTop:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
