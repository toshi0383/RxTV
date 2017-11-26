//
//  UIFocusEnvironment+Rx.swift
//  RxTV
//
//  Created by Toshihiro Suzuki on 2017/11/26.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

public final class Match {
    private let matchBlock: (UIFocusUpdateContext) -> Bool
    private init(matchBlock: @escaping (UIFocusUpdateContext) -> Bool) {
        self.matchBlock = matchBlock
    }
    func match(_ context: UIFocusUpdateContext) -> Bool {
        return matchBlock(context)
    }
    public static func isDescendantOf(next nextParent: UIView?) -> Match {
        return Match { context in
            guard let nextParent = nextParent else {
                return false
            }
            guard let next = context.nextFocusedView,
                next.isDescendant(of: nextParent) else {
                    return false
            }
            return true
        }
    }
    public static func isDescendantOf(next nextParent: UIView?, previous previousParent: UIView?) -> Match {
        return Match { context in
            guard let nextParent = nextParent, let previousParent = previousParent else {
                return false
            }
            guard let (next, previous) = context.rx.focusedViews,
                next.isDescendant(of: nextParent) && previous.isDescendant(of: previousParent) else {
                    return false
            }
            return true
        }
    }
    public static func resignDescendant(of parent: UIView?) -> Match {
        return Match { context in
            guard let parent = parent else { return false }
            guard let (next, previous) = context.rx.focusedViews,
                !next.isDescendant(of: parent), previous.isDescendant(of: parent) else {
                    return false
            }
            return true
        }
    }
    public static func isTypeOf<T>(next: T.Type) -> Match {
        return Match { context in
            guard let nextFocusedView = context.nextFocusedView,
                nextFocusedView is T else {
                    return false
            }
            return true
        }
    }
}
public enum MatchResult {
    case success(UIFocusAnimationCoordinator)
    case failure(UIFocusAnimationCoordinator)
    public var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }
    public var coordinator: UIFocusAnimationCoordinator {
        switch self {
        case .success(let c): return c
        case .failure(let c): return c
        }
    }
}

extension Reactive where Base: ReactiveCompatible & UIFocusEnvironment {
    public var didUpdateFocus: Observable<(UIFocusUpdateContext, UIFocusAnimationCoordinator)> {
        return base.rx.sentMessage(#selector(UIFocusEnvironment.didUpdateFocus(in:with:)))
            .flatMap { a -> Observable<(UIFocusUpdateContext, UIFocusAnimationCoordinator)> in
                guard let context = a[0] as? UIFocusUpdateContext, let coordinator = a[1] as? UIFocusAnimationCoordinator else {
                    return .empty()
                }
                return .of((context, coordinator))
        }
    }

    /// Emits UIFocusAnimationCoordinator parameter when next and previously focused views match condition.
    /// - parameter match: Match object
    /// - returns: Observable of UIFocusAnimationCoordinator
    /// - Note: Don't subscribe UIFocusAnimationCoordinator event asynchronously.
    ///       `addCoordinatedAnimations` will be ignored unless it happens synchronously.
    ///       e.g.
    ///
    ///       ```
    ///       didUpdateFocus(match: .resignDescendantOf(view1))
    ///           .subscribe { $0.addCoordinatedAnimations... } // works as expected
    ///       didUpdateFocus(match: .resignDescendantOf(view1))
    ///           .delay(1, scheduler: MainScheduler.instance)
    ///           .subscribe { $0.addCoordinatedAnimations... } // added animations are ignored
    ///       ```
    public func didUpdateFocus(match: Match) -> Observable<MatchResult> {
        return didUpdateFocus
            .flatMap {
                return match.match($0.0) ? Observable<MatchResult>.of(.success($0.1)) : .of(.failure($0.1))
            }
    }
}

extension Reactive where Base: UIFocusUpdateContext {
    /// Returns next and previously focused views.
    /// - note: Returned tuple will be non-nil iff both next and previously focused views are non-nil.
    ///       Use this extension when you want to ignore either (nil, view) or (view, nil).
    public var focusedViews: (UIView, UIView)? {
        guard let next = base.nextFocusedView, let previous = base.previouslyFocusedView else {
            return nil
        }
        return (next, previous)
    }
}
