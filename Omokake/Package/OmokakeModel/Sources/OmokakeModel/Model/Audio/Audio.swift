//
//  Audio.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/11.
//  Copyright © 2023 takasiki. All rights reserved.
//

import Foundation

public struct Audio {
    public enum MusicFiles {
        //static let yourMusic = Music(fileName: "MusicName", type: "mp3")
    }

    @MainActor
    public enum EffectFiles {
        public static let caution = Effect(fileName: "caution", type: "wav")
        public static let celebration = Effect(fileName: "celebration", type: "wav")
        public static let taps = [
            Effect(fileName: "tap_01", type: "wav"),
            Effect(fileName: "tap_02", type: "wav"),
            Effect(fileName: "tap_03", type: "wav"),
            Effect(fileName: "tap_04", type: "wav"),
            Effect(fileName: "tap_05", type: "wav"),
        ]
        public static let transitionDown = Effect(fileName: "transition_down", type: "wav")
        public static let transitionUp = Effect(fileName: "transition_up", type: "wav")
    }
}
