.PHONY: help setup format

# デフォルトターゲット - ヘルプの表示
help:
	@echo "利用可能なコマンド:"
	@echo "  make setup  - SwiftFormatをセットアップします"
	@echo "  make format - SwiftFormatでコードをフォーマットします"
	@echo "  make help   - このヘルプを表示します"

# SwiftFormatのセットアップ
setup:
	@echo "SwiftFormatをセットアップしています..."
	@which brew > /dev/null || (echo "Homebrewがインストールされていません。まずHomebrewをインストールしてください。" && exit 1)
	@if ! which swiftformat > /dev/null; then \
		echo "SwiftFormatをインストールしています..."; \
		brew install swiftformat; \
	else \
		echo "SwiftFormatは既にインストールされています"; \
		swiftformat --version; \
	fi
	@echo "SwiftFormatのセットアップが完了しました"

# SwiftFormatの実行
format:
	@echo "SwiftFormatでコードをフォーマットしています..."
	@if ! which swiftformat > /dev/null; then \
		echo "SwiftFormatがインストールされていません。'make setup'を実行してください"; \
		exit 1; \
	fi
	swiftformat Omokake/ --verbose 