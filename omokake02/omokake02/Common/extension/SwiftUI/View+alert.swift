//
//  View+alert.swift
//  omokake02
//
//  Created by takedatakashiki on 2023/10/08.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder
    func okAlert(
        _ titleKey: LocalizedStringKey,
        messageKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        action: @escaping () -> Void
    ) -> some View {
        if #available(iOS 15.0, *) {
            self.alert(titleKey, isPresented: isPresented) {
                Button("OK", role: .cancel) {
                    action()
                }
            } message: {
                Text(messageKey)
            }
        } else {
            self.alert(isPresented: isPresented) {
                Alert(
                    title: Text(titleKey),
                    message: Text(messageKey),
                    dismissButton: .default(Text("OK"), action: {
                        action()
                    })
                )
            }
        }
    }

    @ViewBuilder
    func okAlert(
        _ titleKey: LocalizedStringKey,
        messageText: String,
        isPresented: Binding<Bool>,
        action: @escaping () -> Void
    ) -> some View {
        if #available(iOS 15.0, *) {
            self.alert(titleKey, isPresented: isPresented) {
                Button("OK", role: .cancel) {
                    action()
                }
            } message: {
                Text(messageText)
            }
        } else {
            self.alert(isPresented: isPresented) {
                Alert(
                    title: Text(titleKey),
                    message: Text(messageText),
                    dismissButton: .default(Text("OK"), action: {
                        action()
                    })
                )
            }
        }
    }
}
