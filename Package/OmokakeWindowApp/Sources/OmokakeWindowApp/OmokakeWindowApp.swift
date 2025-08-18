// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// iOS, iPadOS, macOS向けのOmokake
public enum OmokakeWindowApp {
    public static var main: some View {
        if #available(iOS 26.0, macOS 26.0, *) {
            ContentView()
        } else {
            if #available(iOS 15, *) {
                fatalError(String(localized: "サポート対象外です"))
            } else {
                fatalError(Bundle.module.localizedString(forKey: "サポート対象外です", value: nil, table: nil))
            }
        }
    }
}
