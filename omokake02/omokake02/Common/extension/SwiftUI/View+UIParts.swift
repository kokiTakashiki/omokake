//
//  View+UIParts.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func description(
        _ content: LocalizedStringKey,
        edge: Edge = .leading,
        isFixedSizeHorizontal: Bool = false,
        isLeadingSpace: Bool = true,
        isTrailingSpace: Bool = true
    ) -> some View {
        HStack {
            if isLeadingSpace {
                Rectangle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.clear)
            }
            switch edge {
            case .leading:
                Text(content)
                    .fixedSize(horizontal: isFixedSizeHorizontal, vertical: !isFixedSizeHorizontal)
                    .font(.custom("Futura Medium", size: 18))
                Spacer()
            case .trailing:
                Spacer()
                Text(content)
                    .fixedSize(horizontal: isFixedSizeHorizontal, vertical: !isFixedSizeHorizontal)
                    .font(.custom("Futura Medium", size: 18))
            case .top:
                EmptyView()
            case .bottom:
                EmptyView()
            }
            if isTrailingSpace {
                Rectangle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.clear)
            }
        }
    }

    func iconSideDescription(systemName: String, _ content: LocalizedStringKey) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            Image(systemName: systemName)
            Text(content)
                .font(.custom("Futura Medium", size: 18))
            Spacer()
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
        }
    }

    func imageSideDescription(name: String, _ content: LocalizedStringKey) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width / 3)
            Rectangle()
                .frame(width: 10, height: 20)
                .foregroundColor(.clear)
            Text(content)
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom("Futura Medium", size: 18))
            Spacer()
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
        }
    }

    func title(_ content: LocalizedStringKey) -> some View {
        HStack {
            Rectangle()
                .frame(width: 20, height: 20)
                .foregroundColor(.clear)
            Text(content)
                .fixedSize(horizontal: false, vertical: true)
                .font(.custom("Futura Medium", size: 30))
            Spacer()
        }
    }

    var waku: some View {
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
