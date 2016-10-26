@echo off

REM What's your project name?
set EXENAME=myapp

set INCLUDE_PATHS=
set LIB_PATHS= 
set LIBRARIES=kernel32.lib ^
user32.lib ^
gdi32.lib ^
winspool.lib ^
comdlg32.lib ^
advapi32.lib ^
shell32.lib ^
ole32.lib ^
oleaut32.lib ^
uuid.lib ^
odbc32.lib ^
odbccp32.lib ^
winmm.lib ^
Shlwapi.lib ^
legacy_stdio_definitions.lib

set COMPILER_ARGS= /D "_UNICODE" /D "UNICODE" /GS /GL /analyze- /W3 /Gy /Zc:wchar_t /EHsc /MT /WX- /Zc:forScope /Gd /Oy- /Oi /Gm- /O2 /nologo

REM Searching for a toolset. Preferring the newest

if defined VS140COMNTOOLS (
    set VCVARSALLPATH= "%VS140COMNTOOLS%..\..\VC\vcvarsall"
) else if defined VS120COMNTOOLS (
    set VCVARSALLPATH= "%VS120COMNTOOLS%..\..\VC\vcvarsall"
) else if defined VS110COMNTOOLS (
    set VCVARSALLPATH= "%VS110COMNTOOLS%..\..\VC\vcvarsall"
) else if defined VS100COMNTOOLS (
    set VCVARSALLPATH= "%VS100COMNTOOLS%..\..\VC\vcvarsall"
) else if defined VS90COMNTOOLS (
    set VCVARSALLPATH= "%VS90COMNTOOLS%..\..\VC\vcvarsall"
)

if not defined VCVARSALLPATH (
    echo No build system been found, abort.
    exit /b 1
)

if not defined DevEnvDir (call %VCVARSALLPATH%)

REM =============================================

REM Collect all source files
setlocal enableextensions enabledelayedexpansion
set SOURCES=
for /F %%A in ('dir /b /S *.cpp *.res') do set SOURCES=!SOURCES! "%%A"

if exist build.txt (
    set /p BUILDINDEX=<build.txt
    set BUILDDIR=build\!BUILDINDEX!
) else (
    set BUILDDIR=build
)


mkdir %BUILDDIR%
mkdir obj
pushd obj
cl %INCLUDE_PATHS% ^
%COMPILER_ARGS% ^
%SOURCES% ^
/link ^
/OUT:"..\%BUILDDIR%\%EXENAME%.exe" ^
%LIBRARIES% ^
/MACHINE:X86 ^
/OPT:REF ^
/SAFESEH ^
/OPT:ICF ^
/ERRORREPORT:PROMPT ^
/NOLOGO ^
%LIB_PATHS% ^
/TLBID:1

if exist ..\build.txt (
    if %ERRORLEVEL% EQU 0 (
        popd
        set /a BUILDINDEX=!BUILDINDEX!+1
        >build.txt echo !BUILDINDEX!
    ) else (
        popd
    )
) else (
    popd
)