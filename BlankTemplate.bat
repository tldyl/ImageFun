%1@start "" "%~dp0cmd.exe" "/c %~fs0 :"
%1@exit
@echo off
::全局常量
set CAPI=API Call Kernel32 GetConsoleWindow
set hCMD=%CAPI_Ret%

set CAPI=API Call user32 GetWindowDC ;%hCMD%
set hDC=%CAPI_Ret%

set CAPI=API Call Kernel32 GetStdHandle ;-11
set hOut=%CAPI_Ret%

set CAPI=API Call user32 GetDC ;0
set CAPI=API Call gdi32 GetDeviceCaps ;%CAPI_Ret% ;90
set cap=%CAPI_Ret%

set CAPI=API Call user32 GetSystemMetrics ;29
set titleBarHeight=%CAPI_Ret%

set CAPI=API Call user32 GetSystemMetrics ;6
set borderWidth=%CAPI_Ret%

set CAPI=API Call user32 GetSystemMetrics ;15
set menuHeight=%CAPI_Ret%

set CAPI=API Call Kernel32 GetNumberOfConsoleFonts
set /a totalFonts=CAPI_Ret-1

::帧率
set fRate=60
set decSleep=0
::是否开启帧率监测(开启会在标题上显示fps等信息)
set enableFpsMonitor=true
::初始化窗口
set appTitle=空白模板标题
set CAPI=API Call Kernel32 SetConsoleTitleW "$%appTitle%"
set /a "menuHeight/=2"
set CAPI=Mem Alloc 8
set lpCCI=%CAPI_Ret%
set CAPI=Mem Put ;%lpCCI% ;100
set CAPI=API Call kernel32 SetConsoleCursorInfo ;%hOut% ;%lpCCI%
set CAPI=Mem Free %lpCCI%
::窗口画布
set res_cmd=%hDC%
::绘制文本存储区
set CAPI=Mem Alloc 512
set txt=%CAPI_Ret%
::基础绘图函数
set "readArgs=set ctr=0&(for %%a in (@) do (set /a ctr+=1&set "arg!ctr!=%%a"))"
set "load=%readArgs%&set CAPI=API Call user32 LoadImageW ;!hCMD! !arg1! ;0 ;0 ;0 ;16&set temp=!CAPI_Ret!&set CAPI=API Call gdi32 CreateCompatibleDC ;!hDC!&set hDCTmp=!CAPI_Ret!&set CAPI=API Call gdi32 SelectObject ;!hDCTmp! ;!temp!&set res_!arg2!=!hDCTmp!&set res_!arg2!.bmp=!temp!"
set "unload=set CAPI=API Call gdi32 SelectObject ;!res_#! ;!res_#.bmp!&set temp=!CAPI_Ret!&set CAPI=API Call gdi32 DeleteObject ;!temp!&set CAPI=API Call gdi32 DeleteDC ;!res_#!&set "res_#=""
set "buf=%readArgs%&set CAPI=API Call gdi32 CreateCompatibleDC ;!hDC!&set hDCTmp=!CAPI_Ret!&set CAPI=API Call gdi32 CreateCompatibleBitmap ;!hDC! ;!arg2! ;!arg3!&set temp=!CAPI_Ret!&set CAPI=API Call gdi32 SelectObject ;!hDCTmp! ;!temp!&set CAPI=API Call gdi32 BitBlt ;!hDCTmp! ;0 ;0 ;!arg2! ;!arg3! ;0 ;0 ;0 ;16711778&set res_!arg1!=!hDCTmp!&set CAPI=API Call gdi32 SelectObject ;!hDCTmp! ;!temp!&set res_!arg1!.bmp=!CAPI_Ret!&set res_!arg1!.width=!arg2!&set res_!arg1!.height=!arg3!"
set "draw=%readArgs%&set /a src=res_!arg1!&set /a dest=res_!arg2!&set /a "arg3=!arg3!"&set /a "arg4=!arg4!"&set /a "arg5=!arg5!"&set /a "arg6=!arg6!"&(if !arg2!==cmd set /a arg3+=menuHeight+borderWidth&set /a arg4+=titleBarHeight)&set CAPI=API Call gdi32 BitBlt ;!dest! ;!arg3! ;!arg4! ;!arg5! ;!arg6! ;!src! ;0 ;0 ;13369376"
set "drawTrans=%readArgs%&set /a "arg3=!arg3!"&set /a "arg4=!arg4!"&set /a "arg5=!arg5!"&set /a "arg6=!arg6!"&set /a temp=arg9*65536+arg8*256+arg7&set /a src=res_!arg1!&set /a dest=res_!arg2!&set CAPI=API Call Msimg32 TransparentBlt ;!dest! ;!arg3! ;!arg4! ;!arg5! ;!arg6! ;!src! ;0 ;0 ;!arg5! ;!arg6! ;!temp!"
set "cls=set CAPI=API Call user32 InvalidateRect ;!hCMD! ;0 ;1"
set "setFont=%readArgs%&set /a hTMP=-arg4*cap/72&set CAPI=API Call gdi32 CreateFontW ;!hTMP! ;0 ;0 ;0 ;!arg3! ;0 ;0 ;0 ;1 ;0 ;0 ;2 ;0 "$!arg2!"&set temp=!CAPI_Ret!&set /a hTMP=res_!arg1!&set CAPI=API Call gdi32 SelectObject ;!hTMP! ;!temp!&set CAPI=API Call gdi32 SetBkMode ;!hTMP! ;0"
set "drawText=%readArgs%&set CAPI=Mem Put ;!txt! !arg7!&set /a hTMP=res_!arg1!&set /a temp=arg6*65536+arg5*256+arg4&set CAPI=API Call gdi32 SetTextColor ;!hTMP! ;!temp!&set CAPI=API Call gdi32 TextOutW ;!hTMP! ;!arg2! ;!arg3! ;!txt! ;!arg8!"
set "getPix=%readArgs%&set /a hTMP=res_!arg1!&set CAPI=API Call gdi32 GetPixel ;!hTMP! ;!arg2! ;!arg3!&set getPix.color=!CAPI_Ret!"
set "setAppLogo=set CAPI=API Call user32 LoadImageW ;0 # ;1 ;0 ;0 ;16&set CAPI=API Call Kernel32 SetConsoleIcon ;!CAPI_Ret!"
set "fpsMonitor=set CAPI=API Call winmm timeGetTime&set paint_tcount=!CAPI_Ret!&set /a tgap=tcount-old_tcount&set /a pgap=paint_tcount-tcount&set /a fps+=1&set /a "sleepTime=1000/fRate-pgap"&(if !tgap! geq 1000 (set CAPI=API Call winmm timeGetTime&set old_tcount=!CAPI_Ret!&set tcount=!old_tcount!&(if !enableFpsMonitor!==true set CAPI=API Call Kernel32 SetConsoleTitleW "$!appTitle! fps:!fps!f/s sfpt:!pgap!ms")&set /a fpsLimit=!fps!-!fRate!&(if !fpsLimit! gtr 3 set /a "decSleep-=1")&(if !fpsLimit! lss -3 set /a "decSleep+=1")&set fps=0))&set /a sleepTime-=decSleep&(if !sleepTime! gtr 0 set CAPI=API Call Kernel32 Sleep ;!sleepTime!)"
::键盘按键状态检测函数
set "keyState=set CAPI=API Call user32 GetForegroundWindow&set temp=!CAPI_Ret!&set CAPI=API Call user32 GetKeyState ;#&set keyState.isKeyDown=false&if !CAPI_Ret! geq 32768 if !temp!==!hCMD! (set keyState.isKeyDown=true) else if !CAPI_Ret! leq -127 if !temp!==!hCMD! (set keyState.isKeyDown=true)"
::音频管理相关函数(支持mp3、wav格式)
set "loadSnd=%readArgs%&set CAPI=API Call winmm mciSendStringW "$open !arg1! alias !arg2! wait" ;0 ;0 ;0"
set "play=set CAPI=API Call winmm mciSendStringW "$play #" ;0 ;0 ;0"
set "playLoop=set CAPI=API Call winmm mciSendStringW "$play # repeat" ;0 ;0 ;0"
set "pause=set CAPI=API Call winmm mciSendStringW "$pause #" ;0 ;0 ;0"
set "stop=set CAPI=API Call winmm mciSendStringW "$stop #" ;0 ;0 ;0"
::杂项
set "sleep=set /a temp=#&set CAPI=API Call Kernel32 Sleep ;!temp!"
::用户自定义函数

::窗口兼容性检查
setlocal enabledelayedexpansion
for /l %%a in (0,1,!totalFonts!) do (
	set CAPI=API Call Kernel32 GetConsoleFontSize ;%hOut% ;%%a
	set size%%a=!CAPI_Ret!
)
for /l %%a in (0,1,!totalFonts!) do (
	if !size%%a!==1048584 set ctr=%%a
)
if not defined ctr (
	echo 您的控制台目前不支持此种字号：16x8
	echo 如果您尚未开启旧版控制台模式，请先开启旧版控制台模式。
	echo 并选用字体“点阵字体”。
	pause
	exit
)
set CAPI=API Call Kernel32 SetConsoleFont ;%hOut% ;!ctr!
set fps=0
::主程序开始
mode con lines=37 cols=81
set CAPI=API Call winmm timeGetTime
set old_tcount=!CAPI_Ret!
:loop
set CAPI=API Call winmm timeGetTime
set tcount=!CAPI_Ret!
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::以下是你自己的代码::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::以上是你自己的代码::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
(%fpsMonitor%)
goto :loop
::程序结束，释放资源
set CAPI=Mem Free %txt%