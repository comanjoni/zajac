package be.zajac.util;
import nme.Assets;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author Ilic S Stojan
 */

class TextFieldUtil {

	public static var DEFAULT_FONT:String;
	
	public function new() {
		
	}
	
	/*public static function fillField(field:TextField, ?fontName:String = null, ?color:Int = 0xffffff, ?size:Int = 14, ?align:TextFormatAlign = null):Void {
		
	}*/
	
	/**
	 * 
	 * @param	field - textfield to be filled with properties
	 * @param	properties - textformat and textfield properties. Names are the same as class TextField and TextFormat property names
	 */
	public static function fillFieldFromObject(field:TextField, properties:Dynamic):Void {
		var key:String;
		var c_font:Font;
		var c_prop:Hash<Dynamic>;
		var c_format:TextFormat;
		
		if (field == null || properties == null) return;
		
		//c_format = new TextFormat();
		c_format = field.getTextFormat();
		if (Reflect.hasField(properties, "fontName") == false) Reflect.setProperty(properties, "fontName", DEFAULT_FONT);
		
		for (key in Reflect.fields(properties)) {
			switch (key) {
				case "fontName":
					c_font = Assets.getFont(Reflect.getProperty(properties, key));
					if (c_font != null) {
						c_format.font = c_font.fontName;
						field.embedFonts = true;
						#if (js || html5)
						field.wordWrap = true;
						#end
					}else c_format.font = Reflect.getProperty(properties, key);
				case "size", "bold", "italic", "underline", "align" :
					Reflect.setProperty(c_format, key, Reflect.getProperty(properties, key) );
				default: Reflect.setProperty(field, key, Reflect.getProperty(properties, key) );
			}
		}
		field.defaultTextFormat = c_format;
	}
	
}