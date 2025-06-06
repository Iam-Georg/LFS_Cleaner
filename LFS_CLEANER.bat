@echo off
:: Adminrechte prüfen
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:MENU
cls
color 04
echo.
echo.                                       ========================================
echo.                                                 LFS   CLEANER   V1
echo.                                                      by  Georg
echo.                                       ========================================
echo.
echo.                                            1. Clean TEMP folders
echo.                                            2. Clean FiveM cache folders
echo.                                            3. Clean All
echo.                                            4. Exit
echo.

set choice=
set /p choice=                                      Choose an option (1-4): 

:: Wenn keine Eingabe oder "4" -> EXIT
if "%choice%"=="" goto EXIT
if "%choice%"=="4" goto EXIT

if "%choice%"=="1" goto CLEAN_TEMP
if "%choice%"=="2" goto CLEAN_FIVEM
if "%choice%"=="3" goto CLEAN_ALL
goto MENU

:CLEAN_TEMP
cls
echo.
echo.                                            Cleaning TEMP folders...
del /f /s /q "%TEMP%\*.*" >nul 2>&1
for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1
del /f /s /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i" >nul 2>&1
del /f /s /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo.
echo.                                            TEMP folders successfully cleaned!
echo.
::pause
goto MENU

:CLEAN_FIVEM
cls
echo.
echo.                                            Cleaning FiveM cache folders...
set "FIVEM_CACHE=%LOCALAPPDATA%\FiveM\FiveM.app\data\cache"
set "FIVEM_SERVER_CACHE=%LOCALAPPDATA%\FiveM\FiveM.app\data\server-cache"
set "FIVEM_SERVER_CACHE_PRIV=%LOCALAPPDATA%\FiveM\FiveM.app\data\server-cache-priv"
set "FIVEM_LOGS=%LOCALAPPDATA%\FiveM\FiveM.app\logs"
set "FIVEM_CRASHES=%LOCALAPPDATA%\FiveM\FiveM.app\crashes"

for %%F in ("%FIVEM_CACHE%" "%FIVEM_SERVER_CACHE%" "%FIVEM_SERVER_CACHE_PRIV%" "%FIVEM_LOGS%" "%FIVEM_CRASHES%") do (
    if exist "%%F" (
        del /f /s /q "%%F\*.*" >nul 2>&1
        for /d %%i in ("%%F\*") do rd /s /q "%%i" >nul 2>&1
    )
)
echo.
echo.                                            FiveM cache successfully cleaned!
echo.
::pause
goto MENU

:CLEAN_ALL
cls
echo.
echo.                                            Performing full clean...
call :CLEAN_TEMP
call :CLEAN_FIVEM
echo.
echo.                                            All folders successfully cleaned!
echo.
::pause
goto MENU

::redirect zum original discord
:EXIT
start https://discord.gg/QR4az8AcZP
exit
