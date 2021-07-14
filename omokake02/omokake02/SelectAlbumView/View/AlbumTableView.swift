//
//  AlbumTableView.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/14.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit

protocol AlbumTableViewDelegate: AnyObject {
    func albumTable(_ tableView: AlbumTableView, didSelectNoteListTable note: AlbumInfo)
}

final class AlbumTableView: UITableView {
    weak var selectDelegate: AlbumTableViewDelegate?
    
    var item: [Any] = [] {
        didSet { reloadData() }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
        
        register(.init(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "AlbumTableViewCell")
    }
}

extension AlbumTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewData = item[indexPath.row]
        if let item = viewData as? AlbumInfo {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath) as! AlbumTableViewCell
            cell.setData(title: item.title, photosCount: item.photosCount)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewData = item[indexPath.row]
        if let item = viewData as? AlbumInfo {
            selectDelegate?.albumTable(self, didSelectNoteListTable: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
