%1@start "" "%~dp0cmd.exe" "/c %~fs0 :"
%1@exit
@echo off
::ȫ�ֳ���
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

::֡��
set fRate=60
set decSleep=0
::�Ƿ���֡�ʼ��(�������ڱ�������ʾfps����Ϣ)
set fpsMonitor=true
::��ʼ������
set CAPI=API Call Kernel32 SetConsoleTitleW "$DemoApplication"
set /a "menuHeight/=2"
set CAPI=Mem Alloc 8
set lpCCI=%CAPI_Ret%
set CAPI=Mem Put ;%lpCCI% ;100
set CAPI=API Call kernel32 SetConsoleCursorInfo ;%hOut% ;%lpCCI%
set CAPI=Mem Free %lpCCI%
::���ڻ���
set res_cmd=%hDC%
::�����ı��洢��
set CAPI=Mem Alloc 512
set txt=%CAPI_Ret%
::������ͼ����
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
::���̰���״̬��⺯��
set "keyState=set CAPI=API Call user32 GetForegroundWindow&set temp=!CAPI_Ret!&set CAPI=API Call user32 GetKeyState ;#&set keyState.isKeyDown=false&if !CAPI_Ret! geq 32768 if !temp!==!hCMD! (set keyState.isKeyDown=true) else if !CAPI_Ret! leq -127 if !temp!==!hCMD! (set keyState.isKeyDown=true)"
::��Ƶ������غ���(֧��mp3��wav��ʽ)
set "loadSnd=%readArgs%&set CAPI=API Call winmm mciSendStringW "$open !arg1! alias !arg2! wait" ;0 ;0 ;0"
set "play=set CAPI=API Call winmm mciSendStringW "$play #" ;0 ;0 ;0"
set "playLoop=set CAPI=API Call winmm mciSendStringW "$play # repeat" ;0 ;0 ;0"
set "pause=set CAPI=API Call winmm mciSendStringW "$pause #" ;0 ;0 ;0"
set "stop=set CAPI=API Call winmm mciSendStringW "$stop #" ;0 ;0 ;0"
::����
set "sleep=set /a temp=#&set CAPI=API Call Kernel32 Sleep ;!temp!"
::�û��Զ��庯��

::���ڼ����Լ��
setlocal enabledelayedexpansion
for /l %%a in (0,1,!totalFonts!) do (
	set CAPI=API Call Kernel32 GetConsoleFontSize ;%hOut% ;%%a
	set size%%a=!CAPI_Ret!
)
for /l %%a in (0,1,!totalFonts!) do (
	if !size%%a!==1048584 set ctr=%%a
)
if not defined ctr (
	echo ���Ŀ���̨Ŀǰ��֧�ִ����ֺţ�16x8
	echo �������δ�����ɰ����̨ģʽ�����ȿ����ɰ����̨ģʽ��
	echo ��ѡ�����塰�������塱��
	pause
	exit
)
set CAPI=API Call Kernel32 SetConsoleFont ;%hOut% ;!ctr!
::������ʼ
mode con lines=37 cols=81
(%setAppLogo:#="$resources\gfx\demo.ico"%)
(%load:@="$resources\gfx\demo.bmp",bin%)
(%load:@="$resources\gfx\dot1.bmp",dot1%)
(%load:@="$resources\gfx\dot2.bmp",dot2%)
(%load:@="$resources\gfx\dot3.bmp",dot3%)
(%load:@="$resources\gfx\dot4.bmp",dot4%)
(%load:@="$resources\gfx\dot5.bmp",dot5%)
(%loadSnd:@="resources\audio\Jumper.mp3",bgm%)
(%loadSnd:@="resources\sfx\end.wav",end%)
(%buf:@=buf,650,600%)
(%buf:@=buf2,650,600%)
(%buf:@=dot,32,32%)
(%setFont:@=buf2,΢���ź�,1000,20%)
(%setFont:@=buf,AngryBirdsText,1000,14%)
set x=90
set x2=580
set a=18 
set a2=0
set fx=-1
set fx2=-1
set ctr=0
set fcount=0
set fps=0
set dotseq=1
(%playLoop:#=bgm%)
(%draw:@=bin,buf2,0,0,650,600%)
(%drawText:@=buf2,230,260,247,153,20,$����һ�����ԡ�,7%)
(%drawText:@=buf2,230,290,247,153,20,$�밴�ո����������,9%)
(%draw:@=buf2,buf,0,0,650,600%)
(%draw:@=buf,cmd,0,0,650,600%)
(%unload:#=bin%)
set CAPI=API Call winmm timeGetTime
set old_tcount=!CAPI_Ret!
:loop
set CAPI=API Call winmm timeGetTime
set tcount=!CAPI_Ret!
if !ctr!==0 (
	set ctr=1
) else (
	set ctr=0
)
set /a "dx=(180+x/2)+84"
set /a "dy=(165+x2/2)-8"
set /a "rnd=(%random% %% 3) + 1"
set /a "rnd2=(%random% %% 3) + 1"
if !fcount!==30 set /a dotseq+=1
if !dotseq! gtr 5 set dotseq=1
set c3=!draw:@=dot%dotseq%,dot,0,0,32,32!
%c3%
if !fcount! geq 30 %drawTrans:@=dot,buf,dx,dy,32,32,0,0,255%
(%draw:@=buf,cmd,0,0,650,600%)
set /a x+=a
set /a x2+=a2
if !fx! neq 0 set bfx=!fx!
if !fx! neq 0 (
	set fx=0
) else (
	if !a! leq -18 (
		set /a "fx=rnd"
	) else if !a! geq 18 (
		set /a "fx=-rnd"
	) else (
		set fx=!bfx!
	)
)
if !fx2! neq 0 set bfx2=!fx2!
if !fx2! neq 0 (
	set fx2=0
) else (
	if !a2! leq -18 (
		set /a "fx2=rnd2"
	) else if !a2! geq 18 (
		set /a "fx2=-rnd2"
	) else (
		set fx2=!bfx2!
	)
)
set /a a+=fx
set /a a2+=fx2
set CAPI=API Call winmm timeGetTime
set paint_tcount=!CAPI_Ret!
set /a tgap=tcount-old_tcount
set /a pgap=paint_tcount-tcount
set /a "sleepTime=1000/fRate-pgap"
if !tgap! geq 1000 (
	set CAPI=API Call winmm timeGetTime
	set old_tcount=!CAPI_Ret!
	set tcount=!old_tcount!
	if !fpsMonitor!==true set CAPI=API Call Kernel32 SetConsoleTitleW "$DemoApplication fps:!fps!f/s sfpt:!pgap!ms"
	set /a fpsLimit=!fps!-!fRate!
	if !fpsLimit! gtr 3 set /a "decSleep-=1"
	if !fpsLimit! lss -3 set /a "decSleep+=1"
	set fps=0
)
set /a sleepTime-=decSleep
if !sleepTime! gtr 0 %sleep:#=sleepTime%
(%keyState:#=32%)
if !keyState.isKeyDown!==true goto :next
set /a fcount+=1
set /a fps+=1
if !fcount! geq 60 set fcount=0
goto :loop
:next
(%play:#=end%)
(%stop:#=bgm%)
(%getPix:@=cmd,312,411%)
pause
echo 2.5���ʼ��ⰴ��
(%sleep:#=2500%)
(%keyState:#=38%)
echo ������
(%sleep:#=500%)
echo ������������Ƿ���^: !keyState.isKeyDown!
set color=!getPix.color!
set /a "B=color / 65536"
set /a "G=(!color! %% 65536) / 256"
set /a R=!color! - (!G! * 256) - (!B! * 65536)
echo (312,411)������ɫֵ: RGB(!R!, !G!, !B!)
echo �����ڽ���10���رա�
(%sleep:#=10000%)
::����������ͷ���Դ
set CAPI=Mem Free %txt%