//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>
#import <FluentDarkModeKit/DMNamespace.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DarkModeKit)

// 通过下面的两个方法来创建暗黑主题的UIColor对象

// NS_SWIFT_UNAVAILABLE 标记对 swift 不可用
+ (UIColor *)dm_colorWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor
NS_SWIFT_UNAVAILABLE("Use init(_:light:dark:) instead.");

// 判断编译环境 NS_SWIFT_NAME：重命名swift 下名称
#if __swift__
+ (UIColor *)dm_namespace:(DMNamespace)namespace
      colorWithLightColor:(UIColor *)lightColor
                darkColor:(UIColor *)darkColor NS_SWIFT_NAME(init(_:light:dark:));
#endif

@end

NS_ASSUME_NONNULL_END
