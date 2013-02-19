package be.zajac.skins;
import be.zajac.core.FWCore;
import be.zajac.ui.BaseComponent;
import be.zajac.ui.Button;
import nme.display.BlendMode;
import nme.display.DisplayObject;
import nme.display.GradientType;
import nme.display.Graphics;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Matrix;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldAutoSize;

/**
 * ...
 * @author Ilic S Stojan
 */

class ButtonSkin implements ISkin{

	public function new() { }
	
	private function drawTextField(client: Button): Void {
		var c_textField: TextField = client.labelField;
		
		var c_format: TextFormat;
		#if (cpp || neko)
			c_format = c_textField.defaultTextFormat;
		#else
			c_format = c_textField.getTextFormat();
		#end
		c_format.color = client.color;
		c_textField.defaultTextFormat = c_format;
		c_textField.setTextFormat(c_format);
		c_textField.textColor = client.color;
		
		c_textField.x = Math.round((client.Width - c_textField.width) / 2);
		c_textField.y = Math.round((client.Height - c_textField.height) / 2);
	}
	
	private function drawBackground(client: Button): Void {
		var c_gr: Graphics = client.graphics;
		var c_x: Float = 0;
		var c_y: Float = 0;
		var c_width: Float = client.Width;
		var c_height: Float = client.Height;
		
		c_gr.clear();
		c_gr.beginFill(client.backgroundColor);
		
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
	
	private function drawStateUP(client: Button, state: DisplayObject): DisplayObject {
		var c_shape: Shape;
		var c_matrix: Matrix;
		var c_gr: Graphics;
		
		if (state == null) {
			c_shape = new Shape();
			c_shape.blendMode = BlendMode.MULTIPLY;
		} else  {
			c_shape = cast(state);
		}
		
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_matrix = new Matrix();
		c_matrix.createGradientBox(client.Width, client.Height, Math.PI / 2);
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0], [0, .15], [0, 255], c_matrix);
		if (client.roundness > 0) {
			c_gr.drawRoundRect(0, 0, client.Width, client.Height, client.roundness, client.roundness);
		} else {
			c_gr.drawRect(0, 0, client.Width, client.Height);
		}
		c_gr.endFill();
		
		return c_shape;
	}
	
	private function drawStateOVER(client: Button, state: DisplayObject): DisplayObject {
		return state;
	}
	
	private function drawStateDOWN(client: Button, state: DisplayObject): DisplayObject {
		var c_shape: Shape;
		var c_matrix: Matrix;
		var c_gr: Graphics;
		
		if (state == null) {
			c_shape = new Shape();
			c_shape.blendMode = BlendMode.MULTIPLY;
		} else  {
			c_shape = cast(state);
		}
		
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_matrix = new Matrix();
		c_matrix.createGradientBox(client.Width, client.Height, Math.PI / 2);
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0, 0], [.5, .3, 0.05], [0, 16, 255], c_matrix);
		if (client.roundness > 0) {
			c_gr.drawRoundRect(0, 0, client.Width, client.Height, client.roundness, client.roundness);
		} else {
			c_gr.drawRect(0, 0, client.Width, client.Height);
		}
		c_gr.endFill();
		
		return c_shape;
	}
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client: Button = cast(client);
		drawTextField(c_client);
		drawBackground(c_client);
		states.set(Button.UP, drawStateUP(c_client, states.get(Button.UP)));
		states.set(Button.OVER, drawStateOVER(c_client, states.get(Button.OVER)));
		states.set(Button.DOWN, drawStateDOWN(c_client, states.get(Button.DOWN)));
	}
	
}