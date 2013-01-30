package be.zajac.ui;
import be.zajac.core.FWCore;
import be.zajac.skins.ButtonSkin;
import be.zajac.util.TextFieldUtil;
import nme.events.MouseEvent;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author Ilic S Stojan
 */

class Button extends StyledComponent{

	inline public static var UP:	String = 'up';
	inline public static var OVER:	String = 'over';
	inline public static var DOWN:	String = 'down';
	
	@style public var color: Int = 0;			//text color
	@style public var backgroundColor: Int = 0xffffff;	//backgroundColor
	@style public var roundness: Int = 0;
	@style public var borderColor: Int = -1;
	
	
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
	
	public function new() {
		super();
		defaultWidth = FWCore.getHeightUnit() * 5;
		defaultHeight = FWCore.getHeightUnit();
		
		_tLabel = new TextField();
		TextFieldUtil.fillFieldFromObject(_tLabel, { align:TextFormatAlign.CENTER, multiline:false, autoSize:TextFieldAutoSize.CENTER, selectable:false, mouseEnabled:false, size: FWCore.getFontSize() } );
		addChild(_tLabel);
		
		skinClass = ButtonSkin;
		state = UP;
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
		#if (!android && !ios)
		addEventListener(MouseEvent.ROLL_OVER, 	onMouseOver);
		addEventListener(MouseEvent.ROLL_OUT, 	onMouseOut);
		buttonMode = true;
		#end
	}
	
	override public function validate():Void {
		super.validate();
		addChild(_tLabel);
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