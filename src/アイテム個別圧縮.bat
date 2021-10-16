@echo off

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 機能名　　　：　アイテム個別圧縮
rem :: 概要概要　　：　指定したアイテムを個別で圧縮する。
rem :: 入力
rem :: 　引数１　　：　アイテムパス(複数可)　※ローカルパスのみ
rem :: 出力
rem :: 　戻り値　　：　0(正常終了)、1(異常終了)
rem :: 　ファイル　：　アイテムの圧縮ファイル(複数)
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 変数設定（ユーザ設定項目）
rem :: ★バッチを使用する前にユーザが設定すること★
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem 変数名：圧縮解凍ソフト
set ZIP_EXE="C:\Program Files\7-Zip\7z.exe"

echo ■設定値（ユーザ設定項目）■
echo   ZIP_EXE = %ZIP_EXE%
echo;

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 変数設定（バッチ設定項目）
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem 変数名：終了ステータス
set RT_OK=0
set RT_NG=1

rem 変数名：引数の数
set NUM_OF_ARGS=0

echo ■設定値（バッチ設定項目）■
echo   NUM_OF_ARGS = %NUM_OF_ARGS%
echo;

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 処理開始
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo ■処理開始■

echo ①引数チェック

if not exist %ZIP_EXE% (
	echo 　エラー①：圧縮解凍ソフトが見つかりません。
	echo 　　　　　　・%ZIP_EXE%
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

echo ②アイテムの個別圧縮

for %%I in (%*) do (
	set ITEM_PATH=%%~I
	setlocal EnableDelayedExpansion
	
	echo ■■圧縮対象■■：!ITEM_PATH!
	%ZIP_EXE% a -tzip "!ITEM_PATH!.zip" "!ITEM_PATH!"
	
	if %ERRORLEVEL% neq %RT_OK% (
		goto END_NG
	)
	
	endlocal
)

echo ③正常終了
pause
exit /b %RT_OK%

:END_NG
echo ③異常終了
pause
exit /b %RT_NG%
