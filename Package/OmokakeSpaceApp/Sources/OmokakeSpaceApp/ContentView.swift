//
//  ContentView.swift
//  OmokakeSpaceApp
//
//  Created by takedatakashiki on 2025/07/07.
//

import SwiftUI

#if os(visionOS)
    struct ContentView: View {
        var body: some View {
            Text("Hello, World!")
                .foregroundStyle(.tint)
        }
    }

    #Preview {
        ContentView()
    }
#endif
