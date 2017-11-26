//
//  UITabBarController+Rx.swift
//  RxTV
//
//  Created by Toshihiro Suzuki on 2017/11/26.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UITabBarController {
    var _isTabBarHidden: Bool {
        return base.tabBar.frame.origin.y < 0
    }
    public var isTabBarHidden: Binder<Bool> {
        return Binder(base) { tbc, isHidden in
            if isHidden {
                if !tbc.rx._isTabBarHidden {
                    self.hideTabbar()
                }
            } else {
                if tbc.rx._isTabBarHidden {
                    self.showTabbar()
                }
            }
        }
    }
    private func showTabbar() {
        self.base.tabBar.alpha = 1
        self.base.tabBar.isHidden = false
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: UIViewAnimationOptions.curveEaseOut,
            animations:
        {
            self.base.tabBar.frame.origin.y = 0
        }, completion: { _ in
            self.base.setNeedsFocusUpdate()
            self.base.updateFocusIfNeeded()
        })
    }

    private func hideTabbar() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: UIViewAnimationOptions.curveEaseOut,
            animations:
        {
            self.base.tabBar.frame.origin.y = -self.base.tabBar.bounds.height
        }, completion: { _ in
            self.base.tabBar.isHidden = true
            self.base.tabBar.alpha = 0
             if let focused = UIScreen.main.focusedView, focused.isDescendant(of: self.base.tabBar) {
                 self.base.setNeedsFocusUpdate()
                 self.base.updateFocusIfNeeded()
             }
        })
    }
}
