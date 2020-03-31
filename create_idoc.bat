<!-- : Begin batch script
@echo off & setlocal

set start=%time%

title Spreadsheet to IDoc (stoidoc)
del /q %~n1.txt 2>NUL


cscript //nologo "%~f0?.wsf" %1 %~n1.txt

SET source_path ="C:\Create IDOC\InFiles\stoidoc"
cd %source_path%

stoidoc.exe %~n1.txt
del /q %~n1.txt
set end=%time%

REM Calculate time taken in seconds, to the hundredth of a second.
REM Assumes start time and end time will be on the same day.

set options="tokens=1-4 delims=:."

for /f %options% %%a in ("%start%") do (
    set /a start_s="(100%%a %% 100)*3600 + (100%%b %% 100)*60 + (100%%c %% 100)"
    set /a start_hs=100%%d %% 100
)

for /f %options% %%a in ("%end%") do (
    set /a end_s="(100%%a %% 100)*3600 + (100%%b %% 100)*60 + (100%%c %% 100)"
    set /a end_hs=100%%d %% 100
)

set /a s=%end_s%-%start_s%
set /a hs=%end_hs%-%start_hs%

if %hs% lss 0 (
    set /a s=%s%-1
    set /a hs=100%hs%
)
if 1%hs% lss 100 set hs=0%hs%

echo.
echo Time elapsed in batch file: %s%.%hs% secs
echo.
pause
exit /b

----- Begin wsf script --->
<job><script language="VBScript">
  	' -4158 converts an xlsx file to a txt file.
	txt_format = -4158

	Set objFSO = CreateObject("Scripting.FileSystemObject")

	src_file = objFSO.GetAbsolutePathName(Wscript.Arguments.Item(0))
	dest_file = objFSO.GetAbsolutePathName(WScript.Arguments.Item(1))

	' before we convert the xlsx to txt, delete old txt if it exists
	if objFSO.FileExists(dest_file) then
	    objFSO.DeleteFile dest_file
	end if

	Dim oExcel
	Set oExcel = CreateObject("Excel.Application")

	Dim oBook
	Set oBook = oExcel.Workbooks.Open(src_file)

	oBook.SaveAs dest_file, txt_format 

	oBook.Close False
	oExcel.Quit
</script></job>