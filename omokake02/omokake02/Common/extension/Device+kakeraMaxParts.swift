//
//  Device+kakeraMaxParts.swift
//  omokake02
//
//  Created by takedatakashiki on 2024/08/25.
//  Copyright © 2024 takasiki. All rights reserved.
//

import Foundation
import DeviceKit

extension Device {
    enum Mode {
        case kakera
        case thumbnail
    }
    // TODO: チップの性能ごとに自動判定したい。
    // このサイトを参考に分岐　https://www.antutu.com/en/ranking/ios1.htm
    static func kakeraMaxParts(_ mode: Mode) -> Int {
        print("[MenuViewController] device \(self.current)")
        switch self.current {
        case .iPhoneXR, .iPhoneXSMax, .iPhoneXS, .iPhoneSE2:
            return switch mode {
                case .kakera: 200000
                case .thumbnail: 300
            }
        case .iPhone11, .iPhone11ProMax, .iPhone11Pro,
            .iPhone12Pro, .iPhone12, .iPhone12ProMax, .iPhone12Mini,
            .iPhoneSE3, .iPhone13Mini, .iPhone13,
            .iPhone14, .iPhone14Plus, .iPhone13Pro,
            .iPhone13ProMax, .iPhone14ProMax, .iPhone14Pro,
            .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
            return switch mode {
                case .kakera: 300000
                case .thumbnail: 400
            }
        default:
            return switch mode {
                case .kakera: 100000
                case .thumbnail: 200
            }
        }
    }

    // TODO: チップの性能ごとに自動判定したい。
    // このサイトを参考に分岐　https://www.antutu.com/en/ranking/ios1.htm
//    private static func deviceMaxParts() -> Int {
//        let device = Device.current
//        print("[MenuViewController] device \(device)")
//        switch device {
//        case .iPhoneXR, .iPhoneXSMax, .iPhoneXS, .iPhoneSE2:
//            return 200000
//
//        case .iPhone11, .iPhone11ProMax, .iPhone11Pro,
//                .iPhone12Pro, .iPhone12, .iPhone12ProMax, .iPhone12Mini,
//                .iPhoneSE3, .iPhone13Mini, .iPhone13,
//                .iPhone14, .iPhone14Plus, .iPhone13Pro,
//                .iPhone13ProMax, .iPhone14ProMax, .iPhone14Pro,
//                .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
//            return 300000
//
//        default:
//            return 100000
//        }
//    }
    // TODO: チップの性能ごとに自動判定したい。
    // このサイトを参考に分岐　https://www.antutu.com/en/ranking/ios1.htm
//    private func deviceMaxParts(_ note: AlbumInfo) {
//        let device = Device.current
//        print("[SelectAlbumViewController] deviceMaxParts \(device)")
//        switch device {
//        case .iPhoneXR, .iPhoneXSMax, .iPhoneXS, .iPhoneSE2:
//            partsAlertAndPresent(note, maxParts: 300)
//
//        case .iPhone11, .iPhone11ProMax, .iPhone11Pro,
//                .iPhone12Pro, .iPhone12, .iPhone12ProMax, .iPhone12Mini,
//                .iPhoneSE3, .iPhone13Mini, .iPhone13,
//                .iPhone14, .iPhone14Plus, .iPhone13Pro,
//                .iPhone13ProMax, .iPhone14ProMax, .iPhone14Pro,
//                .iPhone15, .iPhone15Plus, .iPhone15Pro, .iPhone15ProMax:
//            partsAlertAndPresent(note, maxParts: 400)
//
//        default:
//            partsAlertAndPresent(note, maxParts: 200)
//        }
//    }
}
