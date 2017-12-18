//
//  SplitViewController.swift
//  Example
//
//  Created by Toshihiro Suzuki on 2017/11/26.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import RxTV
import RxSwift
import UIKit

class SplitViewController: UISplitViewController {

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController!.rx.isTabBarHidden.onNext(true)
    }

    @IBAction private func triggerToggleAnimations() {

        disposeBag = DisposeBag()

        Observable<Int>.timer(1.0, period: 1.0, scheduler: MainScheduler.instance)
            .map { $0 % 2 == 0 }
            .bind(to: rx.isMasterViewHidden)
            .disposed(by: disposeBag)

        Observable<Int>.timer(1.2, period: 1.2, scheduler: MainScheduler.instance)
            .map { $0 % 2 == 0 }
            .bind(to: tabBarController!.rx.isTabBarHidden)
            .disposed(by: disposeBag)
    }
}
