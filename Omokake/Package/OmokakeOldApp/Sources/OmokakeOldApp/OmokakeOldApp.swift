// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// 旧Omokake
public enum OmokakeOldApp {
    public static var main: some View {
        OmokakeOldAppScreen()
    }
}

private struct OmokakeOldAppScreen: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        TitleViewController.makeViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
