//
//  CompleteView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

struct CompleteView: View {
    var body: some View {
        VStack {
            titleText("DataAcquisitionComplete")
            describedText("DataAcquisitionCompleteDescription")
        }
        .padding(.leading, 5.0)
        .padding(.trailing, 5.0)
    }
}

struct CompleteView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteView()
    }
}
