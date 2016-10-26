@echo off
if not defined DevEnvDir (call "%VS140COMNTOOLS%..\..\VC\vcvarsall")

set EXENAME=routes

REM Collect all source files
setlocal enableextensions enabledelayedexpansion
set SOURCES=
for /F %%A in ('dir /b /S *.cpp *.res') do set SOURCES=!SOURCES! "%%A"

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
/D "_UNICODE" ^
/D "UNICODE" ^
/GS ^
/GL ^
/analyze- ^
/W3 ^
/Gy ^
/Zc:wchar_t ^
/EHsc ^
/MT ^
/WX- ^
/Zc:forScope ^
/Gd ^
/Oy- ^
/Oi ^
/Gm- ^
/O2 ^
/nologo ^
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