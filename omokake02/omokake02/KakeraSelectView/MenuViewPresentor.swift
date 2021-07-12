//
//  MenuViewPresentor.swift
//  omokake02
//
//  Created by takasiki on 10/14/1 R.
//  Copyright © 1 Reiwa takasiki. All rights reserved.
//

import Foundation
import UIKit
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
            case .limited:
                userCompletionHandler("limited")
                print("limited")
            @unknown default:
                userCompletionHandler("default")
                print("default")
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
    
    var fetchResult: PHFetchResult<PHCollection>!
    var requestFetchResult: PHFetchResult<PHAsset>!
    
    func getPhotoCount() -> Int {
        
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
    
    func getThumbnail(partsCount: Int, thumbnailSize: CGSize) -> [UIImage] {
        var originalArray: Array! = [UIImage]()
        let imageManager = PHCachingImageManager()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // アルバムをフェッチ
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)

        assetCollections.enumerateObjects { assetCollection, index, _ in
            
            self.requestFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            //アルバム内の画像が一枚もない時は適当に配列に画像を突っ込んでおく
            //ここの記述がないとindexPathが何もないというエラーを吐く
            if self.requestFetchResult.firstObject == nil {
                print("何もない")
                originalArray.append(UIImage(named: "test")!)
            } else {
                for i in 0..<partsCount{
                    let asset = self.requestFetchResult.object(at: i)

                    imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                        if image == nil {
                            print("managerError")
                            originalArray.append(UIImage.getEmptyImage(color: .clear, frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: thumbnailSize)))
                        } else {
                            originalArray.append(image! as UIImage)
                        }
                    })
                }
            }
        }
        
        return originalArray
    }
    
    var status = "norn"
    func Authorization() -> String {
        
        PHPhotoLibrary.Authorization(userCompletionHandler: { str in
            self.status = str
        })
        return status
    }
}
