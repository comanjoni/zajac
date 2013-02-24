package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.TextInput;
import nme.Assets;
import nme.display.DisplayObject;
import nme.display.Graphics;
import nme.display.Shape;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;

/**
 * @author Aleksandar Bogdanovic
 */
class TextInputSkin implements ISkin {

	public function new() {}
	
	private function drawTextField(client: TextInput): Void {
		var c_textField: TextField = client.textField;
		var c_font: Font;
		var c_format: TextFormat;
		var c_height: Float;
		
		#if (cpp || neko)
			c_format = c_textField.defaultTextFormat;
		#else
			c_format = c_textField.getTextFormat();
		#end
		
		c_textField.textColor = c_format.color = client.textColor;
		c_format.letterSpacing = client.letterSpacing;
		c_format.size = client.textSize;
		
		switch (client.align) {
			case TextInput.ALIGN_LEFT:
				c_format.align = TextFormatAlign.LEFT;
			case TextInput.ALIGN_RIGHT:
				c_format.align = TextFormatAlign.RIGHT;
			default:
				c_format.align = TextFormatAlign.CENTER;
		}
		
		if (client.font != null) {
			c_font = Assets.getFont(client.font);
			if (c_font != null) {
				c_format.font = c_font.fontName;
				c_textField.embedFonts = true;
			}
		}
		
		c_textField.defaultTextFormat = c_format;
		c_textField.setTextFormat(c_format);
		
		c_textField.displayAsPassword = client.displayAsPassword;
		
		c_textField.autoSize = TextFieldAutoSize.LEFT;
		c_textField.text = c_textField.text;
		c_height = c_textField.height;
		c_textField.autoSize = TextFieldAutoSize.NONE;
		c_textField.height = c_height;
		
		c_textField.width = client.Width;
		c_textField.y = (client.Height - c_textField.height) / 2;
	}
	
	private function drawBackground(client: TextInput): Void {
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
	
	private function drawStateFOCUSIN(client: TextInput, state: DisplayObject): DisplayObject {
		var c_shape: Shape;
		var c_gr: Graphics;
		
		if (state == null) {
			c_shape = new Shape();
		} else  {
			c_shape = cast(state);
		}
		
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.lineStyle(2, client.focusColor, 1);
		
		if (client.roundness > 0) {
			c_gr.drawRoundRect(0, 0, client.Width, client.Height, client.roundness, client.roundness);
		} else {
			c_gr.drawRect(0, 0, client.Width, client.Height);
		}
		c_gr.endFill();
		
		return c_shape;
	}
	
	private function drawStateFOCUSOUT(client: TextInput, state: DisplayObject): DisplayObject {
		return null;
	}
	
	private function drawStateTOUCH(client: TextInput, state: DisplayObject): DisplayObject {
		var c_shape: Shape;
		var c_gr: Graphics;
		
		if (state == null) {
			c_shape = new Shape();
		} else  {
			c_shape = cast(state);
		}
		
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.lineStyle(2, client.focusColor, 0,5);
		c_gr.beginFill(client.focusColor);
		
		if (client.roundness > 0) {
			c_gr.drawRoundRect(0, 0, client.Width, client.Height, client.roundness, client.roundness);
		} else {
			c_gr.drawRect(0, 0, client.Width, client.Height);
		}
			
		c_gr.endFill();
		
		return c_shape;
	}
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client: TextInput = cast(client);
		drawTextField(c_client);
		drawBackground(c_client);
		states.set(TextInput.FOCUSIN, drawStateFOCUSIN(c_client, states.get(TextInput.FOCUSIN)));
		states.set(TextInput.FOCUSOUT, drawStateFOCUSOUT(c_client, states.get(TextInput.FOCUSOUT)));
		states.set(TextInput.TOUCH, drawStateTOUCH(c_client, states.get(TextInput.TOUCH)));
	}
	
}