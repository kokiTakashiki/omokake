//
//  AlbumTableViewCell.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/14.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var photosCount: UILabel!
    
    func setData(title: String, photosCount: Int) {
        self.titleLabel.text = title
        let localizedString = NSLocalizedString("Photos", comment: "")
        let messageString = String(format: localizedString, "\(photosCount)")
        self.photosCount.text = messageString
    }
}
