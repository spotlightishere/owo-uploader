//
//  FileThumbnail.swift
//  Components
//
//  Created by Spotlight Deveaux on 2021-12-23.
//

import OwoKit
import SwiftUI

struct FileThumbnail: View {
    let object: Object
    @State var showingError: Bool = false

    var body: some View {
        VStack {
            AsyncImage(
                url: object.thumbnailURL,
                transaction: Transaction(animation: .easeIn)
            ) { phase in
                switch phase {
                case let .success(thumbnail):
                    thumbnail
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .padding()
                case let .failure(e):
                    Image(systemName: "exclamationmark.triangle.fill")
                        .popover(isPresented: $showingError) {
                            VStack {
                                Text("An error ocurred:")
                                    .font(.body)
                                Text(e.localizedDescription)
                                    .font(.body)
                                    .foregroundColor(Color.red)
                            }.padding()
                        }
                        .onHover { _ in
                            showingError = true
                        }
                        .onTapGesture {
                            showingError = true
                        }
                case .empty:
                    Image(systemName: "photo")
                @unknown default:
                    Image(systemName: "photo")
                }
            }
            Text(object.filename)
                .font(.caption2)
        }.padding()
    }
}
