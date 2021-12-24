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

    var body: some View {
        VStack {
            AsyncImage(url: object.thumbnailURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 200)
                    .padding()
            } placeholder: {
                ProgressView()
                    .padding()
            }
            Text(object.filename)
                .font(.caption2)
        }.padding()
    }
}
