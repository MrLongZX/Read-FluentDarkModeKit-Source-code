//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

// 重命名在swift中的名称
NS_SWIFT_NAME(DynamicColor)
// 创建一个UIColor子类
@interface DMDynamicColor : UIColor

// 普通主题颜色
@property (nonatomic, readonly) UIColor *lightColor;
// 暗黑主题颜色
@property (nonatomic, readonly) UIColor *darkColor;

// 初始化动态颜色方法
- (instancetype)initWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
