//
//  MultiStepsView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct MultiStepsView<T, Content: View> : View where T: Swift.CaseIterable {
    @Binding var steps: [T]
    let extraContent : [String]?
    let extraContentPosition : ExtraContentPosition?
    let extraContentSize : CGSize?
    let action : (Int) -> Void
    @ViewBuilder let content: () -> Content
    
    @State var numberOfSteps : Int = 0
    @State var widthOfLastItem = 0.0
    @State var images : [UIImage] = []
    
    private let accentColor = Color("main", bundle: .module)
    
    @ViewBuilder
    var body: some View {
        VStack {
            HStack {
                ForEach(0 ..< numberOfSteps, id: \.self) { index in
                    if #available(iOS 15.0, *) {
                        itemView(index)
                    } else {
                        // Fallback on earlier versions
                        itemViewFor_iOS13later(index)
                    }
                }
            }
        }.onAppear() {
            numberOfSteps = type(of: steps).Element.self.allCases.count
        }
    }
}

extension MultiStepsView {
    @available(iOS 15.0, *)
    @ViewBuilder
    private func itemView(_ index: Int) -> some View {
        ZStack {
            HStack(spacing: 0) {
                VStack {
                    if let extraContent = extraContent, extraContentPosition == .above {
                        ExtraStepContent(index: index, color: index < steps.count ? accentColor :.gray, extraContent: extraContent, extraContentSize: extraContentSize)
                    }
                    content().foregroundColor(index < steps.count ? accentColor :.gray)
                }
                if let extraContent = extraContent, extraContentPosition == .inline {
                    ExtraStepContent(index: index, color: index < steps.count ? accentColor :.gray, extraContent: extraContent, extraContentSize: extraContentSize)
                }
            }
        }
        .overlay {
            if let extraContent = extraContent, extraContentPosition == .onTop , index < steps.count {
                ExtraStepContent(index: index, color: accentColor, extraContent: extraContent, extraContentSize: extraContentSize)
            }
        }
        .onTapGesture {
            action(index)
        }
    }

    @ViewBuilder
    private func itemViewFor_iOS13later(_ index: Int) -> some View {
        ZStack {
            HStack(spacing: 0) {
                VStack {
                    if let extraContent = extraContent, extraContentPosition == .above {
                        ExtraStepContent(index: index, color: index < steps.count ? accentColor :.gray, extraContent: extraContent, extraContentSize: extraContentSize)
                    }
                    content().foregroundColor(index < steps.count ? accentColor :.gray)
                }
                if let extraContent = extraContent, extraContentPosition == .inline {
                    ExtraStepContent(index: index, color: index < steps.count ? accentColor :.gray, extraContent: extraContent, extraContentSize: extraContentSize)
                }
            }
        }
        .overlay(itemViewOverlayFor_iOS13later(index), alignment: .center)
        .onTapGesture {
            action(index)
        }
    }

    @ViewBuilder
    private func itemViewOverlayFor_iOS13later(_ index: Int) -> some View {
        if let extraContent = extraContent, extraContentPosition == .onTop , index < steps.count {
            ExtraStepContent(index: index, color: accentColor, extraContent: extraContent, extraContentSize: extraContentSize)
        }
    }
}
