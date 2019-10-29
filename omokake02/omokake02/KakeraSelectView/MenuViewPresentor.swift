//
//  MenuViewPresentor.swift
//  omokake02
//
//  Created by takasiki on 10/14/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Foundation
import Photos

extension PHPhotoLibrary {
    //ユーザーに許可を促す.
    class func Authorization( userCompletionHandler: @escaping (String) -> Void){
        
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            
            switch(status){
            case .authorized:
                userCompletionHandler("Authorized")
                print("Authorized")
            case .denied:
                userCompletionHandler("Denied")
                print("Denied")
            case .notDetermined:
                userCompletionHandler("NotDetermined")
                print("NotDetermined")
            case .restricted:
                userCompletionHandler("Restricted")
                print("Restricted")
            }
            
        }
    }
}

protocol MenuViewPresentor {
    func getPhotoCount() -> Int
    func Authorization() -> String
}

class MenuViewPresentorImpl: MenuViewPresentor {
    var assets:PHFetchResult<PHAsset>!
    var sendCount:Int = 0
    var assetsVideo:PHFetchResult<PHAsset>!
    var sendVideoCount:Int = 0
    
    func getPhotoCount() -> Int {
        //Photo
        let imgManager = PHImageManager.default()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // アルバムをフェッチ
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        assetCollections.enumerateObjects { assetCollection, index, _ in
            
            // アルバムタイトル
            //print(assetCollection.localizedTitle ?? "")
            print(assetCollection.localizedTitle!, PHAsset.fetchAssets(in: assetCollection, options: nil).count)
            
            // アセットをフェッチ
            self.assets = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
            self.sendCount = self.assets!.count
            
            //print("asset count",self.assets.count)
        }
        
        // Videosをフェッチ
        let assetVideoCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        assetVideoCollections.enumerateObjects { assetCollection, index, _ in
            
            // アルバムタイトル
            //print(assetCollection.localizedTitle ?? "")
            //print(assetCollection.localizedTitle!, PHAsset.fetchAssets(in: assetCollection, options: nil).count)
            
            if assetCollection.localizedTitle == "Videos" {
                // アセットをフェッチ
                self.assetsVideo = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
                self.sendVideoCount = self.assetsVideo!.count
            }
            //print("asset count",self.assets.count)
        }
        
        return sendCount - sendVideoCount
    }
    
    var status = "norn"
    func Authorization() -> String {
        
        PHPhotoLibrary.Authorization(userCompletionHandler: { str in
            self.status = str
        })
        return status
    }
}
