//
//  View+UIParts.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

extension View {
    /// **Displays** a description text with customizable alignment and spacing.
    ///
    /// - Parameters:
    ///   - content: The localized string key for the description text.
    ///   - edge: The edge alignment for the text (default: .leading).
    ///   - isFixedSizeHorizontal: Whether to fix the horizontal size (default: false).
    ///   - isLeadingSpace: Whether to include leading space (default: true).
    ///   - isTrailingSpace: Whether to include trailing space (default: true).
    /// - Returns: A view with the description text and specified layout.
    @ViewBuilder
    func describedText(
        _ content: String,
        alignedTo edge: Edge = .leading,
        isFixedSizeHorizontal: Bool = false,
        hasLeadingSpace: Bool = true,
        hasTrailingSpace: Bool = true
    ) -> some View {
        HStack {
            if hasLeadingSpace {
                Rectangle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.clear)
            }
            switch edge {
            case .leading:
                    Text(content.localized())
                    .fixedSize(horizontal: isFixedSizeHorizontal, vertical: !isFixedSizeHorizontal)
                    .font(.makeFuturaMedium(size: 18))
                Spacer()
            case .trailing:
                Spacer()
                    Text(content.localized())
                    .fixedSize(horizontal: isFixedSizeHorizontal, vertical: !isFixedSizeHorizontal)
                    .font(.makeFuturaMedium(size: 18))
            case .top:
                EmptyView()
            case .bottom:
                EmptyView()
            }
            if hasTrailingSpace {
                Rectangle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.clear)
            }
        }
    }

    /// **Displays** a description with a system icon on the side.
    ///
    /// - Parameters:
    ///   - systemName: The name of the system icon.
    ///   - content: The localized string key for the description text.
    /// - Returns: A view with an icon and description text.
    func describedTextWithIcon(
        systemName: String,
        _ content: String
    ) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            Image(systemName: systemName)
            Text(content.localized())
                .font(.makeFuturaMedium(size: 18))
            Spacer()
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
        }
    }

    /// **Displays** a description with an image on the side.
    ///
    /// - Parameters:
    ///   - imageName: The name of the image.
    ///   - content: The localized string key for the description text.
    /// - Returns: A view with an image and description text.
    func describedTextWithImage(
        imageName: String,
        _ content: String
    ) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            Image(imageName, bundle: .module)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 3)
            Rectangle()
                .frame(width: 10, height: 20)
                .foregroundColor(.clear)
            Text(content.localized())
                .fixedSize(horizontal: false, vertical: true)
                .font(.makeFuturaMedium(size: 18))
            Spacer()
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
        }
    }

    /// **Displays** a title text.
    ///
    /// - Parameter content: The localized string key for the title.
    /// - Returns: A view with styled title text.
    func titleText(_ content: String) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            Text(content.localized())
                .fixedSize(horizontal: false, vertical: true)
                .font(.makeFuturaMedium(size: 30))
            Spacer()
        }
    }

    /// **A decorative frame** with rounded rectangle border styling.
    var decorativeFrame: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
            RoundedRectangle(cornerRadius: 30)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.black)
                .padding(.top, 3)
                .padding(.leading, 3)
                .padding(.trailing, 3)
                .padding(.bottom, 3)
        }
    }
}

extension String {
    func localized() -> String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }
}
