// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

#if os(visionOS)
    /// visionOS向けのOmokake
    public enum OmokakeSpaceApp {
        public static var main: some View {
            ContentView()
        }
    }
#endif
