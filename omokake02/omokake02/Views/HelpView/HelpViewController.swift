//
//  HelpViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/10.
//  Copyright © 2023 takasiki. All rights reserved.
//

import UIKit
import SwiftUI
import Combine
import OmokakeModel

final class HelpViewController: UIViewController {
    enum BackType {
    case button
    case popGesture
    }
    private let audio = PlayerController.shared
    private let haptic = HapticFeedbackController.shared

    private let backTypeSubject = PassthroughSubject<BackType, Never>()
    private var cancels = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()

        let chevronLeftImage: UIImage? = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: chevronLeftImage, style: .plain, target: self, action: #selector(onTapBackButton(_:)))
        navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = .lightGray
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.navigationBar.isHidden = false

        let hostingController: UIHostingController = UIHostingController(rootView: HelpView())
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
        backTypeSubject
            .scan((BackType.popGesture, BackType.popGesture)) { ($0.1, $1) }
            .sink { [weak self] previous, current in
                if previous == current {
                    self?.audio.play(effect: Audio.EffectFiles.transitionDown)
                    self?.haptic.play(.impact(.soft))
                }
        }
        .store(in: &cancels)
    }

    @objc
    func onTapBackButton(_ sender: UIBarButtonItem) {
        backTypeSubject.send(.button)
        audio.play(effect: Audio.EffectFiles.transitionDown)
        haptic.play(.impact(.soft))
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        backTypeSubject.send(.popGesture)
    }
}

// MARC: UIGestureRecognizerDelegate
extension HelpViewController: UIGestureRecognizerDelegate {}
