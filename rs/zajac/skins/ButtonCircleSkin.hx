package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.Button;
import nme.display.BlendMode;
import nme.display.DisplayObject;
import nme.display.GradientType;
import nme.display.Graphics;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Matrix;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;

/**
 * ...
 * @author Ilic S Stojan
 */

class ButtonCircleSkin implements ISkin{

	
	
	public function new() {
		
	}
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client:Button = cast(client);
		var c_gr:Graphics;
		var c_shape:Shape;
		var c_matrix:Matrix;
			//for roundness buttons button size is smaller value of Width and Height and button is centered
		var c_buttonSize:Float;
		var c_buttonX:Float;
		var c_buttonY:Float;
		//var c_state:DisplayObject;
		
		c_buttonSize = Math.min(c_client.Width, c_client.Height);
		c_buttonX = Math.round( (c_client.Width - c_buttonSize) / 2) + c_buttonSize / 2;
		c_buttonY = Math.round( (c_client.Height - c_buttonSize) / 2) + c_buttonSize / 2;
		c_buttonSize = c_buttonSize / 2 ; //drawCircle need radius
		
		c_matrix = new Matrix();
		c_matrix.createGradientBox(c_client.Width, c_client.Height, Math.PI / 2);
		
		c_gr = c_client.graphics;
		c_gr.clear();
		c_gr.beginFill(c_client.backgroundColor);
		if (c_client.borderColor != null) c_gr.lineStyle(1, c_client.borderColor);
		c_gr.drawCircle(c_buttonX, c_buttonY, c_buttonSize);
		c_gr.endFill();
		
		if (states.exists(Button.UP)) c_shape = cast(states.get(Button.UP))
			else {
				c_shape = new Shape();
				c_shape.blendMode = BlendMode.MULTIPLY;
				states.set(Button.UP, c_shape);
			}
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0], [0, .15], [0, 255], c_matrix);
		c_gr.drawCircle(c_buttonX, c_buttonY, c_buttonSize);
		c_gr.endFill();
		
		if (states.exists(Button.OVER)) c_shape = cast(states.get(Button.OVER))
			else {
				c_shape = new Shape();
				states.set(Button.OVER, c_shape);
			}
		
		if (states.exists(Button.DOWN)) c_shape = cast(states.get(Button.DOWN))
			else {
				c_shape = new Shape();
				states.set(Button.DOWN, c_shape);
			}
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0, 0], [.5, .3, 0.05], [0, 16, 255], c_matrix);
		c_gr.drawCircle(c_buttonX, c_buttonY, c_buttonSize);
		c_gr.endFill();
		
		
	}
	
}