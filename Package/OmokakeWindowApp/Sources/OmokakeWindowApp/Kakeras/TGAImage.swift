//
//  TGAImage.swift
//  OmokakeWindowApp
//
//  Created by takedatakashiki on 2025/08/24.
//

import Foundation
import os.log

enum TGAImageError: Error {
    case unsupportedImageType
    case colorMapNotSupported
    case nonZeroOriginNotSupported
    case unsupportedAlphaBits
    case unsupportedBitDepth
}

struct TGAImage {
    let width: Int
    let height: Int
    let data: Data

    init?(with TGAFileAtLocation: URL) throws {
        guard let fileData = try Self.data(from: TGAFileAtLocation) else {
            return nil
        }

        // ファイルデータからTGAHeaderを読み込む
        guard let headerData = TGAHeader(from: fileData) else {
            return nil
        }

        let sourceBytesPerPixel = try Self.bytesPerPixel(from: headerData)
        if sourceBytesPerPixel == 0 {
            return nil
        }

        let imageWidth = Int(headerData.width)
        let imageHeight = Int(headerData.height)
        let dataSize = imageWidth * imageHeight * 4

        guard let mutableData = NSMutableData(length: dataSize) else {
            return nil
        }

        // ソースデータのポインタを計算（ヘッダ + IDサイズ分をスキップ）
        let headerSize = MemoryLayout<TGAHeader>.size
        let sourceDataOffset = headerSize + Int(headerData.idSize)

        // プロパティを初期化してからピクセルデータを処理
        width = imageWidth
        height = imageHeight

        // ピクセルデータの処理
        fileData.withUnsafeBytes { fileBytes in
            let sourceData = fileBytes.bindMemory(to: UInt8.self).baseAddress! + sourceDataOffset
            let destinationData = mutableData.mutableBytes.bindMemory(to: UInt8.self, capacity: dataSize)

            // 全ての行を処理
            for y in 0 ..< imageHeight {
                // 5番目のビットがクリアされている場合、垂直方向に画像を反転
                // MetalのテクスチャのOriginは左上角のため
                let row = headerData.topOrigin ? y : (imageHeight - 1 - y)

                // 現在の行の全ての列を処理
                for x in 0 ..< imageWidth {
                    // 4番目のビットがセットされている場合、水平方向に画像を反転
                    // MetalのテクスチャのOriginは左上角のため
                    let column = headerData.rightOrigin ? (imageWidth - 1 - x) : x

                    // TGAファイル内のピクセルインデックス
                    let sourceIndex = sourceBytesPerPixel * (row * imageWidth + column)

                    // Metalテクスチャ内の対応するピクセルインデックス
                    let destinationIndex = 4 * (y * imageWidth + x)

                    // ブルーチャンネルをコピー
                    destinationData[destinationIndex + 0] = sourceData[sourceIndex + 0]

                    // グリーンチャンネルをコピー
                    destinationData[destinationIndex + 1] = sourceData[sourceIndex + 1]

                    // レッドチャンネルをコピー
                    destinationData[destinationIndex + 2] = sourceData[sourceIndex + 2]

                    if headerData.bitsPerPixel == 32 {
                        // アルファチャンネルをコピー
                        destinationData[destinationIndex + 3] = sourceData[sourceIndex + 3]
                    } else {
                        // アルファチャンネルを完全不透明に設定（透明度なし）
                        destinationData[destinationIndex + 3] = 255
                    }
                }
            }
        }

        // 変換完了後、データをimmutableインスタンスに保存
        data = mutableData as Data
    }

    private static func data(from url: URL) throws -> Data? {
        let fileExtension = url.pathExtension
        if fileExtension.caseInsensitiveCompare("tga") != .orderedSame {
            return nil
        }
        return try Data(contentsOf: url)
    }

    private static func bytesPerPixel(from headerData: TGAHeader) throws -> Int {
        // Check for non-compressed BGR(A) TGA files only
        guard headerData.imageType == 2 else {
            // Self.logger.error("The TGAImage type only supports non-compressed BGR(A) TGA files.")
            throw TGAImageError.unsupportedImageType
        }

        // Check for colormap
        guard headerData.colorMapType == 0 else {
            // Self.logger.error("The TGAImage type doesn't support TGA files with a colormap.")
            throw TGAImageError.colorMapNotSupported
        }

        // Check for non-zero origin
        guard headerData.originX == 0, headerData.originY == 0 else {
            // Self.logger.error("The TGAImage type doesn't support TGA files with a non-zero origin.")
            throw TGAImageError.nonZeroOriginNotSupported
        }

        let sourceBytesPerPixel: Int

        switch headerData.bitsPerPixel {
        case 32:
            guard headerData.bitsPerAlpha == 8 else {
                // Self.logger.error("The TGAImage type only supports 32-bit TGA files with 8 bits of alpha.")
                throw TGAImageError.unsupportedAlphaBits
            }
            sourceBytesPerPixel = 4

        case 24:
            guard headerData.bitsPerAlpha == 0 else {
                // Self.logger.error("The TGAImage type only supports 24-bit TGA files with no alpha.")
                throw TGAImageError.unsupportedAlphaBits
            }
            sourceBytesPerPixel = 3

        default:
            // Self.logger.error("The TGAImage type only supports 24-bit and 32-bit TGA files.")
            throw TGAImageError.unsupportedBitDepth
        }

        return sourceBytesPerPixel
    }
}
