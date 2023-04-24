//
//  IntroStepsViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/12.
//  Copyright © 2023 takasiki. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class IntroStepsViewController: UIViewController {
    private let introStepsEnvironmentObject = IntroStepsEnvironmentObject()
    private var cancels = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hostingController: UIHostingController = UIHostingController(
            rootView: IntroSteps().environmentObject(introStepsEnvironmentObject)
        )
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        hostingController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        hostingController.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        hostingController.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        hostingController.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        // MARK: Bind
        introStepsEnvironmentObject.tapHowToUseNextButtonSubject
            .sink { [weak self] value in
                if value == true {
                    Task {
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
        
        let menuViewController = MenuViewController.instantiateStoryBoardToUIViewController()
        let navi = UINavigationController(rootViewController: menuViewController)
        navi.modalPresentationStyle = .fullScreen
        navi.modalTransitionStyle = .crossDissolve
        self.present(navi, animated: true, completion: nil)
    }
}
