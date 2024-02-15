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
:: Fixed exclusion. Was regex, not path.
"%AV%clamscan.exe" --archive-verbose --recursive --log="%DIR%\%STAMP%\report.log" --exclude-dir=ClamAV --bell --copy="%DIR%\%STAMP%\infected" "%SCAN%"

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

::                        Clam AntiVirus: Scanner 1.3.0
::            By The ClamAV Team: https://www.clamav.net/about.html#credits
::            (C) 2024 Cisco Systems, Inc.
:: 
::     clamscan [options] [file/directory/-]
:: 
::     --help                -h                     Show this help
::     --version             -V                     Print version number
::     --verbose             -v                     Be verbose
::     --archive-verbose     -a                     Show filenames inside scanned archives
::     --debug                                      Enable libclamav's debug messages
::     --quiet                                      Only output error messages
::     --stdout                                     Write to stdout instead of stderr. Does not affect 'debug' messages.
::     --no-summary                                 Disable summary at end of scanning
::     --infected            -i                     Only print infected files
::     --suppress-ok-results -o                     Skip printing OK files
::     --bell                                       Sound bell on virus detection
:: 
::     --tempdir=DIRECTORY                          Create temporary files in DIRECTORY
::     --leave-temps[=yes/no(*)]                    Do not remove temporary files
::     --gen-json[=yes/no(*)]                       Generate JSON metadata for the scanned file(s). For testing & development use ONLY.
::                                                  JSON will be printed if --debug is enabled.
::                                                  A JSON file will dropped to the temp directory if --leave-temps is enabled.
::     --database=FILE/DIR   -d FILE/DIR            Load virus database from FILE or load all supported db files from DIR
::     --official-db-only[=yes/no(*)]               Only load official signatures
::     --fail-if-cvd-older-than=days                Return with a nonzero error code if virus database outdated.
::     --log=FILE            -l FILE                Save scan report to FILE
::     --recursive[=yes/no(*)]  -r                  Scan subdirectories recursively
::     --allmatch[=yes/no(*)]   -z                  Continue scanning within file after finding a match
::     --cross-fs[=yes(*)/no]                       Scan files and directories on other filesystems
::     --follow-dir-symlinks[=0/1(*)/2]             Follow directory symlinks (0 = never, 1 = direct, 2 = always)
::     --follow-file-symlinks[=0/1(*)/2]            Follow file symlinks (0 = never, 1 = direct, 2 = always)
::     --file-list=FILE      -f FILE                Scan files from FILE
::     --remove[=yes/no(*)]                         Remove infected files. Be careful!
::     --move=DIRECTORY                             Move infected files into DIRECTORY
::     --copy=DIRECTORY                             Copy infected files into DIRECTORY
::     --exclude=REGEX                              Don't scan file names matching REGEX
::     --exclude-dir=REGEX                          Don't scan directories matching REGEX
::     --include=REGEX                              Only scan file names matching REGEX
::     --include-dir=REGEX                          Only scan directories matching REGEX
::     --memory                                     Scan loaded executable modules
::     --kill                                       Kill/Unload infected loaded modules
::     --unload                                     Unload infected modules from processes
:: 
::     --bytecode[=yes(*)/no]                       Load bytecode from the database
::     --bytecode-unsigned[=yes/no(*)]              Load unsigned bytecode
::                                                  **Caution**: You should NEVER run bytecode signatures from untrusted sources.
::                                                  Doing so may result in arbitrary code execution.
::     --bytecode-timeout=N                         Set bytecode timeout (in milliseconds)
::     --statistics[=none(*)/bytecode/pcre]         Collect and print execution statistics
::     --detect-pua[=yes/no(*)]                     Detect Possibly Unwanted Applications
::     --exclude-pua=CAT                            Skip PUA sigs of category CAT
::     --include-pua=CAT                            Load PUA sigs of category CAT
::     --detect-structured[=yes/no(*)]              Detect structured data (SSN, Credit Card)
::     --structured-ssn-format=X                    SSN format (0=normal,1=stripped,2=both)
::     --structured-ssn-count=N                     Min SSN count to generate a detect
::     --structured-cc-count=N                      Min CC count to generate a detect
::     --structured-cc-mode=X                       CC mode (0=credit debit and private label, 1=credit cards only
::     --scan-mail[=yes(*)/no]                      Scan mail files
::     --phishing-sigs[=yes(*)/no]                  Enable email signature-based phishing detection
::     --phishing-scan-urls[=yes(*)/no]             Enable URL signature-based phishing detection
::     --heuristic-alerts[=yes(*)/no]               Heuristic alerts
::     --heuristic-scan-precedence[=yes/no(*)]      Stop scanning as soon as a heuristic match is found
::     --normalize[=yes(*)/no]                      Normalize html, script, and text files. Use normalize=no for yara compatibility
::     --scan-pe[=yes(*)/no]                        Scan PE files
::     --scan-elf[=yes(*)/no]                       Scan ELF files
::     --scan-ole2[=yes(*)/no]                      Scan OLE2 containers
::     --scan-pdf[=yes(*)/no]                       Scan PDF files
::     --scan-swf[=yes(*)/no]                       Scan SWF files
::     --scan-html[=yes(*)/no]                      Scan HTML files
::     --scan-xmldocs[=yes(*)/no]                   Scan xml-based document files
::     --scan-hwp3[=yes(*)/no]                      Scan HWP3 files
::     --scan-onenote[=yes(*)/no]                   Scan OneNote files
::     --scan-archive[=yes(*)/no]                   Scan archive files (supported by libclamav)
::     --alert-broken[=yes/no(*)]                   Alert on broken executable files (PE & ELF)
::     --alert-broken-media[=yes/no(*)]             Alert on broken graphics files (JPEG, TIFF, PNG, GIF)
::     --alert-encrypted[=yes/no(*)]                Alert on encrypted archives and documents
::     --alert-encrypted-archive[=yes/no(*)]        Alert on encrypted archives
::     --alert-encrypted-doc[=yes/no(*)]            Alert on encrypted documents
::     --alert-macros[=yes/no(*)]                   Alert on OLE2 files containing VBA macros
::     --alert-exceeds-max[=yes/no(*)]              Alert on files that exceed max file size, max scan size, or max recursion limit
::     --alert-phishing-ssl[=yes/no(*)]             Alert on emails containing SSL mismatches in URLs
::     --alert-phishing-cloak[=yes/no(*)]           Alert on emails containing cloaked URLs
::     --alert-partition-intersection[=yes/no(*)]   Alert on raw DMG image files containing partition intersections
::     --nocerts                                    Disable authenticode certificate chain verification in PE files
::     --dumpcerts                                  Dump authenticode certificate chain in PE files
:: 
::     --max-scantime=#n                            Scan time longer than this will be skipped and assumed clean (milliseconds)
::     --max-filesize=#n                            Files larger than this will be skipped and assumed clean
::     --max-scansize=#n                            The maximum amount of data to scan for each container file (**)
::     --max-files=#n                               The maximum number of files to scan for each container file (**)
::     --max-recursion=#n                           Maximum archive recursion level for container file (**)
::     --max-dir-recursion=#n                       Maximum directory recursion level
::     --max-embeddedpe=#n                          Maximum size file to check for embedded PE
::     --max-htmlnormalize=#n                       Maximum size of HTML file to normalize
::     --max-htmlnotags=#n                          Maximum size of normalized HTML file to scan
::     --max-scriptnormalize=#n                     Maximum size of script file to normalize
::     --max-ziptypercg=#n                          Maximum size zip to type reanalyze
::     --max-partitions=#n                          Maximum number of partitions in disk image to be scanned
::     --max-iconspe=#n                             Maximum number of icons in PE file to be scanned
::     --max-rechwp3=#n                             Maximum recursive calls to HWP3 parsing function
::     --pcre-match-limit=#n                        Maximum calls to the PCRE match function.
::     --pcre-recmatch-limit=#n                     Maximum recursive calls to the PCRE match function.
::     --pcre-max-filesize=#n                       Maximum size file to perform PCRE subsig matching.
::     --disable-cache                              Disable caching and cache checks for hash sums of scanned files.
:: 
:: Pass in - as the filename for stdin.
:: 
:: (*) Default scan settings
:: (**) Certain files (e.g. documents, archives, etc.) may in turn contain other
::    files inside. The above options ensure safe processing of this kind of data.
:: 
:: 