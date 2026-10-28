@echo off
chcp 65001 > nul
cls
title BAT COMPILER v4.5

:: Define output directory (one level up) and filename
set "output_dir=.."
set "output_file=%output_dir%\compiled_output.bat"

:: Initialize the compiled file with default safe header
echo @echo off > "%output_file%"
echo chcp 65001 ^> nul >> "%output_file%"
echo cls >> "%output_file%"

echo ===================================================
echo                 BAT COMPILER v4.5                  
echo ===================================================
echo  Type ANY command. Shorthands: ec, pa, cl, co, fs.
echo  Special: Start with ':' to declare a label.
echo  Type 'exit' to finish compilation.
echo ===================================================
echo.

:loop
set "cmd_input="
:: Request input from the user
set /p cmd_input="[COMPILER] Enter command: "

:: Handle empty input safely
if not defined cmd_input goto loop

:: Strip potential dangerous quote symbols
set "cmd_input=%cmd_input:"=%"

:: Terminate compilation block if user types exit
if /i "%cmd_input%"=="exit" goto finalize

:: --- LABEL ANALYSIS BLOCK ---
:: Extract the first character to check for label declaration
set "first_char=%cmd_input:~0,1%"
if "%first_char%"==":" (
    echo %cmd_input% >> "%output_file%"
    echo [LABEL] Created loop point: %cmd_input%
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

:: --- UNIVERSAL PASSTHROUGH (1000+ COMMANDS ENGINE) ---
:: If input is not a shorthand, write it directly to the file
echo %cmd_input% >> "%output_file%"
echo [RAW] Compiled as-is: %cmd_input%
echo.
goto loop

:: --- SHORTHAND PROCESSORS ---
:do_echo
set "text_arg="
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
set /p color_arg="  -^> Enter color attribute (e.g. 0A): "
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
:: Open the newly built file in Notepad for immediate inspection
start notepad.exe "%output_file%"
exit
