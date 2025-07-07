//
//  StartViewController.swift
//  omokake02
//
//  Created by takasiki on 10/13/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

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
        
        let hostingController: UIHostingController = UIHostingController(
            rootView: MenuView().environmentObject(menuViewEnvironmentObject)
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
        
        self.navigationController?.navigationBar.isHidden = true
        
        // MARK: Bind
        menuViewEnvironmentObject.presentSubject
            .sink { [weak self] (viewController, transitionCase) in
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
