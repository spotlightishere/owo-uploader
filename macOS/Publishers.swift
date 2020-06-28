//
//  Publishers.swift
//  macOS
//
//  Created by Spotlight Deveaux on 6/27/20.
//

import Combine
import Foundation


extension Publishers {
    // Under macOS, we don't have a virtual keyboard to adjust a view for.
    // As we run natively, we also do not have a UIApplication to receive content via.
    // Our padding for height will always be zero.
    // Empty publisher sourced via https://developer.apple.com/forums/thread/133397?answerId=421484022#421484022
    static var keyboardHeight: AnyPublisher<CGFloat, Never> = Empty(completeImmediately: false).eraseToAnyPublisher()
}
