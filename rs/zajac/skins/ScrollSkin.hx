package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.Button;
import rs.zajac.ui.Scroll;
import rs.zajac.ui.Slider;
import nme.display.DisplayObject;
import nme.display.Graphics;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class ScrollSkin implements IScrollSkin {

	public function getButtonSkinClass():Class<ISkin> {
		return ButtonScrollSkin;
	}
	
	public function new() { }
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client: Scroll = cast(client);
		drawBackground(c_client);
	}
	
	public function drawBackground(client: Scroll): Void {
		var c_x: Float = 0;
		var c_y: Float = 0;
		var c_width: Float = client.Width;
		var c_height: Float = client.Height;
		var c_gr: Graphics = client.graphics;
		
		c_gr.clear();
		if (client.borderColor != null) {
			c_gr.lineStyle(1, client.borderColor, client.backgroundAlpha);
			c_x += 0.5;
			c_y += 0.5;
			c_width -= 1;
			c_height -= 1;
		}
		c_gr.beginFill(client.backgroundColor, client.backgroundAlpha);
		if (client.roundness > 0) {
			c_gr.drawRoundRect(c_x, c_y, c_width, c_height, client.roundness, client.roundness);
		} else {
			c_gr.drawRect(c_x, c_y, c_width, c_height);
		}
		
		c_gr.endFill();
	}
	
}