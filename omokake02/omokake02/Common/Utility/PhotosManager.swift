//
//  PhotosManager.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/19.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct PhotosManager {
    static func allPhotoCount() -> Int {
        
        var assets:PHFetchResult<PHAsset>!
        var sendCount:Int = 0
        var assetsVideo:PHFetchResult<PHAsset>!
        var sendVideoCount:Int = 0
        
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
            assets = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
            sendCount = assets!.count
            
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
                assetsVideo = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
                sendVideoCount = assetsVideo!.count
            }
            //print("asset count",self.assets.count)
        }
        
        return sendCount - sendVideoCount
    }
    
    static func thumbnail(partsCount: Int, thumbnailSize: CGSize) -> [UIImage] {
        var requestFetchResult: PHFetchResult<PHAsset>!
        
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
            
            requestFetchResult = PHAsset.fetchAssets(in: assetCollection, options: nil)
            //アルバム内の画像が一枚もない時は適当に配列に画像を突っ込んでおく
            //ここの記述がないとindexPathが何もないというエラーを吐く
            if requestFetchResult.firstObject == nil {
                print("何もない")
                originalArray.append(UIImage(named: "test")!)
            } else {
                for i in 0..<partsCount{
                    let asset = requestFetchResult.object(at: i)

                    imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                        if image == nil {
                            print("managerError")
                            originalArray.append(UIImage.emptyImage(color: .clear, frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: thumbnailSize)))
                        } else {
                            originalArray.append(image! as UIImage)
                        }
                    })
                }
            }
        }
        
        return originalArray
    }
    
    static func Authorization() -> String {
        
        let semaphore = DispatchSemaphore(value: 0)
        var status = "norn"
        
        PHPhotoLibrary.Authorization(userCompletionHandler: { str in
            status = str
            semaphore.signal()
        })
        semaphore.wait()
        
        return status
    }
}
