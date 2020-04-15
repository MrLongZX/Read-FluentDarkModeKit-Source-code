//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentDarkModeKit
import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(.dm, light: .white, dark: .black)

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .refresh,
      target: self,
      action: #selector(refresh)
    )
  }

  @objc
  private func refresh() {
    if DMTraitCollection.current.userInterfaceStyle == .dark {
      // 设置新的主题
      DMTraitCollection.current = DMTraitCollection(userInterfaceStyle: .light)
    } else {
      DMTraitCollection.current = DMTraitCollection(userInterfaceStyle: .dark)
    }
    // 更换主题
    DarkModeManager.updateAppearance(for: .shared, animated: true)
  }
}
