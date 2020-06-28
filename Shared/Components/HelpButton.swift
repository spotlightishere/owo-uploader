//
//  HelpButton.swift
//  NSBezelStyleHelpButton-like help button for all platforms.
//
//  Created by Spotlight Deveaux on 6/27/20.
//

import SwiftUI

struct HelpButton: View {
    var body: some View {
        Button(action: {}) {
            Image(systemName: "questionmark.circle")
                .foregroundColor(.white)
                .font(.title3)
                .padding()
        }
        .background(Circle()
            .fill(Color.secondary)
            .padding(.all, 10.0))
        .buttonStyle(PlainButtonStyle())
    }
}

struct HelpButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            TextField("Give me content.", text: .constant(""))
            HelpButton()
        }
    }
}
