SETLOCAL ENABLEEXTENSIONS

@ECHO ---------------------
@ECHO Arguments:
@ECHO   Target directory = %1
@ECHO ---------------------
SET TARGETDIR=%1

@REM Create unix/ subdirectory including any parent directories (extensions are enabled)
MKDIR %TARGETDIR%\unix

@REM Create all/emptytop/ subdirectory including any parent directories (extensions are enabled)
MKDIR %TARGETDIR%\all\emptytop

@REM Copy in binary mode so that CRLF is not added
XCOPY /Y /H /N /I META                             %TARGETDIR%
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /N /I template.dkmlroot                %TARGETDIR%
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /N /I unix\_common_tool.sh             %TARGETDIR%\unix
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /N /I unix\_within_dev.sh              %TARGETDIR%\unix
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /N /I unix\crossplatform-functions.sh  %TARGETDIR%\unix
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
XCOPY /Y /H /N /I all\emptytop\dune-project        %TARGETDIR%\all\emptytop
IF %ERRORLEVEL% NEQ 0 (Echo Error during XCOPY &Exit /b 1)
