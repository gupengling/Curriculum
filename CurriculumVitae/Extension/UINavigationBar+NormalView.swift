//
//  UINavigationBar+Extension.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/25.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import Foundation
import UIKit

private var kNavigationAssociatedKey = "kNavigationAssociatedKey"

public class NormalView: NSObject {
    var navigationBar: UINavigationBar
    init(navigationBar: UINavigationBar) {
        self.navigationBar = navigationBar
        super.init()
    }

    fileprivate var navigationView: UIView?
    fileprivate var statusBarView: UIView?

    public var backgroundColor: UIColor? {
        get{
            return navigationView?.backgroundColor
        }
        set {
            if navigationView == nil {
                navigationBar.setBackgroundImage(UIImage(), for: .default)
                navigationBar.shadowImage = UIImage()

                let sh = UIApplication.shared.statusBarFrame.height
                let nw = self.navigationBar.bounds.width
                let nh = self.navigationBar.bounds.height

                navigationView = UIView(frame: CGRect(x: 0, y: -sh, width: nw, height: nh + sh))
                navigationView?.isUserInteractionEnabled = false
                navigationView?.autoresizingMask = [.flexibleWidth,.flexibleHeight]
                navigationBar.insertSubview(navigationView!, at: 0)
            }
            navigationView?.backgroundColor = newValue
        }
    }

    public var statusBarColor:UIColor? {
        get{
            return statusBarView?.backgroundColor
        }
        set{
            if statusBarView == nil {
                let sh = UIApplication.shared.statusBarFrame.height
                let nw = self.navigationBar.bounds.width
//                let nh = self.navigationBar.bounds.height

                statusBarView = UIView(frame: CGRect(x: 0, y: -sh, width: nw, height: sh))
                statusBarView?.isUserInteractionEnabled = false
                statusBarView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                if (navigationView != nil) {
                    navigationBar.insertSubview(statusBarView!, aboveSubview: navigationView!)
                }else {
                    navigationBar.insertSubview(statusBarView!, at: 0)
                }
            }
            statusBarView?.backgroundColor = newValue
        }
    }
    public func hideShadow(_ doHide: Bool) {
        navigationBar.shadowImage = doHide ? UIImage() : nil
    }
    public func clear() {
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = nil

        navigationView?.removeFromSuperview()
        navigationView = nil

        statusBarView?.removeFromSuperview()
        statusBarView = nil
    }

}

public extension UINavigationBar {
    public var bgV : NormalView {
        get {
            if let backView = objc_getAssociatedObject(self, &kNavigationAssociatedKey) {
                return backView as! NormalView
            }
            let backView = NormalView(navigationBar: self)
            objc_setAssociatedObject(self, &kNavigationAssociatedKey, backView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return backView
        }
    }
}
