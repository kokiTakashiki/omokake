//
//  KakerasViewControllerRepresentable.swift
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/08/19.
//

import SwiftUI
#if os(iOS)
    import UIKit

    typealias PlatformViewControllerRepresentable = UIViewControllerRepresentable
#elseif os(macOS)
    import AppKit

    typealias PlatformViewControllerRepresentable = NSViewControllerRepresentable
#endif

@available(iOS 26.0, macOS 26.0, *)
struct KakerasViewControllerRepresentable: PlatformViewControllerRepresentable {
    #if os(iOS)
        func makeUIViewController(context: Context) -> KakerasViewController {
            KakerasViewController()
        }

        func updateUIViewController(_ uiViewController: KakerasViewController, context: Context) {}
    #elseif os(macOS)
        func makeNSViewController(context: Context) -> KakerasViewController {
            KakerasViewController()
        }

        func updateNSViewController(_ nsViewController: KakerasViewController, context: Context) {}
    #endif
}
