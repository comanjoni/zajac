package rs.zajac.skins;
import rs.zajac.ui.BaseComponent;
import rs.zajac.ui.RadioButton;
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

class RadioButtonSkin implements ISkin{

	
	
	public function new() {
		
	}
	
	public function draw(client: BaseComponent, states: Map<String,DisplayObject>):Void {
		var c_client:RadioButton = cast(client);
		var c_shape:Shape;
		var c_matrix:Matrix;
		
		c_matrix = new Matrix();
		c_matrix.createGradientBox(c_client.buttonSize, c_client.buttonSize, Math.PI / 2);
		
		drawBackground(c_client);
		
		drawUpState(getState(RadioButton.UP, states, BlendMode.MULTIPLY), c_client, c_matrix);
		drawIcon(getState(RadioButton.OVER, states).graphics, c_client.iconColor, c_client.buttonSize / 2, 0.3);
		drawDownState(getState(RadioButton.DOWN, states), c_client, c_matrix);
		drawSelectedState(getState(RadioButton.SELECTED, states) , c_client, c_matrix);
		
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
	
	private function processLabel(client:RadioButton):Void {
		var c_label:TextField;
		
		c_label = client.labelField;
		c_label.x = client.buttonSize + 5;
		if (client.Width > 0) c_label.width = client.Width - c_label.x;
		c_label.textColor = client.color;
		if (client.Height > 0) c_label.y = Math.round( (client.Height - c_label.height) / 2)
			else if (client.buttonSize > 0) c_label.y = Math.round( (client.buttonSize - c_label.height) / 2)
				else c_label.y = 0;
	}
	
	private function drawHitBackground(client:RadioButton):Void {
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
	
	private function drawBackground(client:RadioButton):Void {
		var c_gr:Graphics;
		var c_btnSize:Float;
		
		c_gr = client.graphics;
		c_gr.clear();
		c_gr.beginFill(client.backgroundColor);
		if (client.borderColor > 0) c_gr.lineStyle(1, client.borderColor);
		
		switch (client.roundness) {
			case -1:
				c_btnSize = client.buttonSize / 2;
				c_gr.drawCircle(c_btnSize, c_btnSize, c_btnSize);
			case 0: 
				c_gr.drawRect(0, 0, client.buttonSize, client.buttonSize);
			default: 
				c_gr.drawRoundRect(0, 0, client.buttonSize, client.buttonSize, client.roundness, client.roundness);
		}
		c_gr.endFill();
		
	}
	
	private function drawUpState(state:Shape, client:RadioButton, matrix:Matrix):Void {
		var c_gr:Graphics;
		var c_btnSize:Float;
		
		c_gr = state.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0], [0, .15], [0, 255], matrix);
		c_btnSize = client.buttonSize / 2;
		
		switch (client.roundness) {
			case -1:
				c_gr.drawCircle(c_btnSize, c_btnSize, c_btnSize);
			case 0: 
				c_gr.drawRect(0, 0, client.buttonSize, client.buttonSize);
			default: 
				c_gr.drawRoundRect(0, 0, client.buttonSize, client.buttonSize, client.roundness, client.roundness);
		}
		drawIcon(c_gr, client.iconColor, c_btnSize, 0.3);
		c_gr.endFill();
		
	}
	
	private function drawDownState(state:Shape, client:RadioButton, matrix:Matrix):Void {
		var c_gr:Graphics;
		var c_btnSize:Float;
		
		c_gr = state.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0, 0], [.5, .3, 0.05], [0, 16, 255], matrix);
		c_btnSize = client.buttonSize / 2;
		
		switch (client.roundness) {
			case -1:
				c_gr.drawCircle(c_btnSize, c_btnSize, c_btnSize);
			case 0: 
				c_gr.drawRect(0, 0, client.buttonSize, client.buttonSize);
			default: 
				c_gr.drawRoundRect(0, 0, client.buttonSize, client.buttonSize, client.roundness, client.roundness);
		}
		drawIcon(c_gr, client.iconColor, c_btnSize, 0.3);
		c_gr.endFill();
		
	}
	
	private function drawSelectedState(state:Shape, client:RadioButton, matrix:Matrix):Void {
		var c_gr:Graphics;
		var c_btnSize:Float;
		
		c_gr = state.graphics;
		c_gr.clear();
		c_gr.beginGradientFill(GradientType.LINEAR, [0, 0], [.1, .25], [0, 255], matrix);
		c_btnSize = client.buttonSize / 2;
		
		switch (client.roundness) {
			case -1:
				c_gr.drawCircle(c_btnSize, c_btnSize, c_btnSize);
			case 0: 
				c_gr.drawRect(0, 0, client.buttonSize, client.buttonSize);
			default: 
				c_gr.drawRoundRect(0, 0, client.buttonSize, client.buttonSize, client.roundness, client.roundness);
		}
		c_gr.endFill();
		drawIcon(c_gr, client.iconColor, c_btnSize);
		
	}
	
	private function drawIcon(gr:Graphics, color:Int, buttonSize:Float, ?alpha:Float = 1):Void {
		gr.beginFill(color, alpha);
		gr.drawCircle(buttonSize, buttonSize, buttonSize / 2);
		gr.endFill();
	}
	
}