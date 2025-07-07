//
//  UIImage+Ex.swift
//  omokake02
//
//  Created by takedatakashiki on 2023/10/04.
//  Copyright © 2023 takasiki. All rights reserved.
//

import UIKit

extension UIImage {
    static func emptyImage(color: UIColor, frame: CGRect) -> UIImage {
        // グラフィックスコンテキストを作成
        UIGraphicsBeginImageContext(frame.size)

        // グラフィックスコンテキスト用の位置情報
        let rect = frame
        // グラフィックスコンテキストを取得
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        // グラフィックスコンテキストの設定
        context.setFillColor(color.cgColor)
        context.fill(rect)
        // グラフィックスコンテキストの画像を取得
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }

        // グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()

        return image
    }

    /// イメージ縮小
    func resizeImage(maxSize: Int) -> UIImage? {

        guard let jpg = self.jpegData(compressionQuality: 1) as NSData? else {
            return nil
        }
        if isLessThanMaxByte(data: jpg, maxDataByte: maxSize) {
            return self
        }
        // 80%に圧縮
        let _size: CGSize = CGSize(width: (self.size.width * 0.8), height: (self.size.height * 0.8))
        UIGraphicsBeginImageContext(_size)
        self.draw(in: CGRect(x: 0, y: 0, width: _size.width, height: _size.height))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        // 再帰処理
        return newImage.resizeImage(maxSize: maxSize)
    }

    /// 最大容量チェック
    private func isLessThanMaxByte(data: NSData?, maxDataByte: Int) -> Bool {

        if maxDataByte <= 0 {
            // 最大容量の指定が無い場合はOK扱い
            return true
        }
        guard let data = data else {
            fatalError("Data unwrap error")
        }
        if data.length < maxDataByte {
            // 最大容量未満：OK　※以下でも良いがバッファを取ることにした
            return true
        }
        // 最大容量以上：NG
        return false
    }
}
