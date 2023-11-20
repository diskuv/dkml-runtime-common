SETLOCAL ENABLEEXTENSIONS

@ECHO ---------------------
@ECHO Arguments:
@ECHO   Target directory = %1
@ECHO ---------------------
SET TARGETDIR=%1

@REM Create macos/ subdirectory including any parent directories (extensions are enabled)
MKDIR "%TARGETDIR%\macos"

@REM Create unix/ subdirectory including any parent directories (extensions are enabled)
MKDIR "%TARGETDIR%\unix"

@REM Copy in binary mode so that CRLF is not added
XCOPY /Y /H /I META                             "%TARGETDIR%"
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /I template.dkmlroot                "%TARGETDIR%"
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /I macos\brewbundle.sh              "%TARGETDIR%\macos"
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /I unix\_common_tool.sh             "%TARGETDIR%\unix"
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /I unix\_within_dev.sh              "%TARGETDIR%\unix"
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /I unix\crossplatform-functions.sh  "%TARGETDIR%\unix"
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
