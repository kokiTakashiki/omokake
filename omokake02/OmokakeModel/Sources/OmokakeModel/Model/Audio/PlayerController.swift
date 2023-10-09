//
//  PlayerController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2023/03/11.
//  Copyright © 2023 takasiki. All rights reserved.
//

import AVKit

public class PlayerController {
    public static let shared = PlayerController()
    private var currentMusic: AVAudioPlayer?
    private var currentEffect: AVAudioPlayer?

    private init() {}

    // MARK: Player
    var musicVolume: Float = 1.0 {
        didSet {currentMusic?.volume = musicVolume}
    }

    var effectVolume: Float {
        get{
            let value = UserDefaults.standard.object(forKey: "effectVolume")
            if value == nil {
                return 0.5
            }
            return value as! Float
        }
        set(value){
            UserDefaults.standard.set(value, forKey : "effectVolume")
        }
    }
}

extension PlayerController: Player {
    
    public func play(music: Music) {
        guard let newMusic = try? AVAudioPlayer(soundFile: music) else { return }
        newMusic.volume = musicVolume
        newMusic.play()
        newMusic.numberOfLoops = -1 //In this way the music will play in loop
        currentMusic = newMusic
    }

    public func pause(music: Music) {
        currentMusic?.pause()
    }

    public func play(effect: Effect) {
        guard let newEffect = try? AVAudioPlayer(soundFile: effect) else { return }
        newEffect.volume = effectVolume
        newEffect.play()
        currentEffect = newEffect
    }

    public func playRandom(effects: [Effect]) {
        guard
            let effect = effects.randomElement(),
            let newEffect = try? AVAudioPlayer(soundFile: effect)
        else { return }
        newEffect.volume = effectVolume
        newEffect.play()
        currentEffect = newEffect
    }
}

extension AVAudioPlayer {
    public enum PlayerError: Error {
        case fileNotFound
    }

//    public convenience init(soundFile: FileSoundProtocol) throws {
//        guard let url = Bundle.main.url(forResource: soundFile.fileName, withExtension: soundFile.type) else {
//        throw PlayerError.fileNotFound }
//        try self.init(contentsOf: url)
//    }

    public convenience init(soundFile: FileSoundProtocol) throws {
        guard let data = NSDataAsset(name: soundFile.fileName)?.data else {
        throw PlayerError.fileNotFound }
        try self.init(data: data)
    }
}
