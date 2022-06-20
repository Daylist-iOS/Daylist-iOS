//
//  UIWindow+.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/21.
//

import UIKit

extension UIWindow {
    static var keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
}
