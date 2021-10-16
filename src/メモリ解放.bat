@echo off

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 機能名　　　：　メモリ解放
rem :: 概要概要　　：　メモリを解放する。
rem :: 入力
rem :: 　引数１　　：　(なし)
rem :: 出力
rem :: 　戻り値　　：　0(正常終了)、1(異常終了)
rem :: 備考　　　　：　実行前にWindowsServer2003ResourceKitToolsを
rem :: 　　　　　　　　インストールすること。
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 変数設定（ユーザ設定項目）
rem :: ★バッチを使用する前にユーザが設定すること★
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 変数設定（バッチ設定項目）
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

rem 変数名：終了ステータス
set RT_OK=0
set RT_NG=1

rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
rem :: 処理開始
rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

echo ■処理開始■

echo �@メモリ解放
empty *

echo �A正常終了
pause
exit /b %RT_OK%

:END_NG
echo �A異常終了
pause
exit /b %RT_NG%
