//
//  TGAHeader.swift
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/08/24.
//

import Foundation

struct TGAHeader {
    var idSize: UInt8 // 1 byte
    var colorMapType: UInt8 // 1 byte
    var imageType: UInt8 // 1 byte
    var colorMapStart: UInt16 // 2 bytes (little endian)
    var colorMapLength: UInt16 // 2 bytes (little endian)
    var colorMapBpp: UInt8 // 1 byte
    var originX: UInt16 // 2 bytes (little endian)
    var originY: UInt16 // 2 bytes (little endian)
    var width: UInt16 // 2 bytes (little endian)
    var height: UInt16 // 2 bytes (little endian)
    var bitsPerPixel: UInt8 // 1 byte

    // Image descriptor field - union equivalent
    private var _descriptor: UInt8 // 1 byte
    // Total: 18 bytes

    // Bit field accessors
    var bitsPerAlpha: UInt8 {
        get { _descriptor & 0x0F } // Lower 4 bits
        set { _descriptor = (_descriptor & 0xF0) | (newValue & 0x0F) }
    }

    var rightOrigin: Bool {
        get { (_descriptor & 0x10) != 0 } // Bit 4
        set {
            if newValue {
                _descriptor |= 0x10
            } else {
                _descriptor &= ~0x10
            }
        }
    }

    var topOrigin: Bool {
        get { (_descriptor & 0x20) != 0 } // Bit 5
        set {
            if newValue {
                _descriptor |= 0x20
            } else {
                _descriptor &= ~0x20
            }
        }
    }

    var descriptor: UInt8 {
        get { _descriptor }
        set { _descriptor = newValue }
    }

    init() {
        idSize = 0
        colorMapType = 0
        imageType = 0
        colorMapStart = 0
        colorMapLength = 0
        colorMapBpp = 0
        originX = 0
        originY = 0
        width = 0
        height = 0
        bitsPerPixel = 0
        _descriptor = 0
    }

    // バイトデータから安全にパースするイニシャライザ
    init?(from data: Data) {
        guard data.count >= 18 else { return nil }

        let bytes = data.withUnsafeBytes { $0.bindMemory(to: UInt8.self) }

        idSize = bytes[0]
        colorMapType = bytes[1]
        imageType = bytes[2]

        // リトルエンディアンで16ビット値を読み込み
        colorMapStart = UInt16(bytes[3]) | (UInt16(bytes[4]) << 8)
        colorMapLength = UInt16(bytes[5]) | (UInt16(bytes[6]) << 8)

        colorMapBpp = bytes[7]

        originX = UInt16(bytes[8]) | (UInt16(bytes[9]) << 8)
        originY = UInt16(bytes[10]) | (UInt16(bytes[11]) << 8)
        width = UInt16(bytes[12]) | (UInt16(bytes[13]) << 8)
        height = UInt16(bytes[14]) | (UInt16(bytes[15]) << 8)

        bitsPerPixel = bytes[16]
        _descriptor = bytes[17]
    }
}
