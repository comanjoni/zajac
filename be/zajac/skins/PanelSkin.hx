package be.zajac.skins;
import be.zajac.containers.Panel;
import be.zajac.ui.BaseComponent;
import nme.display.DisplayObject;
import nme.display.Graphics;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class PanelSkin implements ISkin {

	public function new() {
	}
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client: Panel = cast(client);
		var c_gr: Graphics = c_client.graphics;
		
		c_gr.beginFill(c_client.backgroundColor, c_client.backgroundAlpha);
		c_gr.drawRect(0, 0, c_client.Width, c_client.Height);
		c_gr.endFill();
	}
	
}