package be.zajac.ui;
import be.zajac.skins.ButtonSkin;
import nme.events.MouseEvent;

/**
 * ...
 * @author Ilic S Stojan
 */

class Button extends StyledComponent{

	inline public static var UP:	String = 'up';
	inline public static var OVER:	String = 'over';
	inline public static var DOWN:	String = 'down';
	
	@style(0) 			public var color(dynamic, dynamic): Int;			//text color
	@style(0xffffff) 	public var backgroundColor(dynamic, dynamic): Int;	//backgroundColor
	@style(0) 			public var roundness(dynamic, dynamic): Int;
	@style( -1)			public var borderColor(dynamic, dynamic): Int;
	
	private var _isOver:Bool;
	
	public function new() {
		super();
		skin = new ButtonSkin();
		state = UP;
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
		#if (!android && !ios)
		addEventListener(MouseEvent.ROLL_OVER, 	onMouseOver);
		addEventListener(MouseEvent.ROLL_OUT, 	onMouseOut);
		buttonMode = true;
		#end
	}
	
	private function onMouseDown(e:MouseEvent):Void {
		state = DOWN;
	}
	
	private function onMouseUp(e:MouseEvent):Void {
		if (_isOver) state = OVER
			else state = UP;
	}
	
	private function onMouseOver(e:MouseEvent):Void {
		_isOver = true;
		state = OVER;
	}
	
	private function onMouseOut(e:MouseEvent):Void {
		_isOver = false;
		state = UP;
	}
	
}