package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.CheckBox;
import flash.display.BlendMode;
import flash.display.DisplayObject;
import flash.display.GradientType;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

/**
 * ...
 * @author Ilic S Stojan
 */

class CheckBoxSkin implements ISkin{

	
	
	public function new() {
		
	}
	
	public function draw(client: BaseComponent, states: Map<String,DisplayObject>):Void {
		var c_client:CheckBox = cast(client);
		var c_rounded:Bool;
		var c_lineSize:Int = 2;
		var c_iconMargin:Float = 2; //margin for icon
		var c_shape:Shape;
		var c_matrix:Matrix;
		
		if (c_client.roundness > 0) c_rounded = true
			else c_rounded = false;
		c_matrix = new Matrix();
		c_matrix.createGradientBox(c_client.buttonSize, c_client.buttonSize, Math.PI / 2);
		
		c_lineSize = Math.round( c_client.buttonSize / 8 );
		c_iconMargin = c_client.buttonSize / 3;
		
		drawBackground(c_client, c_rounded);
		
		drawUpState(getState(CheckBox.UP, states, BlendMode.MULTIPLY), c_client, c_rounded, c_lineSize, c_iconMargin, c_matrix);
		drawNonSelectedIcon(getState(CheckBox.OVER, states).graphics, c_lineSize, c_client.iconColor, c_iconMargin);
		drawDownState(getState(CheckBox.DOWN, states), c_client, c_rounded, c_lineSize, c_iconMargin, c_matrix);
		drawSelectedState(getState(CheckBox.SELECTED_UP, states, BlendMode.MULTIPLY), c_client, c_rounded, c_lineSize, c_iconMargin, c_matrix);
		drawSelectedIcon(getState(CheckBox.SELECTED_OVER, states).graphics, c_lineSize, c_client.iconColor, c_iconMargin);
		drawSelectedState(getState(CheckBox.SELECTED_DOWN, states), c_client, c_rounded, c_lineSize, c_iconMargin, c_matrix);
		
		processLabel(c_client);
		
		drawHitBackground(c_client);
	}
	
	private function getState(name:String, states: Map<String,DisplayObject>, ?blendMode:BlendMode):Shape {
		var c_shape:Shape;
		
		if (states.exists(name)) return cast(states.get(name));
		
		c_shape = new Shape();
		if (blendMode != null) c_shape.blendMode = blendMode;
		states.set(name, c_shape);
		
		return c_shape;
	}
	
	private function processLabel(client:CheckBox):Void {
		var c_label:TextField;
		
		c_label = client.labelField;
		c_label.x = client.buttonSize + 5;
		if (client.Width > 0) c_label.width = client.Width - c_label.x;
		c_label.textColor = client.color;
		if (client.Height > 0) c_label.y = Math.round( (client.Height - c_label.height) / 2)
			else if (client.buttonSize > 0) c_label.y = Math.round( (client.buttonSize - c_label.height) / 2)
				else c_label.y = 0;
	}
	
	private function drawHitBackground(client:CheckBox):Void {
		var c_g:Graphics;
		var c_width:Float;
		var c_height:Float;
		c_g = client.graphics;
		
		c_width = Math.max(client.buttonSize, client.labelField.x + client.labelField.width);
		c_height = Math.max(client.buttonSize, client.labelField.height);
		
		//because in CPP textfield isn't clicable we need to fill this textField area
		#if cpp
		c_g.beginFill(0, 0.005);
		c_g.drawRect(0, 0, c_width, c_height);
		c_g.endFill();
		#end
	}
	
	private function drawBackground(client:CheckBox, rounded:Bool):Void {
		var c_gr:Graphics;
		c_gr = client.graphics;
		c_gr.clear();
		
		c_gr.beginFill(client.backgroundColor);
		if (client.borderColor > 0) c_gr.lineStyle(1, client.borderColor);
		if (rounded) c_gr.drawRoundRect(0, 0, client.buttonSize, client.buttonSize, client.roundness, client.roundness)
			else c_gr.drawRect(0, 0, client.buttonSize, client.buttonSize);
		c_gr.endFill();
		
	}
	
	private function drawUpState(state:Shape, client:CheckBox, rounded:Bool, lineSize:Int, iconMargin:Float, matrix:Matrix):Void {
		var c_gr:Graphics;
		c_gr = state.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0], [0, .15], [0, 255], matrix);
		if (rounded) c_gr.drawRoundRect(0, 0, client.buttonSize, client.buttonSize, client.roundness, client.roundness)
			else c_gr.drawRect(0, 0, client.buttonSize, client.buttonSize);
		drawNonSelectedIcon(c_gr, lineSize, client.iconColor, iconMargin);
		c_gr.endFill();
		
	}
	
	private function drawDownState(state:Shape, client:CheckBox, rounded:Bool, lineSize:Int, iconMargin:Float, matrix:Matrix):Void {
		var c_gr:Graphics;
		c_gr = state.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0, 0], [.5, .3, 0.05], [0, 16, 255], matrix);
		if (rounded) c_gr.drawRoundRect(0, 0, client.buttonSize, client.buttonSize, client.roundness, client.roundness)
			else c_gr.drawRect(0, 0, client.buttonSize, client.buttonSize);
		drawNonSelectedIcon(c_gr, lineSize, client.iconColor, iconMargin);
		c_gr.endFill();
		
	}
	
	private function drawSelectedState(state:Shape, client:CheckBox, rounded:Bool, lineSize:Int, iconMargin:Float, matrix:Matrix):Void {
		var c_gr:Graphics;
		c_gr = state.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0], [0, .15], [0, 255], matrix);
		if (rounded) c_gr.drawRoundRect(0, 0, client.buttonSize, client.buttonSize, client.roundness, client.roundness)
			else c_gr.drawRect(0, 0, client.buttonSize, client.buttonSize);
		c_gr.endFill();
		drawSelectedIcon(c_gr, lineSize, client.iconColor, iconMargin);
	}
	
	private function drawSelectedDownState(state:Shape, client:CheckBox, rounded:Bool, lineSize:Int, iconMargin:Float, matrix:Matrix):Void {
		var c_gr:Graphics;
		c_gr = state.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0, 0], [.5, .3, 0.05], [0, 16, 255], matrix);
		if (rounded) c_gr.drawRoundRect(0, 0, client.buttonSize, client.buttonSize, client.roundness, client.roundness)
			else c_gr.drawRect(0, 0, client.buttonSize, client.buttonSize);
		c_gr.endFill();
		drawSelectedIcon(c_gr, lineSize, client.iconColor, iconMargin);
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