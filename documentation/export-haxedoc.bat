:: Zajac Framework
:: Exporting documentation using haxedoc

mkdir haxedoc
haxe -swf all.swf -lib nme -D code_completion --no-output -xml haxedoc/haxedoc.xml -cp ../ ImportAll
copy haxedoc-template.xml haxedoc\template.xml
copy tmp\haxedoc.xml haxedoc\haxedoc.xml
cd haxedoc
haxedoc haxedoc.xml -f rs
del template.xml
del haxedoc.xml
cd ..