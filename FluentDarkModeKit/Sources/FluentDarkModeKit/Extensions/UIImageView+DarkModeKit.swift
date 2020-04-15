//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

#if SWIFT_PACKAGE
import DarkModeCore
#endif

extension UIImageView {

  // 私有结构体
  private struct Constants {
    static var dynamicImageKey = "dynamicImageKey"
  }

  // 添加可选UIImage类型属性dm_dynamicImage，通过关联对象进行保存、获取
  var dm_dynamicImage: UIImage? {
    get { return objc_getAssociatedObject(self, &Constants.dynamicImageKey) as? UIImage }
    set { objc_setAssociatedObject(self, &Constants.dynamicImageKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
  }

  // 交互setImage方法
  static let swizzleSetImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(setter: image), to: #selector(dm_setImage(_:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIImageView.self, selector: #selector(setter: image)))
    }
  }()

  // 交互初始化方法
  static let swizzleInitImageOnce: Void = {
    if !dm_swizzleInstanceMethod(#selector(UIImageView.init(image:)), to: #selector(UIImageView.dm_init(image:))) {
      assertionFailure(DarkModeManager.messageForSwizzlingFailed(class: UIImageView.self, selector: #selector(setter: image)))
    }
  }()

  @objc dynamic func dm_init(image: UIImage?) -> UIImageView {
    // 判断类对象是否相等
    if object_getClass(image) == DMDynamicImageProxy.self {
      // 保存主题动态图片
      dm_dynamicImage = image
    }
    // 执行原生初始化方法
    return dm_init(image: image)
  }

  // 覆写更新主题动态图片方法
  override func dm_updateDynamicImages() {
    super.dm_updateDynamicImages()

    // 存在保存的主题动态图片
    if let dynamicImage = dm_dynamicImage {
      // 则进行设置
      image = dynamicImage
    }
  }

  @objc dynamic func dm_setImage(_ image: UIImage?) {
    // 判断类对象是否相等
    if object_getClass(image) == DMDynamicImageProxy.self {
      // 保存主题动态图片
      dm_dynamicImage = image
    }
    else {
      // 将主题动态图片置空
      dm_dynamicImage = nil
    }
    // 调用原生setImage方法
    dm_setImage(image)
  }
}
