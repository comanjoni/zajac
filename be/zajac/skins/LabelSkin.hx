package be.zajac.skins;
import be.zajac.ui.BaseComponent;
import be.zajac.ui.Label;
import nme.Assets;
import nme.display.DisplayObject;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class LabelSkin implements ISkin {

	public function new() { }
	
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
		c_format.align = Label.convertAlign(c_client.align);
		c_format.italic = c_client.italic;
		c_format.leading = c_client.leading;
		c_format.letterSpacing = c_client.letterSpacing;
		c_format.size = c_client.textSize;
		c_format.underline = c_client.underline;

		if (c_client.font != null) {
			c_font = Assets.getFont(c_client.font);
			if (c_font != null) {
				c_format.font = c_font.fontName;
				c_textField.embedFonts = true;
			}
		}
		
		c_textField.defaultTextFormat = c_format;
		c_textField.wordWrap = c_client.wordwrap;
		
		if (c_client.autosize) {
			c_textField.autoSize = TextFieldAutoSize.LEFT;
		} else {
			c_textField.autoSize = TextFieldAutoSize.NONE;
		}
		c_textField.width = c_client.Width;
		c_textField.height = c_client.Height;
		c_textField.text = c_client.text;
		
		if (c_client.autosize && !c_client.wordwrap) {
			c_client.Width = c_textField.width;
		}
		if (c_client.autosize && c_client.wordwrap) {
			c_client.Height = c_textField.height;
		}
		
	}
	
}