//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import "DMDynamicImage.h"
#import "DMTraitCollection.h"
#import "NSObject+DarkModeKit.h"

@import ObjectiveC;

@interface DMDynamicImageProxy ()

@property (nonatomic, strong) UIImage *lightImage;
@property (nonatomic, strong) UIImage *darkImage;

@end

@implementation DMDynamicImageProxy

- (instancetype)initWithLightImage:(UIImage *)lightImage darkImage:(UIImage *)darkImage {
  self.lightImage = lightImage;
  self.darkImage = darkImage;
  // For now, we don't support `nil` images as it will cause bad result
  // when using in swift:
  // `someOptionalDynamicImage as? UIImage` will return `true`
  // even when the internal `lightImage` or `darkImage` is nil
  NSAssert(self.darkImage != nil, @"Nil image is not supported yet");
  if (self.lightImage == nil) {
    NSAssert(NO, @"Nil light image is not supported yet");
    self.lightImage = [UIImage new];
  }
  if (self.darkImage == nil) {
    NSAssert(NO, @"Nil dark image is not supported yet");
    self.darkImage = [UIImage new];
  }
  return self;
}

- (UIImage *)resolvedImage {
  if (DMTraitCollection.currentTraitCollection.userInterfaceStyle == DMUserInterfaceStyleDark) {
    return self.darkImage;
  } else {
    return self.lightImage;
  }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
  return [self.resolvedImage methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
  [invocation invokeWithTarget:self.resolvedImage];
}

#pragma mark - Public Methods

/// Passing these public methods to both light and dark images
/// instead of only to the `resolvedImage`

// 设置图片的拉伸
- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets {
  return (UIImage *)[[DMDynamicImageProxy alloc] initWithLightImage:[self.lightImage resizableImageWithCapInsets:capInsets]
                                                          darkImage:[self.darkImage resizableImageWithCapInsets:capInsets]];
}

// 设置图片的拉伸、拉伸模式
- (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode {
  UIImage *lightImage = [self.lightImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
  UIImage *darkImage = [self.darkImage resizableImageWithCapInsets:capInsets resizingMode:resizingMode];
  return (UIImage *)[[DMDynamicImageProxy alloc] initWithLightImage:lightImage darkImage:darkImage];
}

// 设置对齐方式
- (UIImage *)imageWithAlignmentRectInsets:(UIEdgeInsets)alignmentInsets {
  return (UIImage *)[[DMDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageWithAlignmentRectInsets:alignmentInsets]
                                                          darkImage:[self.darkImage imageWithAlignmentRectInsets:alignmentInsets]];
}

// 设置渲染模式
- (UIImage *)imageWithRenderingMode:(UIImageRenderingMode)renderingMode {
  return (UIImage *)[[DMDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageWithRenderingMode:renderingMode]
                                                          darkImage:[self.darkImage imageWithRenderingMode:renderingMode]];
}

- (UIImage *)imageFlippedForRightToLeftLayoutDirection {
  return (UIImage *)[[DMDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageFlippedForRightToLeftLayoutDirection]
                                                          darkImage:[self.darkImage imageFlippedForRightToLeftLayoutDirection]];
}

- (UIImage *)imageWithHorizontallyFlippedOrientation {
  return (UIImage *)[[DMDynamicImageProxy alloc] initWithLightImage:[self.lightImage imageWithHorizontallyFlippedOrientation]
                                                          darkImage:[self.darkImage imageWithHorizontallyFlippedOrientation]];
}

// 遵循 NSCopying 协议
- (id)copy {
  return [self copyWithZone:nil];
}

- (id)copyWithZone:(NSZone *)zone {
  return [[DMDynamicImageProxy alloc] initWithLightImage:self.lightImage darkImage:self.darkImage];
}

@end