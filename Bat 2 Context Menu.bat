@echo off
setlocal enabledelayedexpansion

REM Set the subfolder name
set "subfolder=%~dp0\Copy your bats in here"

REM Set the destination folder
set "destinationFolder=C:\Scripts"

REM Check if the destination folder exists; if not, create it
if not exist "%destinationFolder%" (
    mkdir "%destinationFolder%"
)

if not exist "%subfolder%" (
    echo Put all your bat files in the folder:
    echo Copy your bats in here
    echo then run me again
    mkdir "%subfolder%"
    pause
    exit
)
else (

REM Get the full path of the "secondBat" file and the name of the folder it needs to create
for %%F in ("%subfolder%\*.bat") do (
    set "secondBatFile=%%~fF"
    set "folder2create=%%~nF"
    mkdir "%destinationFolder%\!folder2create!"

    REM Copy the "secondBat" file to the destination folder
    copy "!secondBatFile!" "%destinationFolder%\!folder2create!"

    REM Create the content of the temporery Install .reg file with the variable
    set "regContent=[HKEY_CLASSES_ROOT\Directory\Background\shell\!folder2create!]"
    setlocal enabledelayedexpansion
    (
        echo Windows Registry Editor Version 5.00
        echo.
        echo [HKEY_CLASSES_ROOT\Directory\Background\shell\!folder2create!]
        echo @="&!folder2create!"
        echo.
        echo [HKEY_CLASSES_ROOT\Directory\Background\shell\!folder2create!\command]
        echo @="\"C:\\Scripts\\!folder2create!\\!folder2create!.bat\""
    ) > "%temp%\tempfile.reg"

    REM Import the temporary .reg file to the registry
    regedit.exe /s "%temp%\tempfile.reg"


    REM Delete the temporary .reg file
    del "%temp%\tempfile.reg"


      REM Create the Content of the Uninstall .reg file with the variable
    set "regContent=[HKEY_CLASSES_ROOT\Directory\Background\shell\!folder2create!]"
    setlocal enabledelayedexpansion
    (
        echo Windows Registry Editor Version 5.00
        echo.
        echo [-HKEY_CLASSES_ROOT\Directory\Background\shell\!folder2create!]
        echo @="&!nameandformat!"
        echo.
        echo [-HKEY_CLASSES_ROOT\Directory\Background\shell\!folder2create!\command]
        echo @="\"C:\\Scripts\\!folder2create!\\!folder2create!.bat\""
    ) > "C:\\Scripts\!folder2create!\remove key.reg"


Rem *************** Create uninstall.bat file
setlocal enabledelayedexpansion
(
    echo @echo off 
    echo.

    echo REM Path to the .reg file
    echo set "regFilePath=C:\Scripts\!folder2create!\remove key.reg"

    echo. 
    echo REM Run the .reg file using regedit
    echo start /wait regedit /s "C:\Scripts\!folder2create!\remove key.reg"

    echo.

    echo call "remove folder.bat"
    
    ) > "C:\\Scripts\!folder2create!\uninstall.bat"
    

Rem **************** creating remove folder bat
(
    echo @echo off
    echo.

    echo cd ..
    echo rd /s /q "C:\Scripts\!folder2create!") > "C:\Scripts\!folder2create!\remove folder.bat"


endlocal

)


endlocal