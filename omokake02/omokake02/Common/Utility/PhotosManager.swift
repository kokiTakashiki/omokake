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
            print("[PhotosManager]",assetCollection.localizedTitle!, PHAsset.fetchAssets(in: assetCollection, options: nil).count)
            
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
    
    static func albumTitleNames() -> [AlbumInfo] {
        var result:[AlbumInfo] = []
        // アルバムをフェッチ
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        assetCollections.enumerateObjects { assetCollection, index, _ in
            
            let assets = assets(fromCollection: assetCollection)
            result.append(AlbumInfo(index: index, title: assetCollection.localizedTitle ?? "no Title", photosCount: assets.count))
        }
        
        return result
    }
    
    // get the assets in a collection
    static func assets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let photosOptions = PHFetchOptions()
        photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photosOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        
        return PHAsset.fetchAssets(in: collection, options: photosOptions)
    }
    
    static func selectThumbnail(albumInfo: AlbumInfo, partsCount: Int, thumbnailSize: CGSize) -> [UIImage] {
        var originalArray = [UIImage]()
        let imageManager = PHCachingImageManager()
        
        var requestFetchResult: PHFetchResult<PHAssetCollection>!
        requestFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        let collection: PHAssetCollection
        collection = requestFetchResult.object(at: albumInfo.index)
        
        let fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
        print("[PhotosManager] fetchResult \(fetchResult.count)")
        //ここの記述がないとindexPathが何もないというエラーを吐く
        if fetchResult.firstObject == nil {
            print("[PhotosManager] 何もない")
            originalArray.append(UIImage(named: "test")!)
        } else {
            for i in 0..<partsCount {
                let asset = fetchResult.object(at: i)
                
                imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                    originalArray.append(image ?? UIImage.emptyImage(color: .clear, frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: thumbnailSize)))
                })
            }
        }
        
        return originalArray
    }
    
    static func allThumbnail(partsCount: Int, thumbnailSize: CGSize) -> [UIImage] {
        var requestFetchResult: PHFetchResult<PHAsset>!
        
        var originalArray = [UIImage]()
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
                print("[PhotosManager] 何もない")
                originalArray.append(UIImage(named: "test")!)
            } else {
                for i in 0..<partsCount{
                    let asset = requestFetchResult.object(at: i)
                    
                    imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                        if image == nil {
                            print("[PhotosManager] managerError")
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