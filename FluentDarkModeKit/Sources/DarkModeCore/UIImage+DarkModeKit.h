//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <UIKit/UIKit.h>
#import <FluentDarkModeKit/DMNamespace.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DarkModeKit)

// 通过下面的两个方法来创建暗黑主题的UIImage对象

+ (UIImage *)dm_imageWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage
NS_SWIFT_UNAVAILABLE("Use init(_:light:dark:) instead.");

#if __swift__
+ (UIImage *)dm_namespace:(DMNamespace)namespace
      imageWithLightImage:(UIImage *)lightImage
                darkImage:(UIImage *)darkImage NS_SWIFT_NAME(init(_:light:dark:));
#endif

@end

NS_ASSUME_NONNULL_END
