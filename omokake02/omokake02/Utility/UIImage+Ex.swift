//
//  UIImage+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/13.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {

    class func getEmptyImage(color: UIColor, frame: CGRect) -> UIImage {
        // グラフィックスコンテキストを作成
        UIGraphicsBeginImageContext(frame.size)

        // グラフィックスコンテキスト用の位置情報
        let rect = frame
        // グラフィックスコンテキストを取得
        let context = UIGraphicsGetCurrentContext()
        // グラフィックスコンテキストの設定
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        // グラフィックスコンテキストの画像を取得
        let image = UIGraphicsGetImageFromCurrentImageContext()!

        // グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()

        return image
   }
    
}
