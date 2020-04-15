//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "UIView+DarkModeKit.h"
#import "DMDynamicColor.h"

@import ObjectiveC;

@implementation UIView (DarkModeKit)

static void (*dm_original_setBackgroundColor)(UIView *, SEL, UIColor *);

static void dm_setBackgroundColor(UIView *self, SEL _cmd, UIColor *color) {
  if ([color isKindOfClass:[DMDynamicColor class]]) {
    // 如果是主题动态颜色，则保存
    self.dm_dynamicBackgroundColor = (DMDynamicColor *)color;
  } else {
    // 如果不是主题动态颜色，则设置为nil，清空通过关联对象保存的值
    self.dm_dynamicBackgroundColor = nil;
  }
  // 调用原生设置背景颜色方法
  dm_original_setBackgroundColor(self, _cmd, color);
}

// https://stackoverflow.com/questions/42677534/swizzling-on-properties-that-conform-to-ui-appearance-selector
+ (void)dm_swizzleSetBackgroundColor {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Method method = class_getInstanceMethod(self, @selector(setBackgroundColor:));
    dm_original_setBackgroundColor = (void *)method_getImplementation(method);
    method_setImplementation(method, (IMP)dm_setBackgroundColor);
  });
}

// 获取存储的主题动态颜色
- (DMDynamicColor *)dm_dynamicBackgroundColor {
  return objc_getAssociatedObject(self, _cmd);
}

// 通过关联对象存储主题动态颜色
// 由于对类似backgroundColor这样的属性进行赋值，apple可能进行了拷贝，再次取出赋值对象后，可能不再是赋值时的DMDynamicColor类型对象
// 所以需要对主题动态颜色进行保存
- (void)setDm_dynamicBackgroundColor:(DMDynamicColor *)dm_dynamicBackgroundColor {
  objc_setAssociatedObject(self,
                           @selector(dm_dynamicBackgroundColor),
                           dm_dynamicBackgroundColor,
                           OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
