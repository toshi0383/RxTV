//
//  UIPress+Rx.swift
//  RxTV
//
//  Created by Toshihiro Suzuki on 2017/11/18.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

public protocol PressableView {
    func press(_ allowedPressTypes: [UIPressType]) -> Observable<Void>
    func press(_ allowedPressType: UIPressType) -> Observable<Void>
}

extension Reactive where Base: UIView {
    public func press(_ allowedPressTypes: [UIPressType]) -> Observable<Void> {
        return base.press(allowedPressTypes)
    }
    public func press(_ allowedPressType: UIPressType) -> Observable<Void> {
        return base.press([allowedPressType])
    }
}

extension UIView {
    fileprivate func press(_ allowedPressTypes: [UIPressType]) -> Observable<Void> {
        let gesture = UITapGestureRecognizer()
        gesture.allowedPressTypes = allowedPressTypes.map { $0.rawValue as NSNumber }
        addGestureRecognizer(gesture)
        return gesture.rx.event.map { _ in }
            .do(onDispose: { [weak self] in self?.removeGestureRecognizer(gesture) })
    }
}
