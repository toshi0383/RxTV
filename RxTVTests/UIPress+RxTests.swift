//
//  UIPress+RxTests.swift
//  RxTVTests
//
//  Created by Toshihiro Suzuki on 2017/11/18.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import RxSwift
import RxTV
import XCTest

class UIPress_RxTests: XCTestCase {

    private var view: UIView!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        view = UIView()
    }

    func testDispose() {
        view.rx.press(.playPause)
            .subscribe()
            .disposed(by: disposeBag)
        XCTAssert(!view.gestureRecognizers!.isEmpty)
        disposeBag = nil
        XCTAssert(view.gestureRecognizers!.isEmpty)
    }
    
    func testDisposeView() {
        var disposed = false
        view.rx.press(.playPause)
            .do(onDispose: { disposed = true })
            .subscribe()
            .disposed(by: disposeBag)
        XCTAssert(!disposed)
        view = nil
        XCTAssert(!disposed) // not disposed by nil-out view
    }
}

//    func testSubscribe() {
//        let result = Variable<String?>(nil)
//
//        view.rx.press(.playPause)
//            .map { _ in "a" }
//            .subscribe()
//            .disposed(by: disposeBag)
//        view.performClick(.playPause)
//        XCTAssertEqual(result.value, "a")
//    }
//}
// FIXME: implement manual press triggering if possible
// SeeAlso:
//   http://www.cocoawithlove.com/2008/10/synthesizing-touch-event-on-iphone.html
//extension UIView {
//    func performClick(_ pressType: UIPressType) {
//        let press = UIPress()
//        press
//    }
//}

