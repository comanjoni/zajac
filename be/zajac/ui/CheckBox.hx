package be.zajac.ui;
import be.zajac.skins.CheckBoxSkin;
import be.zajac.util.TextFieldUtil;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author Ilic S Stojan
 */

class CheckBox extends StyledComponent{

	inline public static var UP:			String = 'up';
	inline public static var OVER:			String = 'over';
	inline public static var DOWN:			String = 'down';
	inline public static var SELECTED_UP:	String = 'sel_up';
	inline public static var SELECTED_OVER:	String = 'sel_over';
	inline public static var SELECTED_DOWN:	String = 'sel_down';
	
	@style(0) 			public var color(dynamic, dynamic): Dynamic;			//text color
	@style(0xffffff) 	public var backgroundColor(dynamic, dynamic): Dynamic;	//backgroundColor
	@style(20) 			public var buttonSize(dynamic, dynamic): Dynamic;		//size of checked icon in pixels
	@style(0x666666) 	public var iconColor(dynamic, dynamic): Dynamic;		//color of X of ok icon in the middle of the button box
	@style(0) 			public var roundness(dynamic, dynamic): Dynamic;
	@style( -1)			public var borderColor(dynamic, dynamic): Dynamic;
	
	
	private var _tLabel:TextField;
	private function get_tLabel():TextField {
		return _tLabel;
	}
	public var labelField(get_tLabel, null):TextField;
	
	private var _isOver:Bool;
	
	private var _label:String;
	private function get_label():String {
		return _label;
	}
	private function set_label(value:String):String {
		if (value == null) _label = ""
			else _label = value;
		_tLabel.text = _label;
		return _label;
	}
	public var label(get_label, set_label):String;
	
	private var _selected:Bool;
	private function get_selected():Bool {
		return _selected;
	}
	private function set_selected(value:Bool):Bool {
		var c_changed:Bool = false;
		
		if (_selected != value) c_changed = true;
		
		_selected = value;
		
		
		if (_isOver) state = getRightState(OVER)
			else state = getRightState(UP);
		
		if (c_changed) dispatchEvent(new Event(Event.CHANGE));
		return _selected;
	}
	public var selected(get_selected, set_selected):Bool;
	
	
	public function new() {
		super();
		
		_tLabel = new TextField();
		TextFieldUtil.fillFieldFromObject(_tLabel, { align:TextFormatAlign.LEFT, multiline:false, autoSize:TextFieldAutoSize.LEFT, selectable:false, mouseEnabled:false, size:14 } );
		addChild(_tLabel);
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
		#if (!android && !ios)
		addEventListener(MouseEvent.ROLL_OVER, 	onMouseOver);
		addEventListener(MouseEvent.ROLL_OUT, 	onMouseOut);
		buttonMode = true;
		#end
		
		run();
	}
	
	private function run():Void {
		skinClass = CheckBoxSkin;
		state = UP;
	}
	
	private function onMouseDown(e:MouseEvent):Void {
		selected = !_selected;
	}
	
	private function onMouseUp(e:MouseEvent):Void {
		if (_isOver) state = getRightState(OVER)
			else state = getRightState(UP);
	}
	
	private function onMouseOver(e:MouseEvent):Void {
		_isOver = true;
		state = getRightState(OVER);
	}
	
	private function onMouseOut(e:MouseEvent):Void {
		_isOver = false;
		state = getRightState(UP);
	}
	
	private function getRightState(state:String):String {
		if (_selected) return "sel_" + state;
		return state;
	}
	
}