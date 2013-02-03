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

class Button extends StyledComponent {

	inline public static var UP:	String = 'up';
	inline public static var OVER:	String = 'over';
	inline public static var DOWN:	String = 'down';
	
	//******************************
	//		PUBLIC VARIABLES
	//******************************
	
	@style public var color: Int = 0;			//text color
	@style public var backgroundColor: Int = 0xffffff;	//backgroundColor
	@style public var roundness: Int = 0;
	@style public var borderColor: Null<Int> = 0xbfc0c2;
	
	public var labelField(default, null): TextField;
	
	public var label(default, set_label): String = '';
	
	//******************************
	//		PRIVATE VARIABLES
	//******************************
	
	private var _isOver:Bool;
	
	//******************************
	//		PUBLIC METHODS
	//******************************
	
	public function new() {
		super();
		defaultWidth = FWCore.getHeightUnit();
		defaultHeight = FWCore.getHeightUnit();
		mouseChildren = false;
	}
	
	//******************************
	//		PRIVATE METHODS
	//******************************
	
	override private function initialize(): Void {
		labelField = new TextField();
		labelField.autoSize = TextFieldAutoSize.LEFT;
		labelField.multiline = false;
		labelField.selectable = false;
		labelField.mouseEnabled = false;
		TextFieldUtil.fillFieldFromObject(labelField, { align: TextFormatAlign.LEFT, size: FWCore.getFontSize() } );
		addChild(labelField);
		
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
		#if !(android && ios)
		addEventListener(MouseEvent.MOUSE_OVER, 	onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, 	onMouseOut);
		buttonMode = useHandCursor = true;
		#end
		
		skinClass = ButtonSkin;
		state = UP;
	}
	
	//******************************
	//		GETTERS AND SETTERS
	//******************************
	
	private function set_label(value: String): String {
		if (value != label) {
			label = value;
			labelField.text = label;
			defaultWidth = labelField.width + FWCore.getHeightUnit();
			invalidSkin();
		}
		return value;
	}
	
	//******************************
	//		EVENT LISTENERS
	//******************************
	
	private function onMouseDown(e:MouseEvent):Void {
		if (!enabled) return;
		state = DOWN;
	}
	
	private function onMouseUp(e:MouseEvent):Void {
		if (!enabled) return;
		state = _isOver ? OVER : UP;
	}
	
	private function onMouseOver(e:MouseEvent):Void {
		if (!enabled) return;
		_isOver = true;
		state = OVER;
	}
	
	private function onMouseOut(e:MouseEvent):Void {
		if (!enabled) return;
		_isOver = false;
		state = UP;
	}
	
}