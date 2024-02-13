:: Welcome to a ClamAV 1.3.0 batch script for Windows
:: Written by Camina Shell 2024-02 https://github.com/caminashell
:: Tested on 11-23H2 22631.3085 [2024-02-11 12:40:34]

:: Download Clam Anti Virus for free from: https://www.clamav.net

:: I share my scripts for research, education, and public support.
:: By using this script you accept that I (caminashell) am not responsible for
:: any damage or corruption to your property.

:: All dates are in ISO 8601 format: YYYY-MM-DD

:: It is recommended to run this script as admin.
:: Careful: Testing this script can get you rate limited on CDN for 24hrs.
::          Advised to echo the execution: $AV/freshclam
::          or better; set up a mirror as suggested by CLamAV.


:: Setting up the script
@echo off
setlocal
:: This permits the use of UTF-8 characters.
chcp 65001 > nul

:: This assumes that you have installed ClamAV to the default from the installer.
set AV=C:\Program Files\ClamAV\

:: This is Basically your home folder documents location.
set DIR=%HOMEDRIVE%%HOMEPATH%\Documents

:: This is creating a timestamp for the scan.
:: The stripping could probably be reduced as it's a bit lazy. Windows bat scripting is weird.
set STAMP=%DATE::=%@%TIME::=%
set STAMP=%STAMP:-=%
set STAMP=%STAMP:.=%
set STAMP=%STAMP: =%
set STAMP=%STAMP:@=-%

echo.
:: A little note for the user, just in case. Let's hope they (can) read!
echo NOTE: This script should be run as administrator. & echo.

:: This execution attempts to update the viri databases. It will fail if it cannot access the remote host.
"%AV%freshclam.exe"

echo.
:: This will ask you to enter a full path as a target to can.
:: It can be a directory or file, but it should be a full path.
:: Examples:
:: a:\
:: b:\some\path\to\a\folder
:: c:\some\path\to\a\single\file.txt
set /P SCAN=Enter FULL path to scan [do not use quotes]:
echo.

:: This just tells you the timestamp as a Scan ID.
echo Scan ID: %STAMP%

:: Creating some subdirectories for scan.
mkdir %DIR%\ClamAV\%STAMP%
mkdir %DIR%\ClamAV\%STAMP%\infected

:: Setting up and testing the log file. If the scan fails, you should see only "Log File Created."
set DIR=%DIR%\ClamAV
echo. 2>%DIR%\%STAMP%\report.log
echo "Log File Created." > "%DIR%\%STAMP%\report.log"

:: If you want to test the command line below without executing it, put "echo " at the beginning of the line.
"%AV%clamscan.exe" -a -r -l="%DIR%\%STAMP%\report.log" --exclude-dir="%DIR%" --bell --copy="%DIR%\%STAMP%\infected" "%SCAN%"

:: An additional summary to the user...
echo ------------------------------------ & echo.
echo  [✓] Scan report file saved to: %DIR%\%STAMP%\report.log
echo  [✓] Infected file/s COPIED to: %DIR%\%STAMP%\infected & echo.

:: ... and because some people just aren't savvy...
echo  !!! CAUTION !!! DO NOT ATTEMPT TO OPEN OR EXECUTE ANY INFECTED FILES.
echo                  YOU RISK INFECTING OR DAMAGING YOUR SYSTEM. & echo.
echo  Some results can be false positive, so seek further advice and guidance.
echo  If you are worried, back up your sensitive data. Be smart. & echo.

:: Thank you for checking out my little script for ClamAV - the best FREE + OPEN SOURCE cross-platform Anti-virus.
:: I hope it helps you deter any bad news on your system, or at least provide some education.
