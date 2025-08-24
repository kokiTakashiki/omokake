//
//  ContentView.swift
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/07/05.
//

import OmokakeResources
import SwiftUI

@available(iOS 26.0, macOS 26.0, *)
struct ContentView: View {
    @State private var selectedSegment = 0
    @State private var isPresentedAbout = false
    @State private var isPresentedKakeraSetting = false

    var body: some View {
        NavigationView {
            KakerasViewControllerRepresentable()
                .ignoresSafeArea()
                .toolbar {
                    topBarItems()
                    bottomBarItems()
                }
        }
        .sheet(isPresented: $isPresentedAbout) {
            AboutView()
                .presentationDetents([.medium])
        }
        .sheet(isPresented: $isPresentedKakeraSetting) {
            KakeraSettingView()
                .presentationDetents([.medium])
        }
    }

    @ToolbarContentBuilder
    private func topBarItems() -> some ToolbarContent {
        #if os(iOS)
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    isPresentedAbout = true
                }) {
                    Image(systemName: "questionmark")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink("Share URL", item: URL(string: "https://developer.apple.com/xcode/swiftui/")!)
            }
        #elseif os(macOS)
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    isPresentedAbout = true
                }) {
                    Image(systemName: "questionmark")
                }
            }
        #endif
    }

    @ToolbarContentBuilder
    private func bottomBarItems() -> some ToolbarContent {
        #if os(iOS)
            ToolbarItem(placement: .bottomBar) {
                Button(action: {
                    // 検索アクション
                }) {
                    Image(systemName: "arrow.up.backward.and.arrow.down.forward")
                }
            }
        #elseif os(macOS)
        #endif
        ToolbarItemGroup(placement: .status) {
            Picker("Options", selection: $selectedSegment) {
                Image(
                    OmokakeResources.ImageResource.kakeraIconTemplate.rawValue,
                    bundle: OmokakeResources.bundle
                )
                .tag(0)
                Image(systemName: "photo.on.rectangle.angled")
                    .tag(1)
            }
            .frame(width: 150)
            .pickerStyle(.segmented)
            Button(action: {
                isPresentedKakeraSetting = true
            }) {
                Image(systemName: "slider.horizontal.3")
            }
        }
        ToolbarSpacer()
    }
}

#Preview {
    if #available(iOS 26.0, macOS 26.0, *) {
        ContentView()
            .preferredColorScheme(.dark)
    } else {
        // Fallback on earlier versions
    }
}
