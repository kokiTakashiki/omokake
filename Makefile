.PHONY: help setup format generate open

# デフォルトターゲット - ヘルプの表示
help:
	@echo "利用可能なコマンド:"
	@echo "  make setup    - 開発環境をセットアップします（SwiftFormat & XcodeGen）"
	@echo "  make format   - SwiftFormatでコードをフォーマットします"
	@echo "  make generate - XcodeGenでOmokake.xcodeprojを生成します"
	@echo "  make open     - Omokake.xcodeprojをXcodeで開きます"
	@echo "  make help     - このヘルプを表示します"

# 開発環境のセットアップ（SwiftFormat & XcodeGen）
setup:
	@echo "開発環境をセットアップしています..."
	@which brew > /dev/null || (echo "Homebrewがインストールされていません。まずHomebrewをインストールしてください。" && exit 1)
	@echo "必要なツールをインストールしています..."
	@if ! which swiftformat > /dev/null; then \
		echo "SwiftFormatをインストール中..."; \
		brew install swiftformat; \
	else \
		echo "SwiftFormatは既にインストール済み"; \
		swiftformat --version; \
	fi
	@if ! which xcodegen > /dev/null; then \
		echo "XcodeGenをインストール中..."; \
		brew install xcodegen; \
	else \
		echo "XcodeGenは既にインストール済み"; \
		xcodegen --version; \
	fi
	@echo "プロジェクトファイルを生成しています..."
	@$(MAKE) generate
	@echo "セットアップが完了しました！"

# SwiftFormatの実行
format:
	@echo "SwiftFormatでコードをフォーマットしています..."
	@if ! which swiftformat > /dev/null; then \
		echo "SwiftFormatがインストールされていません。'make setup'を実行してください"; \
		exit 1; \
	fi
	swiftformat Omokake/ Package/ --verbose

# XcodeGenでプロジェクトファイルを生成
generate:
	@echo "XcodeGenでOmokake.xcodeprojを生成しています..."
	@if ! which xcodegen > /dev/null; then \
		echo "XcodeGenがインストールされていません。'make setup'を実行してください"; \
		exit 1; \
	fi
	@if [ ! -f project.yml ]; then \
		echo "project.ymlファイルが見つかりません"; \
		exit 1; \
	fi
	xcodegen generate
	@echo "Omokake.xcodeprojの生成が完了しました"

# XcodeでプロジェクトファイルをOpen
open:
	@echo "Omokake.xcodeprojをXcodeで開いています..."
	@if [ ! -d "Omokake.xcodeproj" ]; then \
		echo "Omokake.xcodeprojファイルが見つかりません。'make generate'を実行してプロジェクトファイルを生成してください"; \
		exit 1; \
	fi
	open Omokake.xcodeproj 