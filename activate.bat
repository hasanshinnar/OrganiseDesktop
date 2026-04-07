@echo off
:: START ADMIN AUTO-ELEVATE - IT CHECKS IF THE USER HAS ADMIN PRIVILEGES AND RESTARTS THE SCRIPT WITH ELEVATED PRIVILEGES IF NOT
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /b

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    :: IMPORTANT: Move to the directory where the script is located
    cd /d "%~dp0"


:: Your original logic starts here
if exist organise_desktop_env\ (
    call :load_env
) else (
    echo Creating new virtual environment...
    pip install virtualenv
    virtualenv organise_desktop_env
    
    if not exist virtual_desktop mkdir virtual_desktop
    
    call :load_env
    
    if %ERRORLEVEL% EQU 0 (
        if exist requirements.txt (
            pip install -r requirements.txt
        ) else (
            echo.
            echo [INFO] requirements.txt not found. Skipping library installation.
            echo.
        )
    ) else (
        echo Loading the environment has failed
    )
)

pause
exit /b

:load_env
call organise_desktop_env\Scripts\activate.bat
set TEST_DIR=%CD%\virtual_desktop
echo Environment loaded as Admin in: %CD%
exit /b 0