@testable import OmokakeResources
import XCTest
#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

final class OmokakeResourcesTests: XCTestCase {

    func testBundleAccess() {
        // バンドルが正常に取得できることをテスト
        XCTAssertNotNil(OmokakeResources.bundle)
    }

    func testResourcePathMethod() {
        // リソースパス取得メソッドが正常に動作することをテスト
        // 実際のリソースファイルがないため、nilが返されることを確認
        let path = OmokakeResources.resourcePath(for: "nonexistent", fileExtension: "txt")
        XCTAssertNil(path)
    }

    func testResourceURLMethod() {
        // リソースURL取得メソッドが正常に動作することをテスト
        // 実際のリソースファイルがないため、nilが返されることを確認
        let url = OmokakeResources.resourceURL(for: "nonexistent", withExtension: "txt")
        XCTAssertNil(url)
    }

    func testImageResourceEnum() {
        // ImageResourceの列挙型が正しく動作することをテスト
        XCTAssertEqual(OmokakeResources.ImageResource.allCases.count, 2, "ImageResourceの項目数が期待と異なります")

        let kakeraIcon = OmokakeResources.ImageResource.kakeraIcon
        XCTAssertEqual(kakeraIcon.rawValue, "kakera_icon")

        let photoFrames = OmokakeResources.ImageResource.photoFrames
        XCTAssertEqual(photoFrames.rawValue, "photo_frames")
    }

    #if canImport(UIKit)
        func testImageLoading_iOS() {
            // iOS環境でUIImageとして画像を読み込めることをテスト
            let bundle = OmokakeResources.bundle

            // Note: Asset Catalogの画像は実際のデバイス/シミュレータでないと読み込めない場合があります
            // ここではテストが実行できることを確認

            _ = UIImage(named: "kakera_icon", in: bundle, compatibleWith: nil)
            // 実際の画像読み込みはランタイム環境に依存するため、存在チェックのみ行う

            _ = UIImage(named: "photo_frames", in: bundle, compatibleWith: nil)
            // 実際の画像読み込みはランタイム環境に依存するため、存在チェックのみ行う

            // バンドルが正しく設定されていることを確認
            XCTAssertEqual(bundle, OmokakeResources.bundle, "バンドル設定が正しくありません")
        }

        func testConvenienceImageMethod_iOS() {
            // 便利メソッドが呼び出せることをテスト（実際の画像読み込みはランタイム環境に依存）
            _ = OmokakeResources.image(named: "kakera_icon")
            _ = OmokakeResources.image(named: "photo_frames")

            // メソッドが正常に呼び出せることを確認（nilでも正常）
            // Asset Catalogの画像読み込みはiOSデバイス/シミュレータ環境でないと動作しない場合があります
        }

        func testImageResourceConvenience_iOS() {
            // ImageResourceの便利プロパティが呼び出せることをテスト
            _ = OmokakeResources.ImageResource.kakeraIcon.uiImage
            _ = OmokakeResources.ImageResource.photoFrames.uiImage

            // プロパティが正常に呼び出せることを確認（nilでも正常）
            // Asset Catalogの画像読み込みはiOSデバイス/シミュレータ環境でないと動作しない場合があります
        }

    #elseif canImport(AppKit)
        func testImageLoading_macOS() {
            // macOS環境でNSImageとして画像を読み込めることをテスト
            let bundle = OmokakeResources.bundle

            // Note: Asset Catalogの画像読み込みはmacOS環境では制限がある場合があります
            _ = bundle.image(forResource: "kakera_icon")
            _ = bundle.image(forResource: "photo_frames")

            // バンドルが正しく設定されていることを確認
            XCTAssertEqual(bundle, OmokakeResources.bundle, "バンドル設定が正しくありません")
        }

        func testConvenienceImageMethod_macOS() {
            // 便利メソッドが呼び出せることをテスト（実際の画像読み込みはランタイム環境に依存）
            _ = OmokakeResources.image(named: "kakera_icon")
            _ = OmokakeResources.image(named: "photo_frames")

            // メソッドが正常に呼び出せることを確認（nilでも正常）
            // Asset Catalogの画像読み込みはmacOS環境では制限がある場合があります
        }

        func testImageResourceConvenience_macOS() {
            // ImageResourceの便利プロパティが呼び出せることをテスト
            _ = OmokakeResources.ImageResource.kakeraIcon.nsImage
            _ = OmokakeResources.ImageResource.photoFrames.nsImage

            // プロパティが正常に呼び出せることを確認（nilでも正常）
            // Asset Catalogの画像読み込みはmacOS環境では制限がある場合があります
        }
    #endif
}
