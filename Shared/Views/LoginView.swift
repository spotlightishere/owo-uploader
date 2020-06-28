//
//  ContentView.swift
//  Shared
//
//  Created by Spotlight Deveaux on 6/26/20.
//

import Combine
import SwiftUI

struct LoginView: View {
    @State private var token = ""
    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        let stack = VStack {
            Spacer()

            Text("OwO Uploader")
                // TODO: Investigate accessibility
                .font(Font.system(size: 48))
                .fontWeight(.bold)

            Text("Enter your OwO Beta account token.")
                .multilineTextAlignment(.center)
                // TODO: Is 4.0 a decent padding for _all_ sides?
                .padding(.top, 4.0)
                .padding(.bottom, 25.0)

            Spacer()

            VStack {
                HStack {
                    Text("Token")
                        .padding(.horizontal, 10.0)
                        .font(.subheadline)
                    TextField("required", text: .constant(""))
                        .frame(height: 35.0)
                        .textFieldStyle(PlainTextFieldStyle())
                        .background(Color.clear)
                        .textContentType(.username)
                }.overlay(RoundedRectangle(cornerRadius: 3.0)
                    .stroke(Color.secondary))

                Button(action: {}) {
                    HStack {
                        Spacer()
                        Text("Login")
                        Spacer()
                    }
                }.buttonStyle(ProminentButtonStyle())
            }.frame(maxWidth: 300.0, maxHeight: 200.0)

            // Adjust off from bottom - 2:3rds
            Spacer()
            Spacer()
        }.padding(.bottom, keyboardHeight)
            // Modify upon keyboard height being sent
            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
            .animation(.easeOut(duration: 0.15))
            .padding(.horizontal, 15.0)

        // Under macOS, we want the window to be a proper size.
        #if os(macOS)
            return stack.frame(minWidth: 700.0, maxWidth: .infinity, minHeight: 450.0, maxHeight: .infinity)
        #else
            return stack
        #endif
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)

            LoginView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
