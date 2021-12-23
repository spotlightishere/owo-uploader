//
//  ContentView.swift
//  Shared
//
//  Created by Spotlight Deveaux on 2020-06-29.
//

import Combine
import SwiftUI

struct LoginView: View {
    @State private var keyboardHeight: CGFloat = 0
    @State private var enteredToken = ""
    
    @State private var isLoggingIn = false
    @State private var errorDescription = ""
    @EnvironmentObject var loginState: LoginManager

    var body: some View {
        VStack {
            #if os(macOS)
                let appImage = Image(nsImage: NSImage(imageLiteralResourceName: NSImage.applicationIconName))
            #else
                let appImage = Image(uiImage: Bundle.main.icon!)
            #endif
            appImage
                .resizable()
                .frame(width: 142.0, height: 142.0)
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

                SecureField("Token", text: $enteredToken)
                    .textFieldStyle(PlainTextFieldStyle())
                    .textContentType(.password)
                    .frame(idealWidth: 100.0, maxWidth: 200.0)
                    .font(.caption)
                    .disabled(isLoggingIn)
                    .onSubmit(handleLogin)
                    .submitLabel(.done)
            }.frame(minHeight: 35.0, maxHeight: 35.0)
                // Create a border around the previous two elements.
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, -15)
                    .padding(.vertical, -3)
                ).padding(.horizontal, 20)
                .padding(.vertical, 25.0)

            if isLoggingIn {
                ProgressView()
                    .opacity(1)
            } else {
                Button("Sign In...", action: handleLogin).disabled(enteredToken == "")
                #if os(iOS)
                    // We'd prefer to have a larger sign in button where possible.
                    .font(.title3)
                #endif
            }

            Text(errorDescription)
                .foregroundColor(Color.red)
        }.padding(.bottom, keyboardHeight)
            // Modify upon keyboard height being sent
            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0
            }
            .animation(.easeOut, value: 15.0)
            .padding(.horizontal, 15.0)
        #if os(macOS)
            .frame(width: maxFrameWidth, height: maxFrameHeight)
        #endif
            .onAppear {
                isLoggingIn = true
                Task {
                    do {
                        try await loginState.loginFromKeychain()
                    } catch AuthError.noCredentials {
                        // If we do not have credentials, we do not need to do anything.
                    } catch (let e) {
                        errorDescription = e.localizedDescription
                    }
                }
                isLoggingIn = false
            }
    }

    func handleLogin() {
        Task {
            isLoggingIn = true
            do {
                try await loginState.login(with: enteredToken)
            } catch (let e) {
                errorDescription = e.localizedDescription
            }
            isLoggingIn = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
                .environmentObject(LoginManager())

            LoginView()
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
                .environmentObject(LoginManager())
        }
    }
}
