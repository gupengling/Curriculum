//
//  GPLKeyBoardWrapper.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/20.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//
import UIKit
import Foundation
public enum GPLKeyboardState {
    case willChangeFrame
    case didChangeFrame
    case willHide
    case didHidden
    case willShow
    case didShow
}

public struct GPLKeyBoardInfo {
    public let state:GPLKeyboardState
    public let notification:Notification
    public let beginFrame: CGRect
    public let endFrame: CGRect
    public let animationDuration: TimeInterval
}

public extension GPLKeyBoardInfo {
    init(notificationInfo:Notification,state:GPLKeyboardState) {
        self.notification = notificationInfo
        self.state = state
        self.beginFrame = (notificationInfo.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        self.endFrame = (notificationInfo.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.animationDuration = TimeInterval(notificationInfo.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.0)
    }
}

public protocol GPLKeyBoardWrapperDelegate:NSObjectProtocol {
    func keyBoardWrapper(_ wrapper:GPLKeyBoardWrapper,didChangeKeyboardInfo info:GPLKeyBoardInfo)
}

open class GPLKeyBoardWrapper {
    open weak var delegate:GPLKeyBoardWrapperDelegate?

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public init() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillChangeFrameNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidChangeFrameNotification(_:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidShowNotification(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardDidHideNotification(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    public convenience init(delegate:GPLKeyBoardWrapperDelegate) {
        self.init()
        self.delegate = delegate
    }

    // MARK: - 通知实现
    @objc private func keyboardWillChangeFrameNotification(_ notification:Notification) {
        delegate?.keyBoardWrapper(self,didChangeKeyboardInfo: GPLKeyBoardInfo(notificationInfo: notification as Notification, state: .willChangeFrame))
    }
    @objc private func keyboardDidChangeFrameNotification(_ notification:Notification) {
        delegate?.keyBoardWrapper(self,didChangeKeyboardInfo: GPLKeyBoardInfo(notificationInfo: notification as Notification, state: .didChangeFrame))
    }
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        delegate?.keyBoardWrapper(self,didChangeKeyboardInfo: GPLKeyBoardInfo(notificationInfo: notification as Notification, state: .willShow))
    }
    @objc private func keyboardDidShowNotification(_ notification: Notification) {
        delegate?.keyBoardWrapper(self,didChangeKeyboardInfo: GPLKeyBoardInfo(notificationInfo: notification as Notification, state: .didShow))
    }
    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        delegate?.keyBoardWrapper(self,didChangeKeyboardInfo: GPLKeyBoardInfo(notificationInfo: notification as Notification, state: .willHide))
    }
    @objc private func keyboardDidHideNotification(_ notification: Notification) {
        delegate?.keyBoardWrapper(self,didChangeKeyboardInfo: GPLKeyBoardInfo(notificationInfo: notification as Notification, state: .didHidden))
    }
}
