package be.zajac.skins;
import be.zajac.ui.BaseComponent;
import be.zajac.ui.CheckBox;
import nme.display.BlendMode;
import nme.display.DisplayObject;
import nme.display.GradientType;
import nme.display.Graphics;
import nme.display.Shape;
import nme.display.Sprite;
import nme.geom.Matrix;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;

/**
 * ...
 * @author Ilic S Stojan
 */

class CheckBoxSkin implements ISkin{

	
	
	public function new() {
		
	}
	
	public function draw(client: BaseComponent, states: Hash<DisplayObject>):Void {
		var c_client:CheckBox = cast(client);
		var c_rounded:Bool;
		var c_lineSize:Int = 2;
		var c_iconMargin:Float = 2; //margin for icon
		var c_gr:Graphics;
		var c_shape:Shape;
		var c_matrix:Matrix;
		var c_label:TextField;
		//var c_state:DisplayObject;
		
		if (c_client.roundness > 0) c_rounded = true
			else c_rounded = false;
		c_matrix = new Matrix();
		c_matrix.createGradientBox(c_client.buttonSize, c_client.buttonSize, Math.PI / 2);
		
		//prepare main parameters for icons
		c_lineSize = Math.round( c_client.buttonSize / 5 );
		c_iconMargin = c_client.buttonSize / 3;
		
		//draw main color on the component
		c_gr = c_client.graphics;
		c_gr.clear();
		c_gr.beginFill(c_client.backgroundColor);
		if (c_client.borderColor > 0) c_gr.lineStyle(1, c_client.borderColor);
		if (c_rounded) c_gr.drawRoundRect(0, 0, c_client.buttonSize, c_client.buttonSize, c_client.roundness, c_client.roundness)
			else c_gr.drawRect(0, 0, c_client.buttonSize, c_client.buttonSize);
		c_gr.endFill();
		
		
		//draw UP state
		if (states.exists(CheckBox.UP)) c_shape = cast(states.get(CheckBox.UP))
			else {
				c_shape = new Shape();
				c_shape.blendMode = BlendMode.MULTIPLY;
				states.set(CheckBox.UP, c_shape);
			}
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0], [0, .15], [0, 255], c_matrix);
		if (c_rounded) c_gr.drawRoundRect(0, 0, c_client.buttonSize, c_client.buttonSize, c_client.roundness, c_client.roundness)
			else c_gr.drawRect(0, 0, c_client.buttonSize, c_client.buttonSize);
		c_gr.endFill();
		drawNonSelectedIcon(c_gr, c_lineSize, c_client.iconColor, c_iconMargin);
		
		//draw OVER state
		if (states.exists(CheckBox.OVER)) c_shape = cast(states.get(CheckBox.OVER))
			else {
				c_shape = new Shape();
				states.set(CheckBox.OVER, c_shape);
			}
		drawNonSelectedIcon(c_shape.graphics, c_lineSize, c_client.iconColor, c_iconMargin);
			
		//draw DOWN state
		if (states.exists(CheckBox.DOWN)) c_shape = cast(states.get(CheckBox.DOWN))
			else {
				c_shape = new Shape();
				states.set(CheckBox.DOWN, c_shape);
			}
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0, 0], [.5, .3, 0.05], [0, 16, 255], c_matrix);
		if (c_rounded) c_gr.drawRoundRect(0, 0, c_client.buttonSize, c_client.buttonSize, c_client.roundness, c_client.roundness)
			else c_gr.drawRect(0, 0, c_client.buttonSize, c_client.buttonSize);
		c_gr.endFill();
		drawNonSelectedIcon(c_gr, c_lineSize, c_client.iconColor, c_iconMargin);
		
		//draw SEL_UP state
		if (states.exists(CheckBox.SELECTED_UP)) c_shape = cast(states.get(CheckBox.SELECTED_UP))
			else {
				c_shape = new Shape();
				c_shape.blendMode = BlendMode.MULTIPLY;
				states.set(CheckBox.SELECTED_UP, c_shape);
			}
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0], [0, .15], [0, 255], c_matrix);
		if (c_rounded) c_gr.drawRoundRect(0, 0, c_client.buttonSize, c_client.buttonSize, c_client.roundness, c_client.roundness)
			else c_gr.drawRect(0, 0, c_client.buttonSize, c_client.buttonSize);
		c_gr.endFill();
		drawSelectedIcon(c_gr, c_lineSize, c_client.iconColor, c_iconMargin);
		
		//draw SEL_OVER state
		if (states.exists(CheckBox.SELECTED_OVER)) c_shape = cast(states.get(CheckBox.SELECTED_OVER))
			else {
				c_shape = new Shape();
				states.set(CheckBox.SELECTED_OVER, c_shape);
			}
		drawSelectedIcon(c_shape.graphics, c_lineSize, c_client.iconColor, c_iconMargin);
			
		//draw SEL_DOWN state
		if (states.exists(CheckBox.SELECTED_DOWN )) c_shape = cast(states.get(CheckBox.SELECTED_DOWN))
			else {
				c_shape = new Shape();
				states.set(CheckBox.SELECTED_DOWN, c_shape);
			}
		c_gr = c_shape.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0, 0], [.5, .3, 0.05], [0, 16, 255], c_matrix);
		if (c_rounded) c_gr.drawRoundRect(0, 0, c_client.buttonSize, c_client.buttonSize, c_client.roundness, c_client.roundness)
			else c_gr.drawRect(0, 0, c_client.buttonSize, c_client.buttonSize);
		c_gr.endFill();
		drawSelectedIcon(c_gr, c_lineSize, c_client.iconColor, c_iconMargin);
		
		
		
		c_label = c_client.labelField;
		c_label.x = c_client.buttonSize + 5;
		if (c_client.Width > 0) c_label.width = c_client.Width - c_label.x;
		c_label.textColor = c_client.color;
		if (c_client.Height > 0) c_label.y = Math.round( (c_client.Height - c_label.height) / 2)
			else if (c_client.buttonSize > 0) c_label.y = Math.round( (c_client.buttonSize - c_label.height) / 2)
				else c_label.y = 0;
		
	}
	
	private function drawSelectedIcon(gr:Graphics, lineSize:Int, lineColor:Int, margin:Float):Void {
		gr.lineStyle(lineSize, lineColor);
		gr.moveTo(margin * .9, margin * 1.2);
		gr.lineTo(margin * 1.2, margin * 1.8);
		gr.lineTo(margin * 2.1, margin);
	}
	
	private function drawNonSelectedIcon(gr:Graphics, lineSize:Int, lineColor:Int, margin:Float):Void {
		gr.lineStyle(lineSize, lineColor);
		gr.moveTo(margin, margin);
		gr.lineTo(margin * 2, margin * 2);
		gr.moveTo(margin, margin * 2);
		gr.lineTo(margin * 2, margin);
	}
	
}