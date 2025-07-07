//
//  DeniedView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct DeniedView: View {
    private let action: () -> Void

    init(action: @escaping () -> Void) {
        self.action = action
    }

    var body: some View {
        VStack {
            Image(systemName: "x.circle.fill")
                .resizable()
                .foregroundColor(.red)
                .frame(width: 40.0, height: 40.0)
            titleText("FailedToAcquireData")
            describedText("FailedToAcquireDataDescription")
            Button(action: {
                action()
            }, label: {
                Image("settingButton", bundle: .module)
                    .resizable()
                    .frame(width: 100.0, height: 100.0)
            })
        }
        .padding(.leading, 5.0)
        .padding(.trailing, 5.0)
    }
}

struct DeniedView_Previews: PreviewProvider {
    static var previews: some View {
        DeniedView(action: {})
    }
}
