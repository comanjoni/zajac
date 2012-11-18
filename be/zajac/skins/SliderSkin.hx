package be.zajac.skins;
import be.zajac.ui.BaseComponent;
import be.zajac.ui.Button;
import be.zajac.ui.Slider;
import nme.display.DisplayObject;
import nme.display.Graphics;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class SliderSkin implements ISkin {

	public function new() { }
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client: Slider = cast(client);
		var c_button: Button = c_client.button;
		var c_gr: Graphics = c_client.graphics;
		
		c_gr.clear();
		c_gr.beginFill(c_client.backgroundColor);
		if (c_client.roundness > 0) {
			c_gr.drawRoundRect(0, 0, c_client.Width, c_client.Height, c_client.roundness, c_client.roundness);
		} else {
			c_gr.drawRect(0, 0, c_client.Width, c_client.Height);
		}
		c_gr.endFill();
		
		//TODO: move this to be set to button in setter
		c_button.roundness = c_client.roundness;
		c_button.backgroundColor = c_client.buttonBackgroundColor;
		c_button.borderColor = c_client.buttonBorderColor;
		switch (c_client.direction) {
			case Slider.DIRECTION_HORIZONTAL:
				c_button.Height = c_client.Height;
				c_button.Width = Math.max(c_client.Height, c_client.Width * c_client.pageSize / (c_client.maxValue - c_client.minValue));
			case Slider.DIRECTION_VERTICAL:
				c_button.Width = c_client.Width;
				c_button.Height = Math.max(c_client.Width, c_client.Height * c_client.pageSize / (c_client.maxValue - c_client.minValue));
		}
		
	}
	
}