:: Zajac Framework
:: Exporting documentation using chxdoc

SET CHXDOC=C:\tools\chxdoc\chxdoc.exe
SET TPLSDIR=C:\tools\chxdoc\templates

mkdir tmp
haxe -swf all.swf -lib nme -D code_completion --no-output -xml tmp/haxedoc.xml -cp ../ ImportAll
SET SWITCHES=--showPrivateClasses=false --showPrivateMethods=true --showPrivateVars=false --showMeta=true
SET TEXTS=--title="Zajac" --subtitle="Haxe UI Framework" --footerText="(c) FOOTER TEXT 2013"
SET FILTERING=--policy=deny --allow=rs.*
%CHXDOC% -o chxdocs --tmpDir=tmp -f tmp/haxedoc.xml --templatesDir=%TPLSDIR% %SWITCHES% %TEXTS% %FILTERING%
rmdir /S /Q tmp