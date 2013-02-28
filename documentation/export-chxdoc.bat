:: Zajac Framework
:: Exporting documentation using chxdoc
:: Configuratoin file can be provided as argument with following variables defined:
::	CHXDOC
::	TPLSDIR
::	CLEANER
::	DEST
@Echo Off

SET CHXDOC=chxdoc.exe
SET TPLSDIR=templates
SET CLEANER=cleaner.exe
SET DEST=chxdocs

If Not "%~1" == "" (
	If Not Exist "%~1" (
		Echo Configuration file does not exist, quitting.
		GoTo :EOF
	)
	For /f "delims=" %%x in (%~1) do (set "%%x")
)

mkdir tmp
haxe -swf all.swf -lib nme -D code_completion --no-output -xml tmp/haxedoc.xml -cp ../ ImportAll
SET SWITCHES=--showPrivateClasses=false --showPrivateMethods=false --showPrivateVars=false --showMeta=true
SET TEXTS=--title="Zajac" --subtitle="Haxe UI Framework" --footerText="<a href=\"http://www.zajac.rs/\" target="_blank">www.zajac.rs</a>"
SET FILTERING=--policy=allow --allow=rs.*
%CHXDOC% -o %DEST% --tmpDir=tmp -f tmp/haxedoc.xml --templatesDir=%TPLSDIR% %SWITCHES% %TEXTS% %FILTERING%
rmdir /S /Q tmp

If Exist "%CLEANER%" (
	copy /Y %CLEANER% %DEST%\%CLEANER%
	cd %DEST%
	%CLEANER%
	del %CLEANER%
	cd ..
)

@Echo On