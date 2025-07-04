// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public enum OmokakeWindowApp {
    public static var main: some View {
        if #available(iOS 26.0, *) {
            ContentView()
        } else {
            fatalError("サポート対象外です")
        }
    }
}
