//
//  ContentView.swift
//  Shared
//
//  Created by Spotlight Deveaux on 6/26/20.
//

import Combine
import SwiftUI

struct LoginView: View {
    @State private var keyboardHeight: CGFloat = 0
    @State private var enteredToken: String = ""
    @EnvironmentObject var loginState: LoginState
    
    
    var body: some View {
        let stack = VStack {
            #if os(macOS)
            let appIcon = Image(nsImage: NSImage(imageLiteralResourceName: NSImage.applicationIconName))
            #else
            // If changed, please update this image asset as well!
            let appIcon = Image("SwiftUIAccessibleAppIcon")
            #endif
            
            appIcon
                .resizable()
                .frame(width: 142.0, height: 142.0)
                // TODO: remove once like, literally everything else is implemented
                .scaledToFit()
                .cornerRadius(15.0)
                .padding(.top, 23.0)
            
            Text(verbatim: "OwO Beta")
                .font(.custom(".AppleSystemUIFontDemi", size: 36.0))
            
            Text("Sign in with your OwO Beta account token.")
                .multilineTextAlignment(.center)
                .padding(.top, 1)
                .frame(maxWidth: 500)
            
            HStack {
                Text("Account Token")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .padding(.trailing, 15.0)
                
                SecureField("Token", text: $enteredToken, onCommit: {
                    if enteredToken != "" {
                        loginState.login(with: enteredToken)
                    }
                })
                .textFieldStyle(PlainTextFieldStyle())
                .textContentType(.password)
                .frame(idealWidth: 100.0, maxWidth: 200.0)
                .font(.caption)
                .disabled(loginState.isLoggingIn)
            }.frame(minHeight: 35.0, maxHeight: 35.0)
            // Create a border around the previous two elements.
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 0.5)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, -15)
                        .padding(.vertical, -3)
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 25.0)
            
            
            if (loginState.isLoggingIn) {
                ProgressView()
                    .opacity(loginState.isLoggingIn ? 1 : 0)
            } else {
                let signIn = Button("Sign In...", action: {
                    loginState.login(with: enteredToken)
                }).disabled(enteredToken == "")
                
                
                #if os(iOS)
                // We'd prefer to have a larger sign in button where possible.
                signIn.font(.title3)
                #else
                signIn
                #endif
            }
            
            Text(loginState.failureReason)
                .foregroundColor(Color.red)
        }.padding(.bottom, keyboardHeight)
        // Modify upon keyboard height being sent
        .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
        .animation(.easeOut(duration: 0.15))
        .padding(.horizontal, 15.0)
        
        #if os(macOS)
        // Under macOS, we want the window to be a proper size.
        // TODO: 518 is adjusted from 546. Title bar size may vary.
        return stack.frame(width: 646.0, height: 518.0)
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
                .environmentObject(LoginState())
            
            LoginView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .environmentObject(LoginState())
        }
    }
}
