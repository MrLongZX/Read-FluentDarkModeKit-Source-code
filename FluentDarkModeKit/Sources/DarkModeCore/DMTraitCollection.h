//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DMUserInterfaceStyle) {
  DMUserInterfaceStyleUnspecified,
  DMUserInterfaceStyleLight,
  DMUserInterfaceStyleDark,
};

// 特征收集类
@interface DMTraitCollection : NSObject

// 当前特征收集对象
@property (class, nonatomic, strong) DMTraitCollection *currentTraitCollection;

+ (DMTraitCollection *)traitCollectionWithUserInterfaceStyle:(DMUserInterfaceStyle)userInterfaceStyle;

// 当前主题类型
@property (nonatomic, readonly) DMUserInterfaceStyle userInterfaceStyle;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

@end

#pragma mark - DMTraitEnvironment

@protocol DMTraitEnvironment <NSObject>

- (void)dmTraitCollectionDidChange:(nullable DMTraitCollection *)previousTraitCollection;

@end

NS_ASSUME_NONNULL_END
