//
//  OmokakeApp.swift
//  Omokake
//
//  Created by takedatakashiki on 2025/07/04.
//

import OmokakeWindowApp
import SwiftUI

#if os(iOS)
    import OmokakeOldApp
    import UIKit

    @available(iOS 14.0, *)
    @main
    struct OmokakeApp: App {
        var body: some Scene {
            WindowGroup {
                if #available(iOS 26.0, *) {
                    OmokakeWindowApp.main
                        .preferredColorScheme(.dark)
                } else {
                    OmokakeOldApp.main
                        .preferredColorScheme(.dark)
                        .ignoresSafeArea()
                }
            }
        }
    }

    @available(iOS 13.0, *)
    @available(iOS, obsoleted: 14.0)
    class SceneDelegate: UIResponder, UIWindowSceneDelegate {
        var window: UIWindow?

        func scene(
            _ scene: UIScene,
            willConnectTo session: UISceneSession,
            options connectionOptions: UIScene.ConnectionOptions
        ) {
            let contentView = OmokakeOldApp.main

            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: contentView)
                self.window = window
                window.overrideUserInterfaceStyle = .dark
                window.makeKeyAndVisible()
            }
        }
    }

    @available(iOS 13.0, *)
    @available(iOS, obsoleted: 14.0)
    class AppDelegate: UIResponder, UIApplicationDelegate {
        func application(
            _ application: UIApplication,
            configurationForConnecting connectingSceneSession: UISceneSession,
            options: UIScene.ConnectionOptions
        ) -> UISceneConfiguration {
            let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            sceneConfig.delegateClass = SceneDelegate.self
            return sceneConfig
        }
    }
#endif

#if os(macOS)
    @main
    struct OmokakeApp: App {
        var body: some Scene {
            WindowGroup {
                OmokakeWindowApp.main
                    .preferredColorScheme(.dark)
            }
        }
    }
#endif

#if os(visionOS)
    import OmokakeSpaceApp

    @main
    struct OmokakeVisionApp: App {
        var body: some Scene {
            WindowGroup {
                OmokakeSpaceApp.main
                    .preferredColorScheme(.dark)
            }
        }
    }
#endif
