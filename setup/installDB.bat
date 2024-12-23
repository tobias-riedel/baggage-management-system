@echo off
setlocal enabledelayedexpansion

REM Load configuration.
for /f "delims=" %%x in (..\config.cfg.php) do (set "%%x")

cd ..\sql

REM Replace wildcards in SQL setup file.
set INTEXTFILE=install.sql.tpl
set OUTTEXTFILE=%INTEXTFILE%.tpm
set SEARCHTEXT=@db_name

for /f "tokens=1,* delims=¶" %%A in ( '"type %INTEXTFILE%"') do (
	set string=%%A
	set modified=!string:%SEARCHTEXT%=%DB_NAME%!
	echo !modified! >> %OUTTEXTFILE%
)

REM Perform the setup.
%SQL_WIN_BIN% -u%DB_USER% -p%DB_PWD% < %OUTTEXTFILE%

REM Clean up.
del %OUTTEXTFILE%