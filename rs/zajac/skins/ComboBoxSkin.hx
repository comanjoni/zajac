package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.ComboBox;
import nme.display.BlendMode;
import nme.display.DisplayObject;
import nme.display.GradientType;
import nme.display.Graphics;
import nme.display.Shape;
import nme.geom.Matrix;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormat;
import nme.Vector;
import nme.Vector;

/**
 * ...
 * @author Aleksandar Bogdanovic
 */

class ComboBoxSkin implements IComboBoxSkin {
	
	public function getListSkinClass(): Class<ISkin> {
		return PanelSkin;
	}

	public function new() { }
	
	private function drawTextField(client: ComboBox): Void {
		var c_textField: TextField = client.textField;
		//var c_font: Font;
		var c_format: TextFormat;
		var c_height: Float;
		
		#if (cpp || neko)
			c_format = c_textField.defaultTextFormat;
		#else
			c_format = c_textField.getTextFormat();
		#end
		
		c_textField.textColor = c_format.color = client.color;
		//c_format.letterSpacing = client.letterSpacing;
		//c_format.size = client.textSize;

		//if (client.font != null) {
			//c_font = Assets.getFont(client.font);
			//if (c_font != null) {
				//c_format.font = c_font.fontName;
				//c_textField.embedFonts = true;
			//}
		//}
		
		c_textField.defaultTextFormat = c_format;
		c_textField.setTextFormat(c_format);
		
		c_textField.autoSize = TextFieldAutoSize.LEFT;
		c_textField.text = client.text;
		c_height = c_textField.height;
		c_textField.autoSize = TextFieldAutoSize.NONE;
		c_textField.height = c_height;
		
		c_textField.width = client.Width - client.buttonSize;
		c_textField.y = (client.Height - c_textField.height) / 2;
	}
	
	private function drawBackground(client: ComboBox): Void {
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
	
	private function drawStateOUT(client: ComboBox, state: DisplayObject): DisplayObject {
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
	
	private function drawStateOVER(client: ComboBox, state: DisplayObject): DisplayObject {
		return null;
	}
	
	private function drawStateOPEN(client: ComboBox, state: DisplayObject): DisplayObject {
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
	
	public function draw(client: BaseComponent, states:Hash<DisplayObject>): Void {
		var c_client: ComboBox = cast(client);
		drawTextField(c_client);
		drawBackground(c_client);
		states.set(ComboBox.OUT, drawStateOUT(c_client, states.get(ComboBox.OUT)));
		states.set(ComboBox.OVER, drawStateOVER(c_client, states.get(ComboBox.OVER)));
		states.set(ComboBox.OPEN, drawStateOPEN(c_client, states.get(ComboBox.OPEN)));
	}
	
}