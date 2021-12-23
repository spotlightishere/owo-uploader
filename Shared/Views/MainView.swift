//
//  MainView.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2020-06-29.
//

import OwoKit
import SwiftUI

struct MainView: View {
    @EnvironmentObject var loginState: LoginManager
    @State var objects: [Object] = []
    var columns: [GridItem] =
            Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(objects, id: \.self) { object in
                    FileThumbnail(object: object)
                }
            }.font(.largeTitle)
        }.toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    // todo
                }) {
                    Label("Upload", systemImage: "square.and.arrow.up")
                }
            }
        }

        #if os(macOS)
        .frame(width: maxFrameWidth, height: maxFrameHeight)
        #endif
        
        .onAppear {
            Task {
                do {
                    let test = try await loginState.api.getObjects()
                    self.objects = test.objects
                } catch (let e) {
                    print(e)
                }
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
