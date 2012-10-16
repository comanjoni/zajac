package be.zajac.skins;
import be.zajac.ui.BaseComponent;
import be.zajac.ui.ISkin;
import be.zajac.ui.Label;
import nme.Assets;
import nme.display.DisplayObject;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class LabelSkin implements ISkin {

	#if (cpp || neko)
		private function getAlign(type: String): Null<String> {
			switch (type) {
				case Label.ALIGN_CENTER:
					return TextFormatAlign.CENTER;
				case Label.ALIGN_JUSTIFY:
					return TextFormatAlign.JUSTIFY;
				case Label.ALIGN_RIGHT:
					return TextFormatAlign.RIGHT;
				case Label.ALIGN_LEFT:
					return TextFormatAlign.LEFT;
				default:
					return TextFormatAlign.LEFT;
			}
		}
	#else
		private function getAlign(type: String): TextFormatAlign {
			switch (type) {
				case Label.ALIGN_CENTER:
					return TextFormatAlign.CENTER;
				case Label.ALIGN_JUSTIFY:
					return TextFormatAlign.JUSTIFY;
				case Label.ALIGN_RIGHT:
					return TextFormatAlign.RIGHT;
				case Label.ALIGN_LEFT:
					return TextFormatAlign.LEFT;
				default:
					return TextFormatAlign.LEFT;
			}
		}
	#end
	
	public function new() {
	}
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client: Label = cast(client);
		var c_textField: TextField = c_client.textField;
		var c_font: Font;
		var c_format: TextFormat;
		
		#if (cpp || neko)
			c_format = c_textField.defaultTextFormat;
		#else
			c_format = c_textField.getTextFormat();
		#end
		
		c_format.color = c_client.textColor;
		c_format.bold = c_client.bold;
		c_format.align = getAlign(c_client.align);
		c_format.italic = c_client.italic;
		c_format.leading = c_client.leading;
		c_format.letterSpacing = c_client.letterSpacing;
		c_format.size = c_client.textSize;
		c_format.underline = c_client.underline;

		c_font = Assets.getFont(c_client.font);
		if (c_font != null) {
			c_format.font = c_font.fontName;
			c_textField.embedFonts = true;
			#if (js || html5)
				c_textField.wordWrap = true;
			#end
		} else {
			c_format.font = c_client.font;
		}
		
		c_textField.defaultTextFormat = c_format;
		// fix. If you don't set text text field will become empty
		c_textField.text = c_client.text;
		
	}
	
}