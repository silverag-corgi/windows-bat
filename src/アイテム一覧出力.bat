@echo off

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 機能名　　　：　アイテム一覧出力
rem :: 概要概要　　：　アイテムの絶対パスの一覧を再帰的に出力する。
rem :: 入力
rem :: 　引数１　　：　アイテムパス(複数可)　※ローカルパスのみ
rem :: 出力
rem :: 　戻り値　　：　0(正常終了)、1(異常終了)
rem :: 　ファイル　：　アイテム一覧ファイル(list_[yyyymmdd]-[hhmmss].txt)
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 変数設定（ユーザ設定項目）
rem :: ★バッチを使用する前にユーザが設定すること★
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem 変数名：アイテム一覧フォルダ
rem 概要　：アイテム一覧ファイルを出力するフォルダのパスを設定する。
set ITEM_LIST_DIR=..\output\list

echo ■設定値（ユーザ設定項目）■
echo   ITEM_LIST_DIR = %ITEM_LIST_DIR%
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

rem 変数名：アイテム一覧ファイル
rem 概要　：アイテム一覧ファイルのパスを設定する。
set ITEM_LIST_FILE=%ITEM_LIST_DIR%\list_%YMD%-%HMS%.txt

echo ■設定値（バッチ設定項目）■
echo   NUM_OF_ARGS = %NUM_OF_ARGS%
echo   YMD = %YMD%
echo   HMS = %HMS%
echo   ITEM_LIST_FILE = %ITEM_LIST_FILE%
echo;

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 処理開始
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo ■処理開始■

echo ①引数チェック

if not exist %ITEM_LIST_DIR% (
	echo 　エラー①：アイテム一覧ファイルを出力するフォルダが存在しません。
	echo 　　　　　　・%ITEM_LIST_DIR%
	goto END_NG
)
for %%I in (%*) do (
	set /a NUM_OF_ARGS=NUM_OF_ARGS+1
)
if %NUM_OF_ARGS% equ 0 (
	echo 　エラー②：アイテムパスが指定されていません。
	goto END_NG
)
for %%I in (%*) do (
	set ITEM_PATH=%%~I
	setlocal EnableDelayedExpansion
	
	if "!ITEM_PATH:~0,2!" == "\\" (
		echo 　エラー③：アイテムパスにネットワークパスが指定されています。
		echo 　　　　　　・!ITEM_PATH!
		goto END_NG
	)
	if  not exist "!ITEM_PATH!" (
		echo 　エラー④：アイテムパスが存在しません。
		echo 　　　　　　・!ITEM_PATH!
		goto END_NG
	)
	
	endlocal
)

echo ②アイテム一覧ファイルの出力

for %%I in (%*) do (
	set ITEM_PATH=%%~I
	setlocal EnableDelayedExpansion
	
	echo 　出力対象：!ITEM_PATH!
	WHERE /R "!ITEM_PATH!" *.* >> "%ITEM_LIST_FILE%" /F /T
	
	if !ERRORLEVEL! neq %RT_OK% (
		goto END_NG
	)
	
	endlocal
)

echo 　アイテム一覧ファイルを出力しました。エディタで開きます。
echo 　・%ITEM_LIST_FILE%
start %ITEM_LIST_FILE%

echo ③正常終了
pause
exit /b %RT_OK%

:END_NG
echo ③異常終了
pause
exit /b %RT_NG%
