import Foundation
#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

/// OmokakeResourcesは共通のリソース管理を提供するライブラリです
public enum OmokakeResources {

    /// パッケージのバンドルを取得します
    public static let bundle: Bundle = {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            return Bundle(for: BundleToken.self)
        #endif
    }()

    /// リソースファイルのパスを取得します
    public static func resourcePath(for fileName: String, fileExtension: String? = nil) -> String? {
        bundle.path(forResource: fileName, ofType: fileExtension)
    }

    /// リソースファイルのURLを取得します
    public static func resourceURL(for fileName: String, withExtension fileExtension: String? = nil) -> URL? {
        bundle.url(forResource: fileName, withExtension: fileExtension)
    }

    // MARK: - Image Resources

    #if canImport(UIKit)
        /// 指定された名前の画像をUIImageとして取得します（iOS/tvOS用）
        public static func image(named name: String) -> UIImage? {
            UIImage(named: name, in: bundle, compatibleWith: nil)
        }

    #elseif canImport(AppKit)
        /// 指定された名前の画像をNSImageとして取得します（macOS用）
        public static func image(named name: String) -> NSImage? {
            bundle.image(forResource: name)
        }
    #endif

    /// 利用可能な画像リソース名の列挙
    public enum ImageResource: String, CaseIterable {
        case appIcon = "app_icon"
        case kakeraIcon = "kakera_icon"
        case photoFrames = "photo_frames"

        #if canImport(UIKit)
            /// この画像リソースをUIImageとして取得します
            public var uiImage: UIImage? {
                OmokakeResources.image(named: rawValue)
            }

        #elseif canImport(AppKit)
            /// この画像リソースをNSImageとして取得します
            public var nsImage: NSImage? {
                OmokakeResources.image(named: rawValue)
            }
        #endif
    }
}

#if !SWIFT_PACKAGE
    private final class BundleToken {}
#endif
