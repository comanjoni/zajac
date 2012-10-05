package be.zajac.skins;
import be.zajac.ui.BaseComponent;
import be.zajac.ui.Button;
import be.zajac.ui.ISkin;
import nme.display.BlendMode;
import nme.display.DisplayObject;
import nme.display.GradientType;
import nme.display.Graphics;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Matrix;

/**
 * ...
 * @author Ilic S Stojan
 */

class ButtonSkin implements ISkin{

	
	
	public function new() {
		
	}
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client:Button = cast(client);
		var c_rounded:Bool;
		var c_gr:Graphics;
		var c_shape:Shape;
		var c_matrix:Matrix;
		//var c_state:DisplayObject;
		
		if (c_client.roundness > 0) c_rounded = true
			else c_rounded = false;
		c_matrix = new Matrix();
		c_matrix.createGradientBox(c_client.Width, c_client.Height, Math.PI / 2);
		
		c_gr = c_client.graphics;
		c_gr.clear();
		c_gr.beginFill(c_client.backgroundColor);
		if (c_client.borderColor > 0) c_gr.lineStyle(1, c_client.borderColor);
		if (c_rounded) c_gr.drawRoundRect(0, 0, c_client.Width, c_client.Height, c_client.roundness, c_client.roundness)
			else c_gr.drawRect(0, 0, c_client.Width, c_client.Height);
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
		if (c_rounded) c_gr.drawRoundRect(0, 0, c_client.Width, c_client.Height, c_client.roundness, c_client.roundness)
			else c_gr.drawRect(0, 0, c_client.Width, c_client.Height);
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
		if (c_rounded) c_gr.drawRoundRect(0, 0, c_client.Width, c_client.Height, c_client.roundness, c_client.roundness)
			else c_gr.drawRect(0, 0, c_client.Width, c_client.Height);
		c_gr.endFill();
		
	}
	
}