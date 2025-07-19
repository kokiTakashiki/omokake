//
//  View+alert.swift
//  omokake02
//
//  Created by takedatakashiki on 2023/10/08.
//  Copyright © 2023 takasiki. All rights reserved.
//

import SwiftUI

extension View {
    /// **Displays** an OK alert with the specified title and message.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the alert title.
    ///   - messageKey: The localized string key for the alert message.
    ///   - isPresented: A binding to determine whether the alert is presented.
    ///   - action: The action to perform when OK is tapped.
    /// - Returns: A view that presents an alert when the binding is true.
    @ViewBuilder
    func alertWithOKButton(
        _ titleKey: LocalizedStringKey,
        message messageKey: LocalizedStringKey,
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
            alert(isPresented: isPresented) {
                Alert(
                    title: Text(titleKey),
                    message: Text(messageKey),
                    dismissButton: .default(Text("OK")) {
                        action()
                    }
                )
            }
        }
    }

    /// **Displays** an OK alert with the specified title and message text.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the alert title.
    ///   - messageText: The plain text for the alert message.
    ///   - isPresented: A binding to determine whether the alert is presented.
    ///   - action: The action to perform when OK is tapped.
    /// - Returns: A view that presents an alert when the binding is true.
    @ViewBuilder
    func alertWithOKButton(
        _ titleKey: LocalizedStringKey,
        message messageText: String,
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
            alert(isPresented: isPresented) {
                Alert(
                    title: Text(titleKey),
                    message: Text(messageText),
                    dismissButton: .default(Text("OK")) {
                        action()
                    }
                )
            }
        }
    }
}
