RxTV
---
Reactive Extension Pack for tvOS 📺

# Features
- `UIFocusEnvironment#rx.didUpdateFocus -> Observable<(UIFocusUpdateContext, UIFocusAnimationCoordinator)>`
- `UIFocusEnvironment#rx.didUpdateFocus(match:) -> Observable<MatchResult>`
- `UIView#rx.press(_:) -> Observable<Void>`
- `UITabBarController#rx.isTabBarHidden`
- `UISplitViewController#rx.isMasterViewHidden`

# Requirements
- tvOS9+
- Swift4+
- RxSwift

# Install
## Carthage
```Cartfile
github "toshi0383/RxTV"
```

# LICENSE
MIT
