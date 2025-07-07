//
//  OmokakeApp.swift
//  Omokake
//
//  Created by takedatakashiki on 2025/07/04.
//

import SwiftUI
import OmokakeWindowApp
import OmokakeSpaceApp

@main
struct OmokakeApp: App {
    #if os(iOS) || os(macOS)
    var body: some Scene {
        WindowGroup {
            OmokakeWindowApp.main
        }
    }
    #endif
    #if os(visionOS)
    var body: some Scene {
        WindowGroup {
            OmokakeSpaceApp.main
        }
    }
    #endif
}
