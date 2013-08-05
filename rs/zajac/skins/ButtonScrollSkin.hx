package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.Button;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;

/**
 * Skin for Button used in Scroll.
 * @author Aleksandar Bogdanovic
 */
class ButtonScrollSkin implements ISkin {

	public function new() { }
	
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
		if (state == null) {
			c_shape = new Shape();
		} else  {
			c_shape = cast(state);
		}
		
		var c_gr: Graphics = c_shape.graphics;
		c_gr.clear();
		c_gr.beginFill(0x909090, 0.5);
		if (client.roundness > 0) {
			c_gr.drawRoundRect(0, 0, client.Width, client.Height, client.roundness, client.roundness);
		} else {
			c_gr.drawRect(0, 0, client.Width, client.Height);
		}
		c_gr.endFill();
		
		return c_shape;
	}
	
	private function drawStateOVER(client: Button, state: DisplayObject): DisplayObject {
		var c_shape: Shape;
		if (state == null) {
			c_shape = new Shape();
		} else  {
			c_shape = cast(state);
		}
		
		var c_gr: Graphics = c_shape.graphics;
		c_gr.clear();
		c_gr.beginFill(0x707070, 0.5);
		if (client.roundness > 0) {
			c_gr.drawRoundRect(0, 0, client.Width, client.Height, client.roundness, client.roundness);
		} else {
			c_gr.drawRect(0, 0, client.Width, client.Height);
		}
		c_gr.endFill();
		
		return c_shape;
	}
	
	private function drawStateDOWN(client: Button, state: DisplayObject): DisplayObject {
		return drawStateOVER(client, state);
	}
	
	public function draw(client: BaseComponent, states: Map<String,DisplayObject>):Void {
		var c_client:Button = cast(client);
		drawBackground(c_client);
		states.set(Button.UP, drawStateUP(c_client, states.get(Button.UP)));
		states.set(Button.OVER, drawStateOVER(c_client, states.get(Button.OVER)));
		states.set(Button.DOWN, drawStateDOWN(c_client, states.get(Button.DOWN)));
	}
	
}