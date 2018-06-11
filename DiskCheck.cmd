@echo off

:: Config
set logfile=DiskCheck.log
set tempfile=DiskCheck.txt

:: Init
if exist %tempfile% del %tempfile%
set error=0

:: Check disks (S.M.A.R.T.)
wmic diskdrive get deviceid,status|find "PHYSICALDRIVE"|find /v "OK" >> %tempfile%
if %errorlevel%==0 set error=1

:: Check NTFS volumes
echo list volume|diskpart|find "NTFS"|find /v "Healthy" >> %tempfile%
if %errorlevel%==0 set error=1

:: On errors
if %error%==1 (
  set /p password=<password.txt
  Mailer.exe -u jeftadirksen@gmail.com -p %password% -t jeftadirksen@gmail.com -s "DiskCheck Error" -b "See attachment" -a %tempfile%
)

:end
if exist %tempfile% del %tempfile%
