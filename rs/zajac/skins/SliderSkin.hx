package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.Button;
import rs.zajac.ui.Slider;
import flash.display.DisplayObject;
import flash.display.Graphics;

/**
 * @author Aleksandar Bogdanovic
 */
class SliderSkin implements ISliderSkin {

	public function getButtonSkinClass():Class<ISkin> {
		return ButtonCircleSkin;
	}
	
	public function new() { }
	
	public function draw(client: BaseComponent, states: Map<String,DisplayObject>):Void {
		var c_client: Slider = cast(client);
		var c_button: Button = c_client.button;
		var c_gr: Graphics = c_client.graphics;
		var c_buttonMaxSize:Float;
		var c_barSize:Int;
		var c_barX:Float = 0;
		var c_barY:Float = 0;
		var c_width:Float;
		var c_height:Float;
		
		if (c_client.direction == Slider.DIRECTION_HORIZONTAL) c_buttonMaxSize = c_client.Height
			else c_buttonMaxSize = c_client.Width;
		
		if (c_client.barSize != null) {
			if (c_client.barSize > c_buttonMaxSize) c_barSize = Math.floor( c_buttonMaxSize )
				else c_barSize = c_client.barSize;
		}else c_barSize = Math.round( c_buttonMaxSize / 3 );
		
		if (c_client.direction == Slider.DIRECTION_HORIZONTAL) {
			c_barY = Math.round( (c_buttonMaxSize - c_barSize) / 2 );
			c_width = c_client.Width;
			c_height = c_barSize;
		}else {
			c_barX = Math.round( (c_buttonMaxSize - c_barSize) / 2 );
			c_width = c_barSize;
			c_height = c_client.Height;
		}
		
		c_gr.clear();
		if (c_client.borderColor != null) {
			c_gr.lineStyle(1, c_client.borderColor);
			c_barX += 0.5;
			c_barY += 0.5;
			c_width -= 0.5;
			c_height -= 0.5;
		}
		c_gr.beginFill(c_client.backgroundColor);
		if (c_client.roundness > 0) {
			c_gr.drawRoundRect(c_barX, c_barY, c_width, c_height, c_client.roundness, c_client.roundness);
		} else {
			c_gr.drawRect(c_barX, c_barY, c_width, c_height);
		}
		c_gr.endFill();
	}
	
}