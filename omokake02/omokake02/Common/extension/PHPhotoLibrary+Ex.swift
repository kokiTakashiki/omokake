//
//  PHPhotoLibrary+Ex.swift
//  omokake02
//
//  Created by 武田孝騎 on 2021/07/19.
//  Copyright © 2021 takasiki. All rights reserved.
//

import Photos

extension PHPhotoLibrary {
    //ユーザーに許可を促す.
    class func Authorization( userCompletionHandler: @escaping (String) -> Void){
        
        if #available(iOS 14.0, *) {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                
                switch status {
                case .authorized:
                    userCompletionHandler("Authorized")
                    print("[PHPhotoLibrary] Authorized")
                case .denied:
                    userCompletionHandler("Denied")
                    print("[PHPhotoLibrary] Denied")
                case .notDetermined:
                    userCompletionHandler("NotDetermined")
                    print("[PHPhotoLibrary] NotDetermined")
                case .restricted:
                    userCompletionHandler("Restricted")
                    print("[PHPhotoLibrary] Restricted")
                case .limited:
                    userCompletionHandler("limited")
                    print("[PHPhotoLibrary] limited")
                @unknown default:
                    userCompletionHandler("default")
                    print("[PHPhotoLibrary] default")
                }
                
            }
        } else {
            PHPhotoLibrary.requestAuthorization { (status) -> Void in
                
                switch status {
                case .authorized:
                    userCompletionHandler("Authorized")
                    print("[PHPhotoLibrary] Authorized")
                case .denied:
                    userCompletionHandler("Denied")
                    print("[PHPhotoLibrary] Denied")
                case .notDetermined:
                    userCompletionHandler("NotDetermined")
                    print("[PHPhotoLibrary] NotDetermined")
                case .restricted:
                    userCompletionHandler("Restricted")
                    print("[PHPhotoLibrary] Restricted")
                case .limited:
                    userCompletionHandler("limited")
                    print("[PHPhotoLibrary] limited")
                @unknown default:
                    userCompletionHandler("default")
                    print("[PHPhotoLibrary] default")
                }
                
            }
        }
    }
}
