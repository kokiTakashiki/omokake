//
//  Player.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/11.
//  Copyright © 2023 takasiki. All rights reserved.
//

import Foundation

protocol Player {
    var musicVolume: Float { get set }
    func play(music: Music)
    func pause(music: Music)
    var effectVolume: Float { get set }
    func play(effect: Effect)
}
