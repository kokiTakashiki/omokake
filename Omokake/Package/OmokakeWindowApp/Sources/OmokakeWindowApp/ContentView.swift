//
//  File.swift
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/07/05.
//

import SwiftUI

@available(iOS 26.0, *)
struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .foregroundStyle(.tint)
    }
}

#Preview {
    if #available(iOS 26.0, *) {
        ContentView()
    } else {
        // Fallback on earlier versions
    }
}
