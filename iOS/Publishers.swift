//
//  Observers.swift
//  iOS
//
//  Created by Spotlight Deveaux on 2020-06-29.
//

import Combine
import Foundation
import UIKit

extension Publishers {
    // Adopt keyboard height via system notification
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let keyboardShowing = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { published in published.keyboardHeight }

        let keyboardHiding = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return MergeMany(keyboardShowing, keyboardHiding)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}
