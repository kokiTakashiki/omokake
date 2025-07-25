# OmokakeResources

`OmokakeResources`は、Omokakeプロジェクト内で共通のリソース管理を提供するSwift Package Managerパッケージです。

## 概要

このパッケージは以下の機能を提供します：
- 共通リソースファイルへの統一されたアクセス方法
- Swift Package Manager対応
- iOS、macOS、visionOS全プラットフォーム対応
- Bundle.moduleを使用した効率的なリソース管理

## 対応プラットフォーム

- iOS 13.0+
- macOS 26.0+
- visionOS 26.0+

## インストール

### Swift Package Managerを使用（project.yml）

```yaml
packages:
  OmokakeResources:
    path: Package/OmokakeResources

targets:
  YourTarget:
    dependencies:
      - package: OmokakeResources
```

### Package.swiftで直接使用

```swift
dependencies: [
    .package(path: "../OmokakeResources")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["OmokakeResources"]
    )
]
```

## 使用方法

### 基本的な使用方法

```swift
import OmokakeResources

// バンドルへのアクセス
let bundle = OmokakeResources.bundle

// リソースファイルのパスを取得
if let imagePath = OmokakeResources.resourcePath(for: "sample", fileExtension: "png") {
    // パスを使用してリソースにアクセス
    print("Image path: \(imagePath)")
}

// リソースファイルのURLを取得
if let audioURL = OmokakeResources.resourceURL(for: "sound", withExtension: "wav") {
    // URLを使用してリソースにアクセス
    print("Audio URL: \(audioURL)")
}
```

### 画像リソースの読み込み

```swift
import OmokakeResources
import UIKit

func loadImage(named imageName: String) -> UIImage? {
    guard let imageURL = OmokakeResources.resourceURL(for: imageName, withExtension: "png") else {
        return nil
    }
    return UIImage(contentsOfFile: imageURL.path)
}

// 使用例
let icon = loadImage(named: "app_icon")
```

### 音声リソースの読み込み

```swift
import OmokakeResources
import AVFoundation

func loadAudioPlayer(for soundName: String) -> AVAudioPlayer? {
    guard let soundURL = OmokakeResources.resourceURL(for: soundName, withExtension: "wav") else {
        return nil
    }
    
    do {
        return try AVAudioPlayer(contentsOf: soundURL)
    } catch {
        print("Failed to load audio: \(error)")
        return nil
    }
}

// 使用例
let audioPlayer = loadAudioPlayer(for: "tap_sound")
```

### その他のリソースファイル

```swift
import OmokakeResources

// JSONファイルの読み込み
func loadJSONData<T: Codable>(fileName: String, type: T.Type) -> T? {
    guard let jsonURL = OmokakeResources.resourceURL(for: fileName, withExtension: "json") else {
        return nil
    }
    
    do {
        let data = try Data(contentsOf: jsonURL)
        return try JSONDecoder().decode(type, from: data)
    } catch {
        print("Failed to load JSON: \(error)")
        return nil
    }
}

// テキストファイルの読み込み
func loadTextFile(named fileName: String) -> String? {
    guard let textURL = OmokakeResources.resourceURL(for: fileName, withExtension: "txt") else {
        return nil
    }
    
    return try? String(contentsOf: textURL)
}
```

## リソースファイルの配置

リソースファイルは以下のディレクトリに配置してください：

```
Package/OmokakeResources/Sources/OmokakeResources/Resources/
├── images/
│   ├── icon.png
│   └── background.jpg
├── sounds/
│   ├── tap.wav
│   └── notification.mp3
├── data/
│   └── config.json
└── texts/
    └── readme.txt
```

## API リファレンス

### OmokakeResources

#### Properties

- `bundle: Bundle` - パッケージのBundleインスタンス

#### Methods

- `resourcePath(for fileName: String, fileExtension: String?) -> String?`
  - 指定されたファイル名のリソースファイルパスを取得
  
- `resourceURL(for fileName: String, withExtension fileExtension: String?) -> URL?`
  - 指定されたファイル名のリソースファイルURLを取得

## 注意事項

- リソースファイルは`Sources/OmokakeResources/Resources/`ディレクトリに配置する必要があります
- ファイル名は大文字小文字を区別します
- 存在しないリソースファイルを指定した場合、メソッドは`nil`を返します
- iOS、macOS、visionOSで共通のリソースを使用できますが、プラットフォーム固有のリソースが必要な場合は適切に分けて配置してください

## ライセンス

このパッケージはOmokakeプロジェクトの一部として提供されています。 