//
//  MenuViewController.swift
//  omokake02
//
//  Created by takasiki on 10/13/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

extension MenuViewController {
    enum TransitionCase {
        case modalPresentation
        case pushViewController
    }
}

final class MenuViewController: UIViewController {
    private let menuViewEnvironmentObject = MenuViewEnvironmentObject()
    private var cancels = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let hostingController = UIHostingController(
            rootView: MenuView().environmentObject(menuViewEnvironmentObject)
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

        navigationController?.navigationBar.isHidden = true

        // MARK: Bind

        menuViewEnvironmentObject.presentSubject
            .sink { [weak self] viewController, transitionCase in
                self?.present(viewController, transitionCase: transitionCase)
            }
            .store(in: &cancels)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: praivate

extension MenuViewController {
    private func present(
        _ viewController: UIViewController,
        transitionCase: TransitionCase
    ) {
        switch transitionCase {
        case .modalPresentation:
            present(viewController, animated: true, completion: nil)
        case .pushViewController:
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
