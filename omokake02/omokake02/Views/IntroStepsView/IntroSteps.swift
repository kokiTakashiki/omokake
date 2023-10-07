//
//  IntroSteps.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI
import UIKit

struct IntroSteps: View {
    @EnvironmentObject var environmentObject: IntroStepsEnvironmentObject
    
    var body: some View {
        VStack {
            // MULTI-STEPS View
            MultiStepsView(
                steps: $environmentObject.status,
                extraContent: IntroStepsState.allValues,
                extraContentPosition: .above,
                extraContentSize: CGSize(width: 30, height: 30),
                action: {_ in }
            ) {
                RoundedRectangle(cornerRadius: 5).frame(height: 10)
            }
            .padding()
            .font(.title)
            
            Spacer()

            if environmentObject.photoAccessState == .none ||
                environmentObject.photoAccessState == .Authorized
            {
                content()
                Spacer()
                bottomButton
            } else {
                DeniedView() {
                    Task { @MainActor in
                        await environmentObject.deniedViewAction()
                    }
                }
                Spacer()
                bottomBackButton
            }
        }
        .padding(.bottom, 10.0)
    }
}

// MARK: UIParts
extension IntroSteps {

    @ViewBuilder
    private func content() -> some View {
        // STEP VIEW - CONDITIONAL
        switch environmentObject.currentStatus {
        case .infoOmokake:
            InfoOmokakeView()
        case .approval:
            ApprovalView() {
                Task { @MainActor in
                    await environmentObject.approvalViewAction()
                }
            }
            .environmentObject(environmentObject)
        case .complete:
            CompleteView()
        case .howToUse:
            HowToUseView()
        }
    }

    private var bottomButton: some View {
        // BOTTOM BUTTONS
        HStack {
            Button(action: {
                Task { @MainActor in
                    await environmentObject.bottomButtonAction()
                }
            }, label: {
                HStack {
                    Image(systemName: "arrow.right.circle")
                    Text("Next")
                        .font(.custom("Futura Medium", size: 20))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.0, green: 0.6, blue: 0.0))
                        .frame(height: 40.0)
                )
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 40.0)
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    private var bottomBackButton: some View {
        HStack {
            Button(action: {
                Task { @MainActor in
                    await environmentObject.bottomBackButtonAction()
                }
            }, label: {
                HStack {
                    Image(systemName: "arrow.left.circle")
                    Text("Back")
                        .font(.custom("Futura Medium", size: 20))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.0, green: 0.6, blue: 0.0))
                        .frame(height: 40.0)
                )
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(height: 40.0)
        .buttonStyle(.plain)
        .padding(.horizontal)
    }
}

struct IntroSteps_Previews: PreviewProvider {
    static var previews: some View {
        let localizationIds = ["en", "ja"]

        ForEach(localizationIds, id: \.self) { id in

            IntroSteps()
                .environmentObject(IntroStepsEnvironmentObject())
                .previewDisplayName("Localized - \(id)")
                .environment(\.locale, .init(identifier: id))
        }
    }
}
