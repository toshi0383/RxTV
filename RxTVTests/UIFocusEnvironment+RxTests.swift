//
//  UIFocusEnvironment+RxTests.swift
//  RxTVTests
//
//  Created by Toshihiro Suzuki on 2017/11/26.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import RxSwift
import RxTest
@testable import RxTV
import XCTest

class UIFocusEnvironment_RxTests: XCTestCase {
    private var view: UIView!
    override func setUp() {
        super.setUp()
    }

    // MARK: rx.didUpdateFocus
    func testDidUpdateFocus() {
        view = UIView()
        let scheduler = TestScheduler(initialClock: 0)
        let o: TestableObserver<Int> = scheduler.createObserver(Int.self)
        scheduler.scheduleAt(150) {
            _ = self.view.rx.didUpdateFocus.map { _ in 1 }
                .subscribe(o)
        }
        scheduler.scheduleAt(200) {
            self.view.triggerDidUpdateFocus()
        }
        scheduler.start()
        XCTAssertEqual(o.events, [next(200, 1)])
    }

    func testDidUpdateFocus_hasNoCache() {
        view = UIView()
        let scheduler = TestScheduler(initialClock: 0)
        let o: TestableObserver<Int> = scheduler.createObserver(Int.self)
        scheduler.scheduleAt(100) {
            self.view.triggerDidUpdateFocus()
        }
        scheduler.scheduleAt(150) {
            _ = self.view.rx.didUpdateFocus.map { _ in 1 }
                .subscribe(o)
        }
        scheduler.start()
        XCTAssertEqual(o.events, [])
    }

    // MARK: Match
    func testMatch_resignDescendantOf() {
        let next = UIView()
        let previous = UIView()
        let match: Match = .resignDescendant(of: previous)
        XCTAssertTrue(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: nil)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: nil)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: nil)))
    }

    func testMatch_isDescendantOf_next_previous() {
        let next = UIView()
        let previous = UIView()
        let match: Match = .isDescendantOf(next: next, previous: previous)
        XCTAssertTrue(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: nil)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: nil)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: nil)))
    }

    func testMatch_isDescendantOf_next() {
        let next = UIView()
        let previous = UIView()
        let match: Match = .isDescendantOf(next: next)
        XCTAssertTrue(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: previous)))
        XCTAssertTrue(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: next)))
        XCTAssertTrue(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: nil)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: nil)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: nil)))
    }

    func testMatch_isTypeOf_next() {
        final class MatchingView: UIView { }
        let previous = UIView()
        let next = MatchingView()
        let match: Match = .isTypeOf(next: MatchingView.self)
        XCTAssertTrue(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: previous)))
        XCTAssertTrue(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: next)))
        XCTAssertTrue(match.match(TestableFocusUpdateContext(nextFocusedView: next, previouslyFocusedView: nil)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: previous, previouslyFocusedView: nil)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: next)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: previous)))
        XCTAssertFalse(match.match(TestableFocusUpdateContext(nextFocusedView: nil, previouslyFocusedView: nil)))
    }

    // MARK: rx.didUpdateFocus(match:)
    func testIsDescendantOf() {
        let parent = UIView()
        XCTAssertTrue(parent.isDescendant(of: parent))
    }

    func testDidUpdateFocus_Match_UIView() {
        let subview = UIView()
        view = UIView()
        view.addSubview(subview)
        let subviewOfsubview = UIView()
        subview.addSubview(subviewOfsubview)
        let scheduler = TestScheduler(initialClock: 0)
        let o: TestableObserver<Int> = scheduler.createObserver(Int.self)
        scheduler.scheduleAt(150) {
            _ = self.view.rx.didUpdateFocus(match: .isDescendantOf(next: subview))
                .filter { $0.isSuccess }
                .map { _ in 1 }
                .subscribe(o)
            _ = self.view.rx.didUpdateFocus(match: .isDescendantOf(next: subviewOfsubview))
                .filter { $0.isSuccess }
                .map { _ in 2 }
                .subscribe(o)
        }
        scheduler.scheduleAt(200) {
            self.view.triggerDidUpdateFocus(with: TestableFocusUpdateContext(nextFocusedView: subview))
        }
        scheduler.start()
        XCTAssertEqual(o.events, [next(200, 1)])
    }

    func testDidUpdateFocus_Match_UIViewController() {
        let subview = UIView()
        let vc = UIViewController()
        vc.view.addSubview(subview)
        let subviewOfsubview = UIView()
        subview.addSubview(subviewOfsubview)
        let scheduler = TestScheduler(initialClock: 0)
        let o: TestableObserver<Int> = scheduler.createObserver(Int.self)
        scheduler.scheduleAt(150) {
            _ = vc.rx.didUpdateFocus(match: .isDescendantOf(next: subview))
                .filter { $0.isSuccess }
                .map { _ in 1 }
                .subscribe(o)
            _ = vc.rx.didUpdateFocus(match: .isDescendantOf(next: subviewOfsubview))
                .filter { $0.isSuccess }
                .map { _ in 2 }
                .subscribe(o)
        }
        scheduler.scheduleAt(200) {
            vc.triggerDidUpdateFocus(with: TestableFocusUpdateContext(nextFocusedView: subview))
        }
        scheduler.start()
        XCTAssertEqual(o.events, [next(200, 1)])
    }
}

// MARK: - Helper
extension UIFocusEnvironment {
    func triggerDidUpdateFocus(with context: UIFocusUpdateContext = .init()) {
        let coordinator = UIFocusAnimationCoordinator()
        self.perform(#selector(UIFocusEnvironment.didUpdateFocus(in:with:)), with: context, with: coordinator)
    }
}
