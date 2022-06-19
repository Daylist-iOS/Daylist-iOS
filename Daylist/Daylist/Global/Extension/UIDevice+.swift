//
//  UIDevice+.swift
//  Daylist
//
//  Created by 황윤경 on 2022/06/19.
//

import UIKit
import AVFoundation

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
