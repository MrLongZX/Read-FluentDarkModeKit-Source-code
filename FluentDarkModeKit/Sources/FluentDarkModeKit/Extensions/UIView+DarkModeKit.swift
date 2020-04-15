//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

// 扩展UIView 遵循DMTraitEnvironment代理
extension UIView: DMTraitEnvironment {
  open func dmTraitCollectionDidChange(_ previousTraitCollection: DMTraitCollection?) {
    subviews.forEach { $0.dmTraitCollectionDidChange(previousTraitCollection) }
    setNeedsLayout()
    setNeedsDisplay()
    dm_updateDynamicColors()
    dm_updateDynamicImages()
  }

  @objc func dm_updateDynamicColors() {
    // 取出保存主题动态背景颜色 判断是否存在
    if let dynamicBackgroundColor = dm_dynamicBackgroundColor {
      // 设置当前view的backgroundColor为主题动态颜色
      backgroundColor = dynamicBackgroundColor
    }
    
     // 取出保存主题动态tint颜色 判断是否存在
    if let dynamicTintColor = dm_dynamicTintColor {
      tintColor = dynamicTintColor
    }
  }

  // 子类实现
  @objc func dm_updateDynamicImages() {
    // For subclasses to override.
  }
}

extension UIView {
  // 进行方法交互
  static let swizzleWillMoveToWindowOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(willMove(toWindow:)), to: #selector(dm_willMove(toWindow:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: #selector(willMove(toWindow:))))
    }
  }()

  // 在添加到 window 时更新当前主题对应的颜色和图片。
  @objc private dynamic func dm_willMove(toWindow window: UIWindow?) {
    // 先调用原生方法willMove(toWindow:)
    dm_willMove(toWindow: window)
    if window != nil {
      // 更新当前主题颜色
      dm_updateDynamicColors()
      // 更新当前主题图片
      dm_updateDynamicImages()
    }
  }
}

extension UIView {
  // 私有结构体
  private struct Constants {
    static var dynamicTintColorKey = "dynamicTintColorKey"
  }

  // 对tintColor set方法进行方法交互
  static let swizzleSetTintColorOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: tintColor), to: #selector(dm_setTintColor)) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIView.self, selector: #selector(setter: tintColor)))
    }
  }()

  // 添加分类属性，与OC UIView+DarkModeKit分类 dm_dynamicBackgroundColor属性逻辑一致
  private var dm_dynamicTintColor: DynamicColor? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicTintColorKey) as? DynamicColor }
    set { objc_setAssociatedObject(self, &Constants.dynamicTintColorKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  @objc private dynamic func dm_setTintColor(_ color: UIColor) {
    // 对设置的主题动态颜色进行保存
    dm_dynamicTintColor = color as? DynamicColor
    // 调用原生tintColor set方法
    dm_setTintColor(color)
  }
}
