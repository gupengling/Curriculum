//
//  UIDevice+Extension.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/19.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit
extension UIDevice {
    public func isFullScreen() -> Bool {
        return (UIApplication.shared.statusBarFrame.height == 44)
    }
    public func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false

    }
}
