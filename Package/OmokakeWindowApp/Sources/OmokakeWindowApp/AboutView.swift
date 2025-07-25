//
//  AboutView.swift
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/07/25.
//

import Foundation
import OmokakeResources
import SwiftUI

@available(iOS 26.0, macOS 26.0, *)
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                // アプリ情報セクション
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            Image(
                                OmokakeResources.ImageResource.appIcon.rawValue,
                                bundle: OmokakeResources.bundle
                            )
                            .resizable()
                            .frame(width: 64, height: 64)
                            .cornerRadius(12)

                            Text("Omokake")
                                .font(.title2)
                                .fontWeight(.medium)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }

                // Creditセクション
                Section("Credit") {
                    InfoRow(title: "Developing by", value: "Koki Takeda")
                    InfoRow(title: "Icon Design", value: "Ayana Takeda")
                    InfoRow(title: "Special Thanks", value: "Harumi Sagawa")

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Third Party Libraries")
                            .font(.body)
                            .foregroundColor(.primary)

                        VStack(alignment: .leading, spacing: 2) {
                            Link("SND", destination: URL(string: "https://snd.dev/")!)
                                .font(.caption)
                                .foregroundColor(.blue)

                            Link("DeviceKit", destination: URL(string: "https://github.com/devicekit/DeviceKit")!)
                                .font(.caption)
                                .foregroundColor(.blue)

                            Link(
                                "Animation Sequence",
                                destination: URL(string: "https://github.com/cristhianleonli/AnimationSequenc")!
                            )
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical, 2)
                }

                // Contactセクション
                Section("Contact") {
                    HStack {
                        Text("X")
                            .font(.body)
                            .foregroundColor(.primary)

                        Spacer()

                        Link("@bluewhitered123", destination: URL(string: "https://x.com/bluewhitered123")!)
                            .font(.body)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

@available(iOS 26.0, macOS 26.0, *)
struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    if #available(iOS 26.0, macOS 26.0, *) {
        AboutView()
            .preferredColorScheme(.dark)
    } else {
        // Fallback on earlier versions
    }
}
