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
@REM   Since .template.dkmlroot goes into library, we drop the leading dot to avoid any future findlib problems
XCOPY /Y /H /N /I .template.dkmlroot               %TARGETDIR%
IF EXIST %TARGETDIR%\template.dkmlroot DEL   /F /Q %TARGETDIR%\template.dkmlroot 
REN   %TARGETDIR%\.template.dkmlroot               template.dkmlroot 
XCOPY /Y /H /N /I unix\_common_tool.sh             %TARGETDIR%\unix
XCOPY /Y /H /N /I unix\_within_dev.sh              %TARGETDIR%\unix
XCOPY /Y /H /N /I unix\crossplatform-functions.sh  %TARGETDIR%\unix
XCOPY /Y /H /N /I all\emptytop\dune-project        %TARGETDIR%\all\emptytop
