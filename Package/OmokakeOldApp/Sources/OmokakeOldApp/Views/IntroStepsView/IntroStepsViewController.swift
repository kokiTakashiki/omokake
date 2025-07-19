//
//  IntroStepsViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

final class IntroStepsViewController: UIViewController {
    private let introStepsEnvironmentObject = IntroStepsEnvironmentObject()
    private var cancels = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController = UIHostingController(
            rootView: IntroSteps().environmentObject(introStepsEnvironmentObject)
        )
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        hostingController.view.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        hostingController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        // MARK: Bind

        introStepsEnvironmentObject.tapHowToUseNextButtonSubject
            .sink { [weak self] value in
                if value == true {
                    Task { @MainActor in
                        await self?.showMenu()
                    }
                }
            }
            .store(in: &cancels)
    }
}

extension IntroStepsViewController {
    @MainActor
    private func showMenu() async {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "tutorialOff")
        defaults.set(true, forKey: "menuOn")

        let menuViewController = MenuViewController()
        let navi = UINavigationController(rootViewController: menuViewController)
        navi.modalPresentationStyle = .fullScreen
        navi.modalTransitionStyle = .crossDissolve
        present(navi, animated: true, completion: nil)
    }
}
