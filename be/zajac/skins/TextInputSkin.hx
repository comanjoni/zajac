package be.zajac.skins;
import be.zajac.ui.BaseComponent;
import be.zajac.ui.TextInput;
import nme.Assets;
import nme.display.DisplayObject;
import nme.display.Graphics;
import nme.display.Shape;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class TextInputSkin implements ISkin {

	public function new() {}
	
	private function drawTextField(client: TextInput): Void {
		var c_textField: TextField = client.textField;
		var c_font: Font;
		var c_format: TextFormat;
		
		#if (cpp || neko)
			c_format = c_textField.defaultTextFormat;
		#else
			c_format = c_textField.getTextFormat();
		#end
		
		c_format.color = client.textColor;
		c_format.bold = client.bold;
		c_format.italic = client.italic;
		c_format.leading = client.leading;
		c_format.letterSpacing = client.letterSpacing;
		c_format.size = client.textSize;
		c_format.underline = client.underline;

		if (client.font != null) {
			c_font = Assets.getFont(client.font);
			if (c_font != null) {
				c_format.font = c_font.fontName;
				c_textField.embedFonts = true;
			}
		}
		
		c_textField.defaultTextFormat = c_format;
		
		c_textField.displayAsPassword = client.displayAsPassword;
		
		if (client.Width > 0) {
			c_textField.width = client.Width;
		} else {
			client.Width = c_textField.width;
		}
		if (client.Height > 0) {
			c_textField.height = client.Height;
		} else {
			client.Height = c_textField.height;
		}
		
		#if (!flash)
		c_textField.text = c_textField.text;
		#end
	}
	
	private function drawBackgound(client: TextInput): Void {
		var c_gr: Graphics = client.graphics;
		c_gr.clear();
		c_gr.beginFill(client.backgroundColor);
		c_gr.drawRect(0, 0, client.Width, client.Height);
		c_gr.endFill();
	}
	
	private function drawStateFOCUSIN(client: TextInput, state: DisplayObject): DisplayObject {
		var c_shape: Shape;
		if (state == null) {
			c_shape = new Shape();
		} else  {
			c_shape = cast(state);
		}
		
		var c_gr: Graphics = c_shape.graphics;
		
		c_gr.lineStyle(1, 0xff0000);
		c_gr.lineTo(0, 0);
		c_gr.lineTo(client.Width, 0);
		c_gr.lineTo(client.Width, client.Height);
		c_gr.lineTo(0, client.Height);
		c_gr.lineTo(0, 0);
		c_gr.endFill();
		
		return c_shape;
	}
	
	private function drawStateFOCUSOUT(client: TextInput, state: DisplayObject): DisplayObject {
		var c_shape: Shape;
		if (state == null) {
			c_shape = new Shape();
		} else  {
			c_shape = cast(state);
		}
		
		var c_gr: Graphics = c_shape.graphics;
		
		// it's empty
		
		return c_shape;
	}
	
	private function drawStateTOUCH(client: TextInput, state: DisplayObject): DisplayObject {
		var c_shape: Shape;
		if (state == null) {
			c_shape = new Shape();
		} else  {
			c_shape = cast(state);
		}
		
		var c_gr: Graphics = c_shape.graphics;
		
		c_gr = c_shape.graphics;
		c_gr.beginFill(0x0000ff);
		c_gr.drawRect(0, 0, client.Width, client.Height);
		c_gr.lineStyle(1, 0x00ff00);
		c_gr.lineTo(0, 0);
		c_gr.lineTo(client.Width, 0);
		c_gr.lineTo(client.Width, client.Height);
		c_gr.lineTo(0, client.Height);
		c_gr.lineTo(0, 0);
		c_gr.endFill();
		
		return c_shape;
	}
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client: TextInput = cast(client);
		
		drawTextField(c_client);
		drawBackgound(c_client);
		states.set(TextInput.FOCUSIN, drawStateFOCUSIN(c_client, states.get(TextInput.FOCUSIN)));
		states.set(TextInput.FOCUSOUT, drawStateFOCUSOUT(c_client, states.get(TextInput.FOCUSOUT)));
		states.set(TextInput.TOUCH, drawStateTOUCH(c_client, states.get(TextInput.TOUCH)));
	}
	
}