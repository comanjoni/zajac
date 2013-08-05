package rs.zajac.skins;
import rs.zajac.containers.Panel;
import rs.zajac.ui.BaseComponent;
import flash.display.DisplayObject;
import flash.display.Graphics;

/**
 * @author Aleksandar Bogdanovic
 */
class PanelSkin implements IPanelSkin {

	public function new() { }
	
	public function getVScrollSkinClass(): Class<ISkin> {
		return ScrollSkin;
	}
	public function getHScrollSkinClass(): Class<ISkin> {
		return ScrollSkin;
	}
	
	public function draw(client: BaseComponent, states: Map<String,DisplayObject>):Void {
		var c_client: Panel = cast(client);
		drawBackground(c_client);
	}
	
	private function drawBackground(client: Panel): Void {
		var c_x: Float = 0;
		var c_y: Float = 0;
		var c_width: Float = client.Width;
		var c_height: Float = client.Height;
		var c_gr: Graphics = client.graphics;
		
		c_gr.beginFill(client.backgroundColor, client.backgroundAlpha);
		if (client.borderColor != null) {
			c_gr.lineStyle(1, client.borderColor);
			c_x += 0.5;
			c_y += 0.5;
			c_width -= 1;
			c_height -= 1;
		}
		c_gr.drawRect(c_x, c_y, c_width, c_height);
		c_gr.endFill();
	}
	
}