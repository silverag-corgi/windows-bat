@echo off

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 機能名　　　：　アイテム同期
rem :: 概要概要　　：　アイテムを同期(ミラーリング・バックアップ)する。
rem :: 入力
rem :: 　引数１　　：　バックアップ元フォルダ　(例：H:\Documents)
rem :: 　引数２　　：　バックアップ先フォルダ　(例：F:)
rem :: 出力
rem :: 　戻り値　　：　0(正常終了)、1(異常終了)
rem :: 　ファイル　：　ログファイル(log_[yyyymmdd]-[hhmmss].txt)
rem :: 備考　　　　：　引数にネットワークパスを指定する際は、
rem :: 　　　　　　　　事前に資格情報を入力して認証済みにすること。
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 変数設定（ユーザ設定項目）
rem :: ★バッチを使用する前にユーザが設定すること★
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem 変数名：ログフォルダ
rem 概要　：ログファイルを出力するフォルダのパスを設定する。
set LOG_DIR=..\log

echo ■設定値（ユーザ設定項目）■
echo   LOG_DIR = %LOG_DIR%
echo;

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 変数設定（バッチ設定項目）
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem 変数名：終了ステータス
set RT_OK=0
set RT_NG=1

rem 変数名：引数の数
set NUM_OF_ARGS=0

rem 変数名：年月日
rem 概要　：年月日をyyyymmdd形式で取得する。
set YMD=%DATE:/=%

rem 変数名：時分秒
rem 概要　：時分秒をHHmmss形式で取得する。
set HMS=%TIME: =0%
set HMS=%HMS:~0,2%%HMS:~3,2%%HMS:~6,2%

rem 変数名：ログファイル
rem 概要　：ログファイルのパスを設定する。
set LOG_FILE=%LOG_DIR%\log_%YMD%-%HMS%.txt

echo ■設定値（バッチ設定項目）■
echo   NUM_OF_ARGS = %NUM_OF_ARGS%
echo   YMD = %YMD%
echo   HMS = %HMS%
echo   LOG_FILE = %LOG_FILE%
echo;

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 処理開始
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo ■処理開始■

echo ①引数チェック

if not exist %LOG_DIR% (
	echo 　エラー①：ログファイルを出力するフォルダが存在しません。
	echo 　　　　　　・%LOG_DIR%
	goto END_NG
)
for %%I in (%*) do (
	set /a NUM_OF_ARGS=NUM_OF_ARGS+1
)
if %NUM_OF_ARGS% neq 2 (
	echo 　エラー②：引数の数に過不足があります。
	goto END_NG
)
if  not exist "%~1" (
	echo 　エラー④：バックアップ元フォルダが存在しません。
	echo 　　　　　　・%1
	goto END_NG
)

echo ②ミラーリング・バックアップの実行

set BKUP_SRC=%~1
set BKUP_DST=%~2

rem 使用例
rem 	robocopy バックアップ元フォルダ バックアップ先フォルダ [オプション]
rem オプション(コピー)
rem 	/b					: □アクセス権無いデータの強制バックアップ　※BackupOperators権限付与
rem 	/copy:dat			: □コピー情報(d=データ、a=属性、t=タイムスタンプ)　※規定値
rem 	/dcopy:da			: □コピー情報(d=データ、a=属性)　※規定値
rem 	/mir				: ★ミラーリング　※なぜかフォルダのタイムスタンプもコピーされる。
rem オプション(ファイル選択)
rem 	/xd					: ★フォルダの除外
rem 	/xj					: ★ジャンクション・シンボリックリンクの除外
rem オプション(再試行)
rem 	/r:0				: ★再コピー試行回数(回)
rem 	/w:0				: ★再試行待機時間(秒)
rem オプション(ログ)
rem 	/log+:[log_file]	: ★ログ出力(ファイル)
rem 	/tee				: ★ログ出力(コマンドライン)
rem 	/ts					: ★ファイルのタイムスタンプ表示
rem 	/fp					: ★ファイルの絶対パス表示
rem 	/ns					: ★ファイルのサイズ非表示
rem 	/np					: ★進行状況非表示
robocopy "%BKUP_SRC%" "%BKUP_DST%" ^
			/mir ^
			/xd "System Volume Information" "$RECYCLE.BIN" /xj ^
			/r:0 /w:0 ^
			/log+:"%LOG_FILE%" /tee /ts /fp /ns /np

echo 　ログファイルをエディタで開きます。
echo 　・%LOG_FILE%
start %LOG_FILE%

echo ③正常終了
exit /b %RT_OK%

:END_NG
echo ③異常終了
exit /b %RT_NG%
