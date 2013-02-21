package rs.zajac.skins;
import rs.zajac.core.ZajacCore;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.ColorPalette;
import rs.zajac.util.ColorUtil;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.DisplayObject;
import nme.display.Graphics;
import nme.display.Shape;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class ColorPaletteSkin implements IColorPaletteSkin {

	public function getCursor(): DisplayObject {
		var c_shape: Shape = new Shape();
		var c_gr: Graphics = c_shape.graphics;
		
		c_gr.lineStyle(2, 0xffffff);
		c_gr.drawCircle(0, 0, ZajacCore.getHeightUnit() / 5);
		c_gr.endFill();
		
		return c_shape;
	}
	
	private static var _paletteCache: BitmapData;
	
	private static function getPalette(width: Int, height: Int): BitmapData {
		if (_paletteCache == null || _paletteCache.width != width || _paletteCache.height != height) {
			_paletteCache = new BitmapData(width, height, false);
			_paletteCache.lock();
			for (h in 0...width) {
				for (iv in 0...height) {
					_paletteCache.setPixel(h, iv, ColorUtil.hsl2rgb(cast(h, Float) / width, 1, 1 - cast(iv, Float) / height));
				}
			}
			_paletteCache.unlock();
		}
		return _paletteCache.clone();
	}
	
	
	public function new() { }
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client: ColorPalette = cast(client);
		drawBackground(c_client);
		drawPalette(c_client);
	}
	
	private function drawBackground(client: ColorPalette): Void {
		var c_x: Float = 0;
		var c_y: Float = 0;
		var c_width: Float = client.Width;
		var c_height: Float = client.Height;
		var c_gr: Graphics = client.graphics;
		
		// draw background
		c_gr.beginFill(client.backgroundColor, 1);
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
	
	private function drawPalette(client: ColorPalette): Void {
		var c_padding: Int = Math.round(ZajacCore.getHeightUnit() / 4);
		var c_width: Int = Math.round(client.Width - 2 * c_padding);
		var c_height: Int = Math.round(client.Height - 2 * c_padding);
		var c_gr: Graphics = client.graphics;
		var c_palette: Bitmap = client.palette;
		
		// draw palette border
		if (client.borderColor != null) {
			c_gr.lineStyle(1, client.borderColor);
			c_gr.moveTo(c_padding - 0.5, c_padding - 0.5);
			c_gr.lineTo(c_padding + c_width + 0.5, c_padding - 0.5);
			c_gr.lineTo(c_padding + c_width + 0.5, c_padding + c_height + 0.5);
			c_gr.lineTo(c_padding - 0.5, c_padding + c_height + 0.5);
			c_gr.lineTo(c_padding - 0.5, c_padding - 0.5);
			c_gr.endFill();
		}
		
		// draw palette
		c_palette.x = c_palette.y = c_padding;
		if (c_palette.bitmapData == null || c_palette.bitmapData.width != c_width || c_palette.bitmapData.height != c_height) {
			c_palette.bitmapData = getPalette(c_width, c_height);
		}
	}
	
}