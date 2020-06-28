//
//  ProminentButton.swift
//  Visually similar to a button from OnBoardingKit.
//
//  Created by Spotlight Deveaux on 6/27/20.
//

import SwiftUI

// We don't want to show this style button when using macOS.
// The normal button style will use a button backed by AppKit.
#if os(macOS)
    typealias ProminentButtonStyle = DefaultButtonStyle
#else
    struct ProminentButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .padding()
                .background(Color.blue)
                .cornerRadius(15.0)
                .shadow(radius: 1.0)
                // Allows the button appear to be recessed.
                .foregroundColor(configuration.isPressed ? Color.gray : Color.white)
        }
    }
#endif

struct ProminentButton_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {}, label: {
            Text("Login")
        })
            .padding(.horizontal, 15.0)
            .buttonStyle(ProminentButtonStyle())
    }
}
