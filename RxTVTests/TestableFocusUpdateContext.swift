//
//  TestableFocusUpdateContext.swift
//  RxTVTests
//
//  Created by Toshihiro Suzuki on 2017/11/26.
//  Copyright © 2017 toshi0383. All rights reserved.
//

import UIKit

final class TestableFocusUpdateContext: UIFocusUpdateContext {
    private let _nextFocusedView: UIView?
    private let _previouslyFocusedView: UIView?
    init(nextFocusedView: UIView? = nil, previouslyFocusedView: UIView? = nil) {
        self._nextFocusedView = nextFocusedView
        self._previouslyFocusedView = previouslyFocusedView
    }
    // MARK: Overrides
    override var nextFocusedView: UIView? {
        return _nextFocusedView
    }
    override var previouslyFocusedView: UIView? {
        return _previouslyFocusedView
    }
}
