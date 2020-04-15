//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMDynamicColor.h"
#import "DMTraitCollection.h"


@interface DMDynamicColorProxy : NSProxy <NSCopying>

// 保存普通主题颜色
@property (nonatomic, strong) UIColor *lightColor;
// 保存暗黑主题颜色
@property (nonatomic, strong) UIColor *darkColor;

// 用于消息转发，返回保存的普通主题或暗黑主题颜色
@property (nonatomic, readonly) UIColor *resolvedColor;

@end

@implementation DMDynamicColorProxy

// TODO: We need a more generic initializer.
- (instancetype)initWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
  self.lightColor = lightColor;
  self.darkColor = darkColor;

  return self;
}

// 根据当前主题，返回用于处理消息转发的主题颜色
- (UIColor *)resolvedColor {
  if (DMTraitCollection.currentTraitCollection.userInterfaceStyle == DMUserInterfaceStyleDark) {
    return self.darkColor;
  } else {
    return self.lightColor;
  }
}

// MARK: UIColor

- (UIColor *)colorWithAlphaComponent:(CGFloat)alpha {
  return [[DMDynamicColor alloc] initWithLightColor:[self.lightColor colorWithAlphaComponent:alpha]
                                          darkColor:[self.darkColor colorWithAlphaComponent:alpha]];
}

// MARK: NSProxy

// 采用消息转发中第三种，标准消息转发机制
// 获取方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
  return [self.resolvedColor methodSignatureForSelector:sel];
}

// 获取当前主题颜色UIColor来接受消息的转发
- (void)forwardInvocation:(NSInvocation *)invocation {
  [invocation invokeWithTarget:self.resolvedColor];
}

// MARK: NSObject 实现isKindOfClass方法，用于判断参数aClass是否是DMDynamicColor类型

- (BOOL)isKindOfClass:(Class)aClass {
  static DMDynamicColor *dynamicColor = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dynamicColor = [[DMDynamicColor alloc] init];
  });
  return [dynamicColor isKindOfClass:aClass];
}

// MARK: 遵循 NSCopying 协议

- (id)copy {
  return [self copyWithZone:nil];
}

- (id)copyWithZone:(NSZone *)zone {
  return [[DMDynamicColorProxy alloc] initWithLightColor:self.lightColor darkColor:self.darkColor];
}

@end

// MARK: -

@implementation DMDynamicColor

- (UIColor *)initWithLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
  // 真正是创建一个DMDynamicColorProxy类型对象
  return (DMDynamicColor *)[[DMDynamicColorProxy alloc] initWithLightColor:lightColor darkColor:darkColor];
}

- (UIColor *)lightColor {
  NSAssert(NO, @"This should never be called");
  return nil;
}

- (UIColor *)darkColor {
  NSAssert(NO, @"This should never be called");
  return nil;
}

@end
