//
//  UISplitViewController+Rx.swift
//  RxTV
//
//  Created by Toshihiro Suzuki on 2017/11/26.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UISplitViewController {
    private func hideMasterViewIfNeeded() {
        if !_isMasterViewHidden { toggleMasterView() }
    }
    private func showMasterViewIfNeeded() {
        if _isMasterViewHidden { toggleMasterView() }
    }
    private func toggleMasterView() {
        let barButtonItem = base.displayModeButtonItem
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
    }
    public var masterViewController: UIViewController! {
        return (base.viewControllers[0] as! UINavigationController).viewControllers.first
    }
    public var secondaryViewController: UIViewController {
        return base.viewControllers[1]
    }
    var _isMasterViewHidden: Bool {
        return base.view.subviews.contains { $0.frame.origin.x < 0 }
    }
    public var isMasterViewHidden: Binder<Bool> {
        return Binder(base) { splitvc, isHidden in
            if isHidden {
                splitvc.rx.hideMasterViewIfNeeded()
            } else {
                splitvc.rx.showMasterViewIfNeeded()
            }
        }
    }
}
