//
//  UIApplication+.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/21.
//

import UIKit
extension UIApplication {
    class func topViewController(base: UIViewController? = UIWindow.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
