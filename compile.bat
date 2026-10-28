@echo off
chcp 65001 > nul
cls
title BAT COMPILER v5.0 - Visual Studio Edition

:: Set color scheme: Blue background (1), White text (F)
color 1F

:: Define output directory (one level up / parent folder)
set "output_dir=.."
set "output_file=%output_dir%\compiled_output.bat"

:: Initialize the compiled file with default header
echo @echo off > "%output_file%"
echo chcp 65001 ^> nul >> "%output_file%"
echo cls >> "%output_file%"

echo ===================================================
echo     BAT COMPILER v5.0 - VISUAL STUDIO EDITION     
echo ===================================================
echo  [IntelliSense Active] Suggestions will appear.
echo  File saves one directory higher (parent folder).
echo  Type 'exit' to finish compilation.
echo ===================================================
echo.

:loop
set "cmd_input="
echo [IntelliSense] Suggestions: ec (echo) ^| pa (pause) ^| cl (cls) ^| co (color) ^| fs (fullscreen) ^| del_head (delete @echo off)
set /p cmd_input="[COMPILER] Enter command: "

if not defined cmd_input goto loop
set "cmd_input=%cmd_input:"=%"

if /i "%cmd_input%"=="exit" goto finalize

:: --- SPECIAL OPERATIONS ---
:: Remove the automated @echo off header from the output file if requested
if /i "%cmd_input%"=="del_head" (
    echo. > "%output_file%"
    echo [INTELLISENSE] Header @echo off deleted from output file!
    echo.
    goto loop
)

:: --- LABEL ANALYSIS BLOCK ---
set "first_char=%cmd_input:~0,1%"
if "%first_char%"==":" (
    echo %cmd_input% >> "%output_file%"
    echo [LABEL] Compiled: %cmd_input%
    echo.
    goto loop
)

:: --- SHORTHAND SYNTAX PATTERNS ---
if /i "%cmd_input%"=="ec" goto do_echo
if /i "%cmd_input%"=="ech" goto do_echo
if /i "%cmd_input%"=="echo" goto do_echo

if /i "%cmd_input%"=="pa" goto do_pause
if /i "%cmd_input%"=="pau" goto do_pause
if /i "%cmd_input%"=="pause" goto do_pause

if /i "%cmd_input%"=="cl" goto do_cls
if /i "%cmd_input%"=="cls" goto do_cls

if /i "%cmd_input%"=="co" goto do_color
if /i "%cmd_input%"=="col" goto do_color
if /i "%cmd_input%"=="color" goto do_color

if /i "%cmd_input%"=="fs" goto do_fullscreen
if /i "%cmd_input%"=="full" goto do_fullscreen
if /i "%cmd_input%"=="fullscreen" goto do_fullscreen

:: --- UNIVERSAL PASSTHROUGH ENGINE ---
echo %cmd_input% >> "%output_file%"
echo [RAW] Compiled as-is: %cmd_input%
echo.
goto loop

:: --- SHORTHAND PROCESSORS ---
:do_echo
set "text_arg="
echo [IntelliSense hint] Type the message you want to print on the screen.
set /p text_arg="  -^> Enter text to print: "
echo echo %text_arg% >> "%output_file%"
echo [SUCCESS] Compiled: echo %text_arg%
echo.
goto loop

:do_pause
echo pause >> "%output_file%"
echo [SUCCESS] Compiled: pause
echo.
goto loop

:do_cls
echo cls >> "%output_file%"
echo [SUCCESS] Compiled: cls
echo.
goto loop

:do_color
set "color_arg="
echo [IntelliSense hint] Standard values: 0A (Green), 0C (Red), 1F (Blue/White).
set /p color_arg="  -^> Enter color attribute: "
echo color %color_arg% >> "%output_file%"
echo [SUCCESS] Compiled: color %color_arg%
echo.
goto loop

:do_fullscreen
echo if not "%%1"=="max" ( start /max "" "%%~f0" max ^& exit /b ) >> "%output_file%"
echo [SUCCESS] Compiled: Fullscreen dynamic block
echo.
goto loop

:finalize
echo.
echo ===================================================
echo [BUILD COMPLETE] File successfully saved to:
echo %output_file%
echo ===================================================
start notepad.exe "%output_file%"
exit
