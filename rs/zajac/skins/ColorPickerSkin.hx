package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.ColorPicker;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.geom.Matrix;
import flash.Vector;

/**
 * @author Aleksandar Bogdanovic
 */
class ColorPickerSkin implements IColorPickerSkin {

	public function getPaletteSkinClass(): Class<ISkin> {
		return ColorPaletteSkin;
	}
	
	public function new() { }
	
	private function drawBackground(client: ColorPicker): Void {
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
		
		if (client.borderColor != null) {
			c_gr.moveTo(client.Width - client.buttonSize, 0.5);
			c_gr.lineTo(client.Width - client.buttonSize, client.Height - 0.5);
		}
			
		c_gr.endFill();
		
		c_gr.beginFill(client.iconColor);
		c_gr.lineStyle(0, client.iconColor);
		var c_vertices: Array<Float> = [
			client.Width - client.buttonSize * 2 / 3, client.buttonSize / 3,
			client.Width - client.buttonSize / 3, client.buttonSize / 3,
			client.Width - client.buttonSize / 2, client.buttonSize * 2 / 3
		];
		#if flash
		c_gr.drawTriangles(Vector.ofArray(c_vertices));
		#else
		c_gr.drawTriangles(c_vertices);
		#end
			
		c_gr.endFill();
	}
	
	private function drawColorBox(client: ColorPicker): Void {
		var c_bmpData: BitmapData = new BitmapData(Math.round(client.Width - client.buttonSize - 3), Math.round(client.Height - 4), true, 0);
		var c_shape: Shape = new Shape();
		var c_gr: Graphics = c_shape.graphics;
		
		c_gr.beginFill(0);
		if (client.roundness > 0) {
			c_gr.drawRoundRect(0, 0, c_bmpData.width + client.roundness, c_bmpData.height, client.roundness - 1);
		} else {
			c_gr.drawRect(0, 0, c_bmpData.width, c_bmpData.height);
		}
		c_gr.endFill();
			
		c_bmpData.draw(c_shape);
		
		client.colorBox.bitmapData = c_bmpData;
		client.colorBox.x = 2;
		client.colorBox.y = 2;
	}
	
	private function drawStateOUT(client: ColorPicker, state: DisplayObject): DisplayObject {
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
	
	private function drawStateOVER(client: ColorPicker, state: DisplayObject): DisplayObject {
		return null;
	}
	
	private function drawStateOPEN(client: ColorPicker, state: DisplayObject): DisplayObject {
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
		
		return c_shape;
	}
	
	public function draw(client: BaseComponent, states:Map<String,DisplayObject>): Void {
		var c_client: ColorPicker = cast(client);
		drawBackground(c_client);
		drawColorBox(c_client);
		states.set(ColorPicker.OUT, drawStateOUT(c_client, states.get(ColorPicker.OUT)));
		states.set(ColorPicker.OVER, drawStateOVER(c_client, states.get(ColorPicker.OVER)));
		states.set(ColorPicker.OPEN, drawStateOPEN(c_client, states.get(ColorPicker.OPEN)));
	}
	
}