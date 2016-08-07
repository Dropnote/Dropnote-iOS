import Foundation
import UIKit
import RxSwift
import RxCocoa

final class KeyboardManager {
    private let disposeBag = DisposeBag()
    
    var keyboardInfoChange: Observable<KeyboardInfo> {
        return keyboardInfoChangeSubject.asObservable()
    }
    private let keyboardInfoChangeSubject: PublishSubject<KeyboardInfo>
    
    init() {
        keyboardInfoChangeSubject = PublishSubject()
        
        let center = NSNotificationCenter.defaultCenter()
        center.rx_notification(UIKeyboardWillShowNotification).map(keyboardWillShowNotification)
            .subscribe(keyboardInfoChangeSubject).addDisposableTo(disposeBag)
        center.rx_notification(UIKeyboardDidShowNotification).map(keyboardDidShowNotification)
            .subscribe(keyboardInfoChangeSubject).addDisposableTo(disposeBag)
        center.rx_notification(UIKeyboardWillHideNotification).map(keyboardWillHideNotification)
            .subscribe(keyboardInfoChangeSubject).addDisposableTo(disposeBag)
        center.rx_notification(UIKeyboardDidHideNotification).map(keyboardDidHideNotification)
            .subscribe(keyboardInfoChangeSubject).addDisposableTo(disposeBag)
    }
    
    private func keyboardWillShowNotification(notification: NSNotification) -> KeyboardInfo {
        return KeyboardInfo.fromNotificationUserInfo(notification.userInfo, state: .WillShow)
    }
    
    private func keyboardDidShowNotification(notification: NSNotification) -> KeyboardInfo {
        return KeyboardInfo.fromNotificationUserInfo(notification.userInfo, state: .Visible)
    }
    
    private func keyboardWillHideNotification(notification: NSNotification) -> KeyboardInfo {
        return KeyboardInfo.fromNotificationUserInfo(notification.userInfo, state: .WillHide)
    }
    
    private func keyboardDidHideNotification(notification: NSNotification) -> KeyboardInfo {
        return KeyboardInfo.fromNotificationUserInfo(notification.userInfo, state: .Hidden)
    }
}

enum KeyboardState {
    case Hidden
    case WillShow
    case Visible
    case WillHide
}

extension KeyboardState: CustomStringConvertible {
    var description: String {
        switch self {
        case .Hidden: return "Hidden"
        case .WillHide: return "WillHide"
        case .WillShow: return "WillShow"
        case .Visible: return "Visible"
        }
    }
}

struct KeyboardInfo {
    let state: KeyboardState
    let beginFrame: CGRect
    let endFrame: CGRect
    let animationCurve: UIViewAnimationCurve
    let animationDuration: NSTimeInterval

    var animationOptions: UIViewAnimationOptions {
        switch animationCurve {
        case .EaseInOut: return UIViewAnimationOptions.CurveEaseInOut
        case .EaseIn: return UIViewAnimationOptions.CurveEaseIn
        case .EaseOut: return UIViewAnimationOptions.CurveEaseOut
        case .Linear: return UIViewAnimationOptions.CurveLinear
        }
    }
    
    static func fromNotificationUserInfo(info: [NSObject : AnyObject]?, state: KeyboardState) -> KeyboardInfo {
        var beginFrame = CGRect.zero
        info?[UIKeyboardFrameBeginUserInfoKey]?.getValue(&beginFrame)
        
        var endFrame = CGRect.zero
        info?[UIKeyboardFrameEndUserInfoKey]?.getValue(&endFrame)
        
        let curve = UIViewAnimationCurve(rawValue: info?[UIKeyboardAnimationCurveUserInfoKey] as? Int ?? 0) ?? .EaseInOut
        let duration = NSTimeInterval(info?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.0)
        return KeyboardInfo(state: state, beginFrame: beginFrame, endFrame: endFrame, animationCurve: curve, animationDuration: duration)
    }
}
