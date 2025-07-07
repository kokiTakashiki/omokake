//
//  OmokakeApp.swift
//  Omokake
//
//  Created by takedatakashiki on 2025/07/04.
//

import SwiftUI
import OmokakeWindowApp
import OmokakeSpaceApp
import OmokakeOldApp

@main
struct OmokakeApp: App {
    #if os(iOS) || os(macOS)
    var body: some Scene {
        WindowGroup {
            if #available(iOS 26.0, macOS 26.0, *) {
                OmokakeWindowApp.main
            } else {
                OmokakeOldApp.main
            }
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
