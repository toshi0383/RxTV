//
//  ExampleViewController.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/11/27.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import RxSwift
import RxTV
import UIKit

class FocusableView: UIView {
    override var canBecomeFocused: Bool {
        return true
    }
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            self.transform = context.nextFocusedView == self ? CGAffineTransform(scaleX: 1.1, y: 1.1) : .identity
        }, completion: nil)
        super.didUpdateFocus(in: context, with: coordinator)
    }
}

final class ExampleViewController: UIViewController {
    @IBOutlet private weak var view1: FocusableView!
    @IBOutlet private weak var view2: FocusableView!
    @IBOutlet private weak var view3: FocusableView!
    @IBOutlet private weak var view4: FocusableView!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // DEMO: coordinator is still alive!
        rx.didUpdateFocus
            .subscribe(onNext: { (context, coordinator) in
                coordinator.addCoordinatedAnimations({
                    if context.nextFocusedView == self.view1 {
                        self.view1.backgroundColor = .yellow
                    } else {
                        self.view1.backgroundColor = .white
                    }
                }, completion: nil)
            })
            .disposed(by: disposeBag)

        // DEMO: coordinator is still alive!
        rx.didUpdateFocus(match: .isDescendantOf(next: view2))
            .subscribe(onNext: { (matchResult) in
                matchResult.coordinator.addCoordinatedAnimations({
                    if matchResult.isSuccess {
                        self.view2.backgroundColor = .orange
                    } else {
                        self.view2.backgroundColor = .white
                    }
                }, completion: nil)
            })
            .disposed(by: disposeBag)

        // DEMO: Open/Close SplitView on content focus
        if let svc = splitViewController {
            rx.didUpdateFocus(match: .isDescendantOf(next: view4))
                .map { $0.isSuccess }
                .distinctUntilChanged()
                .bind(to: svc.rx.isMasterViewHidden)
                .disposed(by: disposeBag)
        }

    }
}
