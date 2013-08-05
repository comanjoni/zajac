package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.Label;
import openfl.Assets;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * @author Aleksandar Bogdanovic
 */
class LabelSkin implements ISkin {

	public function new() { }
	
	private function drawTextField(client: Label): Void {
		var c_textField: TextField = client.textField;
		var c_font: Font;
		var c_format: TextFormat;
		
		#if (cpp || neko)
			c_format = c_textField.defaultTextFormat;
		#else
			c_format = c_textField.getTextFormat();
		#end
		
		c_textField.textColor = c_format.color = client.color;
		c_format.letterSpacing = client.letterSpacing;
		c_format.size = client.textSize;

		if (client.font != null) {
			c_font = Assets.getFont(client.font);
			if (c_font != null) {
				c_format.font = c_font.fontName;
				c_textField.embedFonts = true;
			}
		}
		
		c_textField.defaultTextFormat = c_format;
		c_textField.setTextFormat(c_format);
		
		c_textField.autoSize = TextFieldAutoSize.LEFT;
		c_textField.text = client.text;
		
		c_textField.y = (client.Height - c_textField.height) / 2;
		
		client.defaultWidth = c_textField.width;
		
		if (c_textField.width > client.Width) {
			c_textField.autoSize = TextFieldAutoSize.NONE;
			c_textField.width = client.Width;
		}
		
		switch (client.align) {
			case Label.ALIGN_LEFT:
				c_textField.x = 0;
			case Label.ALIGN_RIGHT:
				c_textField.x = client.Width - c_textField.width;
			default:
				c_textField.x = (client.Width - c_textField.width) / 2;
		}
	}
	
	private function drawBackground(client: Label): Void {
		if (client.backgroundColor == null && client.borderColor == null) return;
		
		var c_gr: Graphics = client.graphics;
		var c_x: Float = 0;
		var c_y: Float = 0;
		var c_width: Float = client.Width;
		var c_height: Float = client.Height;
		
		c_gr.clear();
		if (client.backgroundColor != null) {
			c_gr.beginFill(client.backgroundColor);
		}
		
		if (client.borderColor != null) {
			c_gr.lineStyle(1, client.borderColor);
			c_x = 0.5;
			c_y = 0.5;
			c_width -= 1;
			c_height -= 1;
		}
		
		if (client.roundness > 0) {
			c_gr.drawRoundRect(c_x, c_y, c_width, c_height, client.roundness, client.roundness);
		} else {
			c_gr.drawRect(c_x, c_y, c_width, c_height);
		}
			
		c_gr.endFill();
	}
	
	public function draw(client: BaseComponent, states: Map<String,DisplayObject>):Void {
		var c_client: Label = cast(client);
		drawTextField(c_client);
		drawBackground(c_client);
	}
	
}