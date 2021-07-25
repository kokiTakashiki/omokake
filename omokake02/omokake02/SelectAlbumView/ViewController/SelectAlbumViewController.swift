//
//  SelectAlbumViewController.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/14.
//  Copyright © 2021 takasiki. All rights reserved.
//

import UIKit

class SelectAlbumViewController: UIViewController {
    @IBOutlet weak var tableView: AlbumTableView!
    
    var partsCount:Int = 1
    var selectKakera:String = ""//:Array<String> = ["kakera","kakera2"]
    var isBlendingEnabled:Bool = false
    
    var albumData = [AlbumInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.selectDelegate = self
        albumData = PhotosManager.albumTitleNames()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.item = albumData
        tableView.reloadData()
    }
}

extension SelectAlbumViewController: AlbumTableViewDelegate {
    func albumTable(_ tableView: AlbumTableView, didSelectNoteListTable note: AlbumInfo) {
        if note.photosCount > 400 {
            let alert: UIAlertController = UIAlertController(title: "400枚に制限します。", message: "サムネイル表示では400枚が上限となっています。", preferredStyle:  UIAlertController.Style.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                self.present(note)
            })
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        present(note)
    }
    
    private func present(_ note: AlbumInfo) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let flowSelectViewController = mainStoryboard.instantiateViewController(withIdentifier: "FlowSelectViewController") as! FlowSelectViewController
        flowSelectViewController.partsCount = partsCount
        flowSelectViewController.selectKakera = selectKakera
        flowSelectViewController.isBlendingEnabled = isBlendingEnabled
        flowSelectViewController.albumInfo = note
        flowSelectViewController.modalPresentationStyle = .fullScreen
        self.present(flowSelectViewController, animated: true, completion: nil)
    }
}

extension SelectAlbumViewController {
    @IBAction func backSelectKakeraAction(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
