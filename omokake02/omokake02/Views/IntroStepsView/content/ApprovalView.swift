//
//  ApprovalView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct ApprovalView: View {
    @EnvironmentObject var environment: IntroStepsEnvironmentObject
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        VStack {
            if environment.showingIndicator {
                ActivityIndicator()
            }
            title("AccessData")
            description("AccessDataDescription")
            Button(action: {
                action()
            }, label: {
                Image("settingButton")
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
            })
        }
        .padding(.leading, 5.0)
        .padding(.trailing, 5.0)
    }
}

struct ApprovalView_Previews: PreviewProvider {
    static var previews: some View {
        ApprovalView(action: {})
            .environmentObject(IntroStepsEnvironmentObject())
    }
}
