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
        } else {
            PHPhotoLibrary.requestAuthorization { (status) -> Void in
                
                switch status {
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
}
