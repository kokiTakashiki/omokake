//
//  PhotosManager.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/19.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Foundation
import UIKit
@preconcurrency import Photos

@MainActor
public enum PhotosManager {
    private static let imageManager = PHImageManager.default()

    public static func allPhotoCount() -> Int {
        var sendCount:Int = 0
        var sendVideoCount:Int = 0
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // アルバムをフェッチ
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        assetCollections.enumerateObjects { assetCollection, index, _ in
            
            // アルバムタイトル
            //print(assetCollection.localizedTitle ?? "")
            print("[PhotosManager]",assetCollection.localizedTitle ?? "nil", PHAsset.fetchAssets(in: assetCollection, options: nil).count)
            
            // アセットをフェッチ
            let assets = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
            sendCount = assets.count
            
            //print("asset count",self.assets.count)
        }
        
        // Videosをフェッチ
        let assetVideoCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumVideos, options: nil)
        
        assetVideoCollections.enumerateObjects { assetCollection, index, _ in
            
            // アルバムタイトル
            //print(assetCollection.localizedTitle ?? "")
            //print("[PhotosManager] video ",assetCollection.localizedTitle ?? "nil", PHAsset.fetchAssets(in: assetCollection, options: nil).count)
            
            // アセットをフェッチ
            let assetsVideo = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
            sendVideoCount = assetsVideo.count
            //print("asset count",self.assets.count)
        }
        
        return sendCount - sendVideoCount
    }
    
    public static func albumTitleNames() -> [AlbumInfo] {
        var result:[AlbumInfo] = []
        // アルバムをフェッチ
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        assetCollections.enumerateObjects { assetCollection, index, _ in
            
            let assets = assets(fromCollection: assetCollection)
            result.append(
                AlbumInfo(
                    index: index,
                    title: assetCollection.localizedTitle ?? "no Title",
                    type: .regular,
                    photosCount: assets.count
                )
            )
        }
        
        return result
    }
    
    public static func favoriteAlbumInfo() -> AlbumInfo {
        var result:[AlbumInfo] = []
        let assetCollection = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        assetCollection.enumerateObjects { assetCollection, index, _ in
            let assets = assets(fromCollection: assetCollection)
            result.append(
                AlbumInfo(
                    index: index,
                    title: NSLocalizedString("Favorites", comment: ""),
                    type: .favorites,
                    photosCount: assets.count
                )
            )
        }
        return result[0]
    }
    
    // get the assets in a collection
    private static func assets(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        let photosOptions = PHFetchOptions()
        photosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        photosOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        
        return PHAsset.fetchAssets(in: collection, options: photosOptions)
    }
    
    public static func favoriteThumbnail(albumInfo: AlbumInfo, partsCount: Int, thumbnailSize: CGSize) -> [UIImage] {
        var originalArray = [UIImage]()
        
        let requestFetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        
        let collection: PHAssetCollection
        collection = requestFetchResult.object(at: albumInfo.index)
        
        let fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
        print("[PhotosManager] fetchResult \(fetchResult.count)")
        //ここの記述がないとindexPathが何もないというエラーを吐く
        if fetchResult.firstObject == nil {
            print("[PhotosManager] 何もない")
        } else {
            for i in 0..<partsCount {
                let asset = fetchResult.object(at: i)
                
                imageManager.requestImage(
                    for: asset,
                    targetSize: thumbnailSize,
                    contentMode: .aspectFill,
                    options: omokakePHImageRequestOptions,
                    resultHandler: { image, _ in
                        originalArray.append(
                            image ?? UIImage.emptyImage(
                                color: .clear,
                                frame: CGRect(
                                    origin: CGPoint(x: 0.0, y: 0.0),
                                    size: thumbnailSize
                                )
                            )
                        )
                    }
                )
            }
        }
        
        return originalArray
    }
    
    public static func selectThumbnail(albumInfo: AlbumInfo, partsCount: Int, thumbnailSize: CGSize) -> [UIImage] {
        var originalArray = [UIImage]()
        
        let requestFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        
        let collection: PHAssetCollection
        collection = requestFetchResult.object(at: albumInfo.index)
        
        let fetchResult = PHAsset.fetchAssets(in: collection, options: nil)
        print("[PhotosManager] fetchResult \(fetchResult.count)")
        //ここの記述がないとindexPathが何もないというエラーを吐く
        if fetchResult.firstObject == nil {
            print("[PhotosManager] 何もない")
        } else {
            for i in 0..<partsCount {
                let asset = fetchResult.object(at: i)
                
                imageManager.requestImage(
                    for: asset,
                    targetSize: thumbnailSize,
                    contentMode: .aspectFill,
                    options: omokakePHImageRequestOptions,
                    resultHandler: { image, _ in
                        originalArray.append(
                            image ?? UIImage.emptyImage(
                                color: .clear,
                                frame: CGRect(
                                    origin: CGPoint(x: 0.0, y: 0.0),
                                    size: thumbnailSize
                                )
                            )
                        )
                    }
                )
            }
        }
        
        return originalArray
    }
    
    public static func allThumbnail(partsCount: Int, thumbnailSize: CGSize) -> [UIImage] {
        var requestFetchResult: PHFetchResult<PHAsset>!
        
        var originalArray = [UIImage]()
        let imageManager = PHImageManager.default()
        
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
            } else {
                for i in 0..<partsCount{
                    let asset = requestFetchResult.object(at: i)
                    
                    imageManager.requestImage(
                        for: asset,
                        targetSize: thumbnailSize,
                        contentMode: .aspectFill,
                        options: omokakePHImageRequestOptions,
                        resultHandler: { image, _ in
                            originalArray.append(
                                image ?? UIImage.emptyImage(
                                    color: .clear,
                                    frame: CGRect(
                                        origin: CGPoint(x: 0.0, y: 0.0),
                                        size: thumbnailSize
                                    )
                                )
                            )
                        }
                    )
                }
            }
        }
        
        return originalArray
    }
    
    public static func authorization() -> PhotoAccessState {
        
        let semaphore = DispatchSemaphore(value: 0)
        var status: PhotoAccessState = .none
        
        PHPhotoLibrary.Authorization(userCompletionHandler: { state in
            status = state
            semaphore.signal()
        })
        semaphore.wait()
        
        return status
    }
    
    private static let omokakePHImageRequestOptions: PHImageRequestOptions = {
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = true
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.resizeMode = .exact
        return requestOptions
    }()
}
